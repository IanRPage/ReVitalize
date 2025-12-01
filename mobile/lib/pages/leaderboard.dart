import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/pages/communities.dart';
import 'package:mobile/services/profile_service.dart';

final List<Map<String, dynamic>> testGetCommunities = [
  {
    'title': '100 Day Challenge',
    'categories': ['Wellth', 'Miles'],
    'selectedCategory': 'Wellth',
    "dataByCategory": {
      "Wellth": {
        "leaderboard": [
          {
            "rank": 1,
            "name": "charlotte",
            "handle": "@charlotte",
            "score": 1200,
            "avatar": "assets/icons/temp/woman-1.jpg",
            "isCurrentUser": false,
          },
          {
            "rank": 2,
            "name": "brian",
            "handle": "@brian",
            "score": 1020,
            "avatar": "assets/icons/temp/man-2.jpg",
            "isCurrentUser": false,
          },
          {
            "rank": 3,
            "name": "robert",
            "handle": "@robert",
            "score": 1010,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 4,
            "name": "alex",
            "handle": "@alex",
            "score": 949,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 5,
            "name": "caroline",
            "handle": "@caroline",
            "score": 948,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 6,
            "name": "martin",
            "handle": "@martin",
            "score": 947,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 7,
            "name": "sara",
            "handle": "@sara",
            "score": 946,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 8,
            "name": "megan",
            "handle": "@megan",
            "score": 945,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 9,
            "name": "nathan",
            "handle": "@nathan",
            "score": 944,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 10,
            "name": "cara",
            "handle": "@cara",
            "score": 943,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 11,
            "name": "devin",
            "handle": "@devin",
            "score": 900,
            "avatar": "assets/icons/temp/man-1.jpg",
            "isCurrentUser": true,
          },
        ],
      },
      "Miles": {
        "leaderboard": [
          {
            "rank": 1,
            "name": "charlotte",
            "handle": "@charlotte",
            "score": 1200,
            "avatar": "assets/icons/temp/woman-1.jpg",
            "isCurrentUser": false,
          },
          {
            "rank": 2,
            "name": "brian",
            "handle": "@brian",
            "score": 1020,
            "avatar": "assets/icons/temp/man-2.jpg",
            "isCurrentUser": false,
          },
          {
            "rank": 3,
            "name": "robert",
            "handle": "@robert",
            "score": 1010,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 4,
            "name": "alex",
            "handle": "@alex",
            "score": 949,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 5,
            "name": "caroline",
            "handle": "@caroline",
            "score": 948,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 6,
            "name": "martin",
            "handle": "@martin",
            "score": 947,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 7,
            "name": "sara",
            "handle": "@sara",
            "score": 946,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 8,
            "name": "megan",
            "handle": "@megan",
            "score": 945,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 9,
            "name": "nathan",
            "handle": "@nathan",
            "score": 944,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 10,
            "name": "cara",
            "handle": "@cara",
            "score": 943,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 11,
            "name": "devin",
            "handle": "@devin",
            "score": 900,
            "avatar": "assets/icons/temp/man-1.jpg",
            "isCurrentUser": true,
          },
        ],
      },
    },
  },
  {
    'title': 'Test Community',
    'categories': ['Wellth', 'Miles'],
    "dataByCategory": {
      "Wellth": {
        "leaderboard": [
          {
            "rank": 1,
            "name": "charlotte",
            "handle": "@charlotte",
            "score": 1200,
            "avatar": "assets/icons/temp/woman-1.jpg",
            "isCurrentUser": false,
          },
          {
            "rank": 2,
            "name": "brian",
            "handle": "@brian",
            "score": 1020,
            "avatar": "assets/icons/temp/man-2.jpg",
            "isCurrentUser": false,
          },
          {
            "rank": 3,
            "name": "robert",
            "handle": "@robert",
            "score": 1010,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 4,
            "name": "alex",
            "handle": "@alex",
            "score": 949,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 5,
            "name": "caroline",
            "handle": "@caroline",
            "score": 948,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 6,
            "name": "martin",
            "handle": "@martin",
            "score": 947,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 7,
            "name": "sara",
            "handle": "@sara",
            "score": 946,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 8,
            "name": "megan",
            "handle": "@megan",
            "score": 945,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 9,
            "name": "nathan",
            "handle": "@nathan",
            "score": 944,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 10,
            "name": "cara",
            "handle": "@cara",
            "score": 943,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 11,
            "name": "devin",
            "handle": "@devin",
            "score": 900,
            "avatar": "assets/icons/temp/man-1.jpg",
            "isCurrentUser": true,
          },
        ],
      },
      "Miles": {
        "leaderboard": [
          {
            "rank": 1,
            "name": "charlotte",
            "handle": "@charlotte",
            "score": 1200,
            "avatar": "assets/icons/temp/woman-1.jpg",
            "isCurrentUser": false,
          },
          {
            "rank": 2,
            "name": "brian",
            "handle": "@brian",
            "score": 1020,
            "avatar": "assets/icons/temp/man-2.jpg",
            "isCurrentUser": false,
          },
          {
            "rank": 3,
            "name": "robert",
            "handle": "@robert",
            "score": 1010,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 4,
            "name": "alex",
            "handle": "@alex",
            "score": 949,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 5,
            "name": "caroline",
            "handle": "@caroline",
            "score": 948,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 6,
            "name": "martin",
            "handle": "@martin",
            "score": 947,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 7,
            "name": "sara",
            "handle": "@sara",
            "score": 946,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 8,
            "name": "megan",
            "handle": "@megan",
            "score": 945,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 9,
            "name": "nathan",
            "handle": "@nathan",
            "score": 944,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 10,
            "name": "cara",
            "handle": "@cara",
            "score": 943,
            "avatar": null,
            "isCurrentUser": false,
          },
          {
            "rank": 11,
            "name": "devin",
            "handle": "@devin",
            "score": 900,
            "avatar": "assets/icons/temp/man-1.jpg",
            "isCurrentUser": true,
          },
        ],
      },
    },
  },
];

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with TickerProviderStateMixin {
  late AnimationController controller;
  int selectedCommunityIndex = 0;
  String selectedCategory = "Wellth";

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
                final leaderboard =
                    testGetCommunities[selectedCommunityIndex]['dataByCategory'][selectedCategory]['leaderboard']; //TODO: replace testGetCommunities with actual data
                final currentUser = leaderboard
                    .where((item) => item["isCurrentUser"] == true)
                    .first;
                final others = leaderboard
                    .where((item) => item["isCurrentUser"] != true)
                    .skip(3)
                    .toList();

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxContent,
                    minHeight: h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --HEADER--
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: pad / 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: isSmall ? 12 : 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildProfileAvatar(pad * 1.75),
                                SizedBox(width: isSmall ? 10 : 14),
                                Text(
                                  "Leaderboard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: isSmall ? 12 : 20),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --COMMUNITY DROPDOWN--
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    isDense: true,
                                    dropdownColor: Colors.white,
                                    value: selectedCommunityIndex,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF2A2A2A),
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF2A2A2A),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat",
                                    ),
                                    items: List.generate(
                                      testGetCommunities.length,
                                      (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(
                                          testGetCommunities[i]['title'],
                                        ), // TODO: replace testGetCommunities with actual data
                                      ),
                                    ),
                                    onChanged: (i) {
                                      setState(() {
                                        selectedCommunityIndex = i!;
                                        selectedCategory =
                                            testGetCommunities[i]['selectedCategory'];
                                      });
                                    },
                                  ),
                                ),

                                // --CATEGORY DROPDOWN--
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Filter by:",
                                      style: TextStyle(
                                        color: Color(0xFF2A2A2A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        dropdownColor: Colors.white,
                                        value: selectedCategory,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 18,
                                          color: Color(0xFF2A2A2A),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF2A2A2A),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                        ),
                                        items: List.generate(
                                          (testGetCommunities[selectedCommunityIndex]['categories']
                                                  as List)
                                              .length, // TODO: replace testGetCommunities with actual data
                                          (i) => DropdownMenuItem(
                                            value:
                                                testGetCommunities[selectedCommunityIndex]['categories'][i], // TODO: replace testGetCommunities with actual data
                                            child: Text(
                                              testGetCommunities[selectedCommunityIndex]['categories'][i],
                                            ), // TODO: replace testGetCommunities with actual data
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            selectedCategory = val!;
                                            testGetCommunities[selectedCommunityIndex]['selectedCategory'] =
                                                val; // TODO: replace testGetCommunities with actual data
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmall ? 4 : 8),

                                // --TOP 3--
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(3, (i) {
                                    final top3 = leaderboard.take(3).toList();
                                    final visualTop3 = [
                                      top3[1],
                                      top3[0],
                                      top3[2],
                                    ];
                                    final user = visualTop3[i];
                                    final isFirst = user['rank'] == 1;
                                    final gradients = {
                                      1: [Color(0xFF6CE6C7), Color(0xFF24D4AF)],
                                      2: [Color(0xFFFFE1B4), Color(0xFFFFAF2F)],
                                      3: [Color(0xFFFFC8A5), Color(0xFFFF904B)],
                                    };

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: isFirst ? 0 : 20,
                                      ),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        height: 130,
                                        width: 105,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: gradients[user['rank']]!,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              heightFactor: 0.1,
                                              child: Text(
                                                "${user['rank']}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 23,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage:
                                                          user['avatar'] != null
                                                          ? AssetImage(
                                                              user['avatar'],
                                                            )
                                                          : null,
                                                      backgroundColor:
                                                          user['avatar'] == null
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      child:
                                                          user['avatar'] == null
                                                          ? Icon(
                                                              Icons.person,
                                                              size: 28,
                                                              color: Color(
                                                                0xFF7C7C7C,
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 4),

                                                  Text(
                                                    user['name'],
                                                    style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  Text(
                                                    "${user['score']} $selectedCategory",
                                                    style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),

                                SizedBox(height: isSmall ? 4 : 8),

                                // --CURRENT USER--
                                Column(
                                  children: [
                                    if (currentUser != null)
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFD746C),
                                              Color(0xFFFF9068),
                                            ],
                                          ),
                                        ),

                                        // YOU line
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 28,
                                              child: Text(
                                                "${currentUser["rank"]}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),

                                            _buildProfileAvatar(46),
                                            SizedBox(width: 12),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "You",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "${currentUser["score"]} $selectedCategory",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),

                                // --LEADERBOARD LIST--
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: others.length,
                                    itemBuilder: (context, index) {
                                      final item = others[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 28,
                                              child: Text(
                                                "${item["rank"]}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF585858),
                                                ),
                                              ),
                                            ),

                                            CircleAvatar(
                                              radius: 23,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage:
                                                    item['avatar'] != null
                                                    ? AssetImage(item['avatar'])
                                                    : null,
                                                backgroundColor:
                                                    item['avatar'] == null
                                                    ? Color(0xFFEDEDED)
                                                    : Colors.transparent,
                                                child: item['avatar'] == null
                                                    ? Icon(
                                                        Icons.person,
                                                        size: 28,
                                                        color: Color(
                                                          0xFF7C7C7C,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ),

                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item["name"],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF2A2A2A),
                                                    ),
                                                  ),
                                                  Text(
                                                    item["handle"],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF585858),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "${item["score"]} $selectedCategory",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF585858),
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
                onPressed: () {},
                icon: Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFF6BD1F),
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
}
