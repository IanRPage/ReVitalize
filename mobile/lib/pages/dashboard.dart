import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mobile/pages/leaderboard.dart';
import 'package:mobile/pages/communities.dart';

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

final List<Map<String, dynamic>> testHabits = [
  {
    'title': 'Drink Water',
    'currentValue': 1000,
    'targetValue': 2500,
    'unit': 'ml',
    'progress': 0.5,
    'completedDays': ["Monday", "Thursday"],
    'themeColor': 'green',
  },
  {
    'title': 'Workout',
    'currentValue': 2,
    'targetValue': 2500,
    'unit': 'hrs',
    'progress': 1.0,
    'completedDays': ["Monday", "Wednesday", "Thursday"],
    'themeColor': 'red',
  },
  {
    'title': 'Meditate',
    'currentValue': 0,
    'targetValue': 20,
    'unit': 'min',
    'progress': 0.0,
    'completedDays': ["Monday", "Thursday"],
    'themeColor': 'orange',
  },
  {
    'title': 'Swim',
    'currentValue': 0,
    'targetValue': 20,
    'unit': 'km',
    'progress': 0.3,
    'completedDays': ["Tuesday", "Wednesday", "Thursday"],
    'themeColor': 'blue',
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

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          })
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalHabits =
        testHabits.length; // TODO: change testHabits to actual data
    final int completed = testHabits
        .where((habit) => habit["progress"] == 1.0)
        .length; // TODO: change testHabits to actual data
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
    final int currentStreak = computeCurrentStreak(
      testHabits,
    ); //TODO: change testHabits to actual data

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
                                Icon(
                                  Icons
                                      .circle, //TODO: Change to profile picture
                                  color: Colors.white,
                                  size: pad * 1.75,
                                ),
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
                                      .map(
                                        (d) => _mainDayProgress(d, testHabits),
                                      )
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
                                            challenge["title"],
                                            challenge["progress"],
                                            challenge["timeLeft"],
                                            challenge["participants"] ?? [],
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
                                    itemCount: testHabits.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == testHabits.length) {
                                        return SizedBox(height: 50);
                                      }
                                      final habit =
                                          testHabits[index]; //TODO: change testHabits to actual data
                                      return _habit(
                                        habit["title"],
                                        habit["targetValue"],
                                        habit["currentValue"],
                                        habit["unit"],
                                        habit["progress"],
                                        habit["completedDays"] ?? [],
                                        habit["themeColor"],
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
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF76A6D), Color(0xFFF3A175)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      // TODO: action on tap
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home_rounded, color: Color(0xFF18B08E)),
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Leaderboard(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFB2B2B2),
                ),
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Communities(),
                    ),
                  );
                },
                icon: Icon(Icons.groups_rounded, color: Color(0xFFB2B2B2)),
                iconSize: 36,
              ),
              IconButton(
                onPressed: () {}, //TODO: navigate to notifications page
                icon: Icon(
                  Icons.notifications_rounded,
                  color: Color(0xFFB2B2B2),
                ),
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {}, //TODO: navigate to profile page
                icon: Icon(Icons.person_rounded, color: Color(0xFFB2B2B2)),
                iconSize: 32,
              ),
            ],
          ),
        ),
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
    String title,
    int targetValue,
    int currentValue,
    String unit,
    double progress,
    List<String> completedDays,
    String themeColor,
  ) {
    final Map<String, Color> themeColors = {
      "blue": Color(0xFF5FD1E2),
      "green": Color(0xFF26D7AD),
      "red": Color(0xFFF7616B),
      "orange": Color(0xFFFF8129),
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

              if (progress == 1.0)
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
              // TODO: Add Habit popup
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

  int computeCurrentStreak(List<Map<String, dynamic>> habits) {
    final daysOrder = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ]; // to match DateTime order
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
