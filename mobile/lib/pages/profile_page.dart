import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/services/profile_service.dart';
import 'package:mobile/widgets/nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profilePicUrl;
  String? _fullName;
  String? _username;
  bool _isLoadingProfile = true;

  int checkmarkCount = 42;
  int fireCount = 99;
  int lvl = 5;

  bool _showPlaceholderPost = false; // Flag for placeholder post

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
        _fullName = data?['fullName'] as String? ?? 'Full Name';
        _username = data?['username'] as String? ?? '@username';
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
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

  Widget _buildLabelRectangle({required Color color, required Widget child}) {
    return Container(
      width: 90,
      height: 30,
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: child),
    );
  }

  Widget _buildPlaceholderPost() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: profile pic, username & date/time, menu button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileAvatar(40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _username ?? '@username',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Dec 2, 2025 · 4:00 PM',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'First Post PlaceHolder for Revitalize! :',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final pad = w * 0.08;
    final maxContent = 560.0;

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
              constraints: BoxConstraints(maxWidth: maxContent),
              child: Column(
                children: [
                  // Profile header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: pad / 2,
                      vertical: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildProfileAvatar(pad * 1.2),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _fullName ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _username ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _signOut();
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/landing_page');
                          },
                          icon: const Icon(Icons.settings, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // White container extended behind labels
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
                          horizontal: pad / 2,
                          vertical: 24,
                        ),
                        child: Column(
                          children: [
                            // Labels as transparent, longer rectangles
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildLabelRectangle(
                                  color: Colors.lightBlue[200]!,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        checkmarkCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildLabelRectangle(
                                  color: Colors.red[400]!,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        fireCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildLabelRectangle(
                                  color: Colors.orange[400]!,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'LVL',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        lvl.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Posts Section
                            Expanded(
                              child: Center(
                                child: _showPlaceholderPost
                                    ? ListView(
                                        children: [_buildPlaceholderPost()],
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showPlaceholderPost = true;
                                          });
                                        },
                                        child: Text(
                                          "There are no posts to show at the moment.",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              ),
                            ),
                          ],
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

      bottomNavigationBar: NavBar(
        dashboardColor: const Color(0xFFB2B2B2),
        leaderboardColor: const Color(0xFFB2B2B2),
        communitiesColor: const Color(0xFFB2B2B2),
        notificationsColor: const Color(0xFFB2B2B2),
        profileColor: const Color(0xFFF7696D),
        currentPage: NavPage.profile,
      ),
    );
  }
}
