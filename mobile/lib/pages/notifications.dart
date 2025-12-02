import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/pages/communities.dart';
import 'package:mobile/services/profile_service.dart';
import 'package:mobile/pages/leaderboard.dart';

final List<Map<String, String>> testNotifications = [
  {
    'title': 'New Challenge Available!',
    'description': 'Check out the latest 30-day fitness challenge.',
    'time': '2h ago',
  },
  {
    'title': 'Your friend joined a community',
    'description': 'Kyle joined the 100 Day Challenge community.',
    'time': '5h ago',
  },
  {
    'title': 'Milestone Achieved',
    'description': 'You obtained 1000 Wellth points.',
    'time': '1d ago',
  },
  {
    'title': 'Reminder',
    'description': 'Don’t forget to log your daily activity!',
    'time': '1d ago',
  },
];

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String? _profilePicUrl;
  bool _isLoadingProfile = true;
  bool _showEmptyState = true; // flag to toggle empty vs notifications

  @override
  void initState() {
    super.initState();
    _loadProfile();
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
        backgroundColor: Colors.white.withAlpha(51),
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

    if (_profilePicUrl == null || _profilePicUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white.withAlpha(51),
        child: const Icon(Icons.person, color: Colors.white, size: 28),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white.withAlpha(51),
      backgroundImage: NetworkImage(_profilePicUrl!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final pad = w * 0.08;
    final maxContent = 560.0;
    final isSmall = h < 730;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient header
          Container(
            height: 180,
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
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContent, minHeight: h),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: pad / 2),
                    child: Row(
                      children: [
                        _buildProfileAvatar(pad * 1.25),
                        SizedBox(width: isSmall ? 10 : 14),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: _showEmptyState
                              ? GestureDetector(
                                  key: const ValueKey('emptyState'),
                                  onTap: () {
                                    setState(() {
                                      _showEmptyState = false;
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/notificationFiller.png',
                                        width: 180,
                                        height: 180,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'No Notifications Yet!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'You currently have no notifications. We will notify you when something new happens!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  key: const ValueKey('notificationsList'),
                                  itemCount: testNotifications.length,
                                  itemBuilder: (context, index) {
                                    final notification =
                                        testNotifications[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.blue[200],
                                            child: const Icon(
                                              Icons.notifications,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notification['title']!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  notification['description']!,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            notification['time']!,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // DASHBOARD
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
                },
                icon: const Icon(Icons.home_rounded, color: Color(0xFFB2B2B2)),
                iconSize: 32,
              ),

              // LEADERBOARD
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Leaderboard(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFB2B2B2),
                ),
                iconSize: 32,
              ),

              // COMMUNITIES
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Communities(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.groups_rounded,
                  color: Color(0xFFB2B2B2),
                ),
                iconSize: 36,
              ),

              // NOTIFICATIONS
              IconButton(
                onPressed: () {}, // Current page
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Color(0xFF26D7AD),
                ),
                iconSize: 32,
              ),

              // PROFILE
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFFB2B2B2),
                ),
                iconSize: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
