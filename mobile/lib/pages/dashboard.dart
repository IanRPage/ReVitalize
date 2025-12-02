import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile/services/habit_service.dart';
import 'package:mobile/widgets/nav_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/services/profile_service.dart';

final List<Map<String, dynamic>> testChallenges = [
  {
    'title': '10K Steps/Week',
    'progress': 0.5,
    'timeLeft': '3 days 2 hours left',
    'participants': [
      'assets/icons/temp/woman-1.jpg',
      'assets/icons/temp/man-2.jpg',
    ],
  },
  {
    'title': 'Drink 2L of Water',
    'progress': 0.8,
    'timeLeft': '1 day 12 hours left',
    'participants': ['assets/icons/temp/man-1.jpg'],
  },
  {
    'title': 'Run a mile',
    'progress': 0.8,
    'timeLeft': '1 day 12 hours left',
    'participants': [
      'assets/icons/temp/man-1.jpg',
      'assets/icons/temp/woman-1.jpg',
      'assets/icons/temp/man-2.jpg',
    ],
  },
];

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController controller;
  final PageController _challengeController = PageController();

  String? _profilePicUrl;
  bool _isLoadingProfile = true;

  final HabitService _habitService = HabitService();
  List<Map<String, dynamic>> _habits = [];
  StreamSubscription<List<Map<String, dynamic>>>? _habitsSub;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          })
          ..repeat(reverse: true);
    _loadProfile();
    _listenToHabits();
  }

  @override
  void dispose() {
    _habitsSub?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _listenToHabits() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _habitsSub = _habitService
        .watchHabits(uid: uid)
        .listen(
          (habits) {
            setState(() {
              _habits = habits;
            });
          },
          onError: (e, st) {
            debugPrint('Error watching habits: $e');
            debugPrint('$st');
          },
        );
  }

  Future<void> _loadProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final profileService = ProfileService();
      final data = await profileService.getProfile(uid: uid);

      setState(() {
        _profilePicUrl = data?['profilePic'] as String?;
        _isLoadingProfile = false;
      });
    } catch (e, st) {
      debugPrint('Error loading profile: $e');
      debugPrint('$st');
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _loadHabits() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final habits = await _habitService.getHabits(uid: uid);

      setState(() {
        _habits = habits;
      });
    } catch (e, st) {
      debugPrint('Error loading habits: $e');
      debugPrint('$st');
      setState(() {});
    }
  }

  Widget _buildProfileAvatar(double size) {
    final radius = size / 2;

    if (_isLoadingProfile) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    // when no picture set
    if (_profilePicUrl == null || _profilePicUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        child: const Icon(Icons.person, color: Colors.white, size: 28),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      backgroundImage: NetworkImage(_profilePicUrl!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habits = _habits;
    final int totalHabits = habits.length;
    final int completed = habits
        .where((habit) => habit['todayProgress'] == 1.0)
        .length;
    final double streakProgress = totalHabits == 0
        ? 0.0
        : completed / totalHabits;
    final List<String> days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];
    final int currentStreak = computeCurrentStreak(habits);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //--GRADIENT--
          Container(
            height: 320,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF01AAD0), Color(0xFF26D7AD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final h = c.maxHeight;
                final pad = w * 0.08;
                final maxContent = 560.0;
                final isSmall = h < 730;

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxContent,
                    minHeight: h,
                  ),
                  child: Column(
                    children: [
                      // --HEADER--
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: pad / 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: isSmall ? 12 : 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileAvatar(pad * 1.75),
                                SizedBox(width: isSmall ? 10 : 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      TimeChecker.getTimeOfDayGreeting(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      TimeChecker.getFullDate(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: isSmall ? pad / 2 : pad / 1.75,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: pad,
                              vertical: isSmall ? pad / 2.5 : pad / 1.5,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 8),

                                // -- PROGRESS --
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: days
                                      .map((d) => _mainDayProgress(d, _habits))
                                      .toList(),
                                ),

                                SizedBox(height: isSmall ? 12 : 20),

                                // --CURRENT STREAK--
                                Container(
                                  width: double.infinity,
                                  height: pad * 2.5,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFF2AF77),
                                        Color(0xFFF76A6D),
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topCenter,
                                    ),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8),
                                      bottom: Radius.circular(8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: pad / 2,
                                      vertical: pad / 3,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Current Streak',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '$currentStreak ${(currentStreak > 1 || currentStreak == 0) ? 'days' : 'day'}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: isSmall ? 4 : 8),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: LinearProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xFFFFFFFF)),
                                                value: streakProgress,
                                                backgroundColor: Colors.white
                                                    .withValues(alpha: 0.35),
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(8),
                                                      bottom: Radius.circular(
                                                        8,
                                                      ),
                                                    ),
                                                minHeight: 6,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${(streakProgress * 100).toInt()}%',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: isSmall ? 8 : 16),

                                // --CHALLENGES--
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Challenges',
                                          style: TextStyle(
                                            color: Color(0xFF2A2A2A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              {}, // TODO: view all behavior on Challenges
                                          child: Text(
                                            'View all',
                                            style: TextStyle(
                                              color: Color(0xFF18B08E),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: isSmall ? 4 : 8),

                                    SizedBox(
                                      height: 90,
                                      child: PageView.builder(
                                        controller: _challengeController,
                                        itemCount: testChallenges
                                            .length, //TODO: change testChallenges to actual data
                                        itemBuilder: (context, index) {
                                          final challenge =
                                              testChallenges[index];
                                          return _challenge(
                                            challenge['title'],
                                            challenge['progress'],
                                            challenge['timeLeft'],
                                            challenge['participants'] ?? [],
                                          );
                                        },
                                      ),
                                    ),

                                    Center(
                                      child: SmoothPageIndicator(
                                        controller: _challengeController,
                                        count: testChallenges.length,
                                        effect: ExpandingDotsEffect(
                                          dotHeight: isSmall ? 3 : 6,
                                          dotWidth: 6,
                                          spacing: 6,
                                          activeDotColor: Color(0xFF5FD1E2),
                                          dotColor: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // --HABITS--
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Habits',
                                      style: TextStyle(
                                        color: Color(0xFF2A2A2A),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          {}, // TODO: view all behavior on Habits
                                      child: Text(
                                        'View all',
                                        style: TextStyle(
                                          color: Color(0xFF18B08E),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmall ? 4 : 8),

                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: _habits.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == _habits.length) {
                                        return SizedBox(height: 50);
                                      }
                                      final habit = _habits[index];
                                      return _habit(
                                        habit['id'],
                                        habit['title'],
                                        habit['targetValue'],
                                        habit['todayValue'],
                                        habit['unit'],
                                        habit['todayProgress'],
                                        habit['completedDays'] ?? [],
                                        habit['themeColor'],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // --ADD NEW BUTTON--
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF76A6D), Color(0xFFF3A175)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                ),
                padding: const EdgeInsets.all(3),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    splashColor: const Color(0xFFF76A6D).withAlpha(51),
                    highlightColor: const Color(0xFFF3A175).withAlpha(38),
                    onTap: () {
                      debugPrint("'Add new' button tapped");
                      _showAddHabitBottomSheet();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Color(0xFFF76A6D), Color(0xFFF3A175)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.add,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Color(0xFFF57A70), Color(0xFFF49875)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              "Add new",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      //--NAVIGATION BAR--
      bottomNavigationBar: NavBar(
        dashboardColor: Color(0xFF18B08E),
        leaderboardColor: Color(0xFFB2B2B2),
        communitiesColor: Color(0xFFB2B2B2),
        notificationsColor: Color(0xFFB2B2B2),
        profileColor: Color(0xFFB2B2B2),
        currentPage: NavPage.dashboard,
      ),
    );
  }

  Stack _mainDayProgress(String day, List<Map<String, dynamic>> habits) {
    final int total = habits.length;
    final int completed = habits
        .where((habit) => habit["completedDays"].contains(day))
        .length;
    final double progress = total == 0 ? 0.0 : completed / total;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5FD1E2)),
              value: progress,
              backgroundColor: Color(0xFFEDEDED),
            ),
          ),
        ),
        Center(
          child: Text(
            day.substring(0, 1),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFAAAAAA),
            ),
          ),
        ),
      ],
    );
  }

  // for weekday bubbles in each habit card
  Stack _habitDayProgress(
    String day,
    String themeColor,
    List<String> completedDays,
  ) {
    final Map<String, List<Color>> themeGradients = {
      "blue": [Color(0xFFC0F4FF), Color(0xFF33DFF9)],
      "green": [Color(0xFFC0FFF1), Color(0xFF26D7AE)],
      "red": [Color(0xFFFFCFC0), Color(0xFFF7616B)],
      "orange": [Color(0xFFFFDEC0), Color(0xFFFF8129)],
    };

    bool isCompleted = completedDays.contains(day);
    String letter = day.substring(0, 1);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            gradient: isCompleted
                ? LinearGradient(
                    colors:
                        themeGradients[themeColor] ??
                        [Colors.grey, Colors.grey],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  )
                : null,
            shape: BoxShape.circle,
            border: isCompleted
                ? null
                : Border.all(color: Color(0xFFEDEDED), width: 2),
          ),
        ),
        Text(
          letter,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isCompleted ? Colors.white : Color(0xFFAAAAAA),
          ),
        ),
      ],
    );
  }

  Container _challenge(
    String title,
    double progress,
    String timeLeft,
    List<String> participants,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFEDEDED), width: 3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/clock.svg', width: 30, height: 30),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A2A2A),
                            ),
                          ),
                          Text(
                            timeLeft,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 6),
                    SizedBox(
                      width: participants.length <= 2
                          ? (participants.length <= 1 ? 24 : 42)
                          : 60,
                      height: 26,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ...participants.take(2).toList().asMap().entries.map((
                            entry,
                          ) {
                            return Positioned(
                              left: entry.key * 18,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(entry.value),
                                  ),
                                ),
                              ),
                            );
                          }),

                          if (participants.length > 2)
                            Positioned(
                              left: 2 * 18,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  color: Color(0xFF5FD1E2),
                                ),
                                child: Center(
                                  child: Text(
                                    "+${(participants.length - 2) % 2}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF5FD1E2)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _habit(
    String habitId,
    String title,
    int targetValue,
    int currentValue,
    String unit,
    double progress,
    List<String> completedDays,
    String themeColor,
  ) {
    final Map<String, Color> themeColors = {
      "blue": const Color(0xFF5FD1E2),
      "green": const Color(0xFF26D7AD),
      "red": const Color(0xFFF7616B),
      "orange": const Color(0xFFFF8129),
      "purple": const Color(0xFFB169F7),
      "yellow": const Color(0xFFFFD74A),
      "teal": const Color(0xFF3FD1C6),
      "pink": const Color(0xFFFF6BA8),
    };

    final List<String> weekDays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFEDEDED), width: 3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    themeColors[themeColor] ?? Colors.grey,
                  ),
                  backgroundColor: Color(0xFFEDEDED),
                ),
              ),

              if (progress >= 1.0)
                Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: themeColors[themeColor] ?? Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
            ],
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A2A2A),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              "$currentValue / $targetValue $unit",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 6),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: weekDays.map((day) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _habitDayProgress(day, themeColor, completedDays),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              _showIncrementHabitDialog(
                habitId: habitId,
                title: title,
                unit: unit,
                currentValue: currentValue,
                targetValue: targetValue,
              );
            },
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: themeColors[themeColor]!.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 24,
                color: themeColors[themeColor],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showIncrementHabitDialog({
    required String habitId,
    required String title,
    required String unit,
    required int currentValue,
    required int targetValue,
  }) async {
    final controller = TextEditingController(text: '1'); // default increment

    final int? delta = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (targetValue > 0)
                Text(
                  'Today: $currentValue / $targetValue $unit',
                  style: const TextStyle(fontSize: 14),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount to add',
                  suffixText: unit,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                final value = int.tryParse(text);
                if (value == null || value <= 0) {
                  return;
                }
                Navigator.of(context).pop(value);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (delta == null) return; // user cancelled

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await _habitService.addToHabitToday(
        uid: uid,
        habitId: habitId,
        delta: delta,
      );

      await _loadHabits();
    } catch (e, st) {
      debugPrint('Error incrementing habit: $e');
      debugPrint('$st');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update habit. Please try again.'),
          ),
        );
      }
    }
  }

  void _showAddHabitBottomSheet() {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final unitController = TextEditingController(text: 'min');

    String selectedThemeColor = 'green';
    final themeColors = <String, Color>{
      "blue": const Color(0xFF5FD1E2),
      "green": const Color(0xFF26D7AD),
      "red": const Color(0xFFF7616B),
      "orange": const Color(0xFFFF8129),
      "purple": const Color(0xFFB169F7),
      "yellow": const Color(0xFFFFD74A),
      "teal": const Color(0xFF3FD1C6),
      "pink": const Color(0xFFFF6BA8),
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const Text(
                    'Add new habit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2A2A2A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Habit name
                  const Text(
                    'Habit name',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Drink Water',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Target + Unit
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Target',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: targetController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'e.g. 2500',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unit',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF666666),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: unitController,
                              decoration: InputDecoration(
                                hintText: 'ml / min / km',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Theme color chips
                  const Text(
                    'Theme color',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: themeColors.entries.map((entry) {
                      final key = entry.key;
                      final color = entry.value;
                      final isSelected = selectedThemeColor == key;

                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedThemeColor = key;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withAlpha(38)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isSelected ? color : Colors.grey.shade300,
                              width: 1.3,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                key[0].toUpperCase() + key.substring(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.black
                                      : const Color(0xFF555555),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF18B08E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final targetText = targetController.text.trim();
                        final unit = unitController.text.trim().isEmpty
                            ? 'unit'
                            : unitController.text.trim();

                        if (title.isEmpty || targetText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in name and target.'),
                            ),
                          );
                          return;
                        }

                        final targetValue = int.tryParse(targetText) ?? 0;

                        final uid = FirebaseAuth.instance.currentUser!.uid;

                        await _habitService.addHabit(
                          uid: uid,
                          title: title,
                          targetValue: targetValue,
                          unit: unit,
                          themeColor: selectedThemeColor,
                        );

                        Navigator.of(context).pop();
                        await _loadHabits();
                      },
                      child: const Text(
                        'Add habit',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  int computeCurrentStreak(List<Map<String, dynamic>> habits) {
    final daysOrder = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    final int today = DateTime.now().weekday - 1;
    int index = today - 1;
    if (index < 0) index = 6;
    int streak = 0;

    for (int i = 0; i < 7; i++) {
      final String day = daysOrder[index];

      final int completedToday = habits
          .where((habit) => habit['completedDays'].contains(day))
          .length;

      if (completedToday == habits.length) {
        streak++;
      } else {
        break;
      }

      index--;
      if (index < 0) index = 6;
    }

    return streak;
  }
}

class TimeChecker {
  static String getTimeOfDayGreeting() {
    final currentTime = DateTime.now();
    final hour = currentTime.hour;

    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 18) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  static String getFullDate() {
    final currentTime = DateTime.now();
    return DateFormat('EEEE, MMM d').format(currentTime);
  }
}
