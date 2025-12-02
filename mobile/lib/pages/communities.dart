import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/leaderboard.dart';
import 'package:mobile/services/profile_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/pages/notifications.dart';

final List<Map<String, dynamic>> testMyCommunities = [
  {
    'title': '100 Day Challenge',
    'description':
        'A 100 day accountability group that has been set up to help participants be the best of themselves.',
    'participants': [
      'assets/icons/temp/woman-1.jpg',
      'assets/icons/temp/man-2.jpg',
    ],
    'newPosts': 10,
  },
  {
    'title': '100 Day Challenge',
    'description':
        'A 100 day accountability group that has been set up to help participants be the best of themselves.',
    'participants': [
      'assets/icons/temp/man-1.jpg',
      'assets/icons/temp/woman-1.jpg',
      'assets/icons/temp/man-2.jpg',
    ],
    'newPosts': 10,
  },
];

final List<Map<String, dynamic>> testAllCommunities = [
  {
    'title': 'Test Community',
    'description':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit..',
    'participants': [
      'assets/icons/temp/woman-1.jpg',
      'assets/icons/temp/man-2.jpg',
    ],
  },
  {
    'title': 'Test Community',
    'description':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit..',
    'participants': [
      'assets/icons/temp/man-1.jpg',
      'assets/icons/temp/woman-1.jpg',
      'assets/icons/temp/man-2.jpg',
    ],
  },
  {
    'title': 'Test Community',
    'description':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit..',
    'participants': ['assets/icons/temp/man-1.jpg'],
  },
];

class Communities extends StatefulWidget {
  const Communities({super.key});

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities>
    with TickerProviderStateMixin {
  late AnimationController controller;
  final PageController _myCommunitiesController = PageController(
    viewportFraction: 0.8,
  );

  String? _profilePicUrl;
  bool _isLoadingProfile = true;

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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

    // when no picture is set
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildProfileAvatar(pad * 1.75),
                                    SizedBox(width: isSmall ? 10 : 14),
                                    Text(
                                      "Communities",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmall ? 8 : 12),

                                // --SEARCH BAR--
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Search",
                                            hintStyle: TextStyle(
                                              color: Color(0xFF9C9C9C),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Color(0xFF2A2A2A),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.search_rounded,
                                        color: Color(0xFF9C9C9C),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: isSmall ? 16 : 24),
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

                                // --MY COMMUNITIES--
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'My Communities',
                                          style: TextStyle(
                                            color: Color(0xFF2A2A2A),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'View all',
                                          style: TextStyle(
                                            color: Color(0xFF18B08E),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: isSmall ? 4 : 8),

                                    SizedBox(
                                      height: 190,
                                      child: PageView.builder(
                                        controller: _myCommunitiesController,
                                        padEnds: false,
                                        itemCount: testMyCommunities
                                            .length, //TODO: change testMyCommunities to actual data
                                        itemBuilder: (context, index) {
                                          final community =
                                              testMyCommunities[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            child: _myCommunity(
                                              community["title"],
                                              community["description"],
                                              community["participants"] ?? [],
                                              community["newPosts"],
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    Center(
                                      child: SmoothPageIndicator(
                                        controller: _myCommunitiesController,
                                        count: testMyCommunities.length,
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

                                // --DISCOVER COMMUNITIES--
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Discover',
                                      style: TextStyle(
                                        color: Color(0xFF2A2A2A),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'View all',
                                      style: TextStyle(
                                        color: Color(0xFF18B08E),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmall ? 4 : 8),

                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: testAllCommunities.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == testAllCommunities.length) {
                                        return SizedBox(height: 50);
                                      }
                                      final community =
                                          testAllCommunities[index]; //TODO: change testAllCommunities to actual data
                                      return _discoverCommunity(
                                        community["title"],
                                        community["description"],
                                        community["participants"] ?? [],
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                },
                icon: Icon(Icons.home_rounded, color: Color(0xFFB2B2B2)),
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
                onPressed: () {},
                icon: Icon(Icons.groups_rounded, color: Color(0xFF5FD1E2)),
                iconSize: 36,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NotificationsPage()),
                  );
                },
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
}

Container _myCommunity(
  String title,
  String description,
  List<String> participants,
  int newPosts,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color(0xFFEDEDED), width: 3),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: participants.length <= 2
                                  ? (participants.length <= 1 ? 24 : 42)
                                  : 60,
                              height: 32,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ...participants
                                      .take(2)
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        return Positioned(
                                          left: entry.key * 18,
                                          child: Container(
                                            width: 30,
                                            height: 30,
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
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                          color: Color(0xFF18B08E),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "+${participants.length - 2}",
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
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.share_rounded,
                                color: Color(0xFFF6851F),
                                size: 20,
                              ),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),

                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A2A2A),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2A2A2A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFF76A6D), Color(0xFFF2AF77)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(6),
                              bottom: Radius.circular(6),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              '$newPosts New Posts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Container _discoverCommunity(
  String title,
  String description,
  List<String> participants,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color(0xFFEDEDED), width: 3),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A2A2A),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2A2A2A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: participants.length <= 2
                                  ? (participants.length <= 1 ? 24 : 42)
                                  : 60,
                              height: 30,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ...participants
                                      .take(2)
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        return Positioned(
                                          left: entry.key * 18,
                                          child: Container(
                                            width: 30,
                                            height: 30,
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
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                          color: Color(0xFF18B08E),
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
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF76A6D),
                                    Color(0xFFF3A175),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.all(2),
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
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return const LinearGradient(
                                              colors: [
                                                Color(0xFFF76A6D),
                                                Color(0xFFF3A175),
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                            ).createShader(bounds);
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return const LinearGradient(
                                              colors: [
                                                Color(0xFFF57A70),
                                                Color(0xFFF49875),
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                            ).createShader(bounds);
                                          },
                                          child: const Text(
                                            "Join",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
