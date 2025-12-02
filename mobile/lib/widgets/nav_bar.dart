import 'package:flutter/material.dart';

enum NavPage { dashboard, leaderboard, communities, notifications, profile }

class NavBar extends StatefulWidget {
  final Color dashboardColor;
  final Color leaderboardColor;
  final Color communitiesColor;
  final Color notificationsColor;
  final Color profileColor;
  final NavPage currentPage;

  const NavBar({
    super.key,
    required this.dashboardColor,
    required this.leaderboardColor,
    required this.communitiesColor,
    required this.notificationsColor,
    required this.profileColor,
    required this.currentPage,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                if (widget.currentPage != NavPage.dashboard) {
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                }
              },
              icon: Icon(Icons.home_rounded, color: widget.dashboardColor),
              iconSize: 32,
            ),

            // LEADERBOARD
            IconButton(
              onPressed: () {
                if (widget.currentPage != NavPage.leaderboard) {
                  Navigator.of(context).pushReplacementNamed('/leaderboard');
                }
              },
              icon: Icon(
                Icons.workspace_premium_rounded,
                color: widget.leaderboardColor,
              ),
              iconSize: 32,
            ),

            // COMMUNITIES
            IconButton(
              onPressed: () {
                if (widget.currentPage != NavPage.communities) {
                  Navigator.of(context).pushReplacementNamed('/communities');
                }
              },
              icon: Icon(Icons.groups_rounded, color: widget.communitiesColor),
              iconSize: 36,
            ),

            // NOTIFICATIONS
            IconButton(
              onPressed: () {
                if (widget.currentPage != NavPage.notifications) {
                  Navigator.of(context).pushReplacementNamed('/notifications');
                }
              },
              icon: Icon(
                Icons.notifications_rounded,
                color: widget.notificationsColor,
              ),
              iconSize: 32,
            ),

            // PROFILE
            IconButton(
              onPressed: () {
                // TODO: uncomment when profile page complete
                // if (widget.currentPage != NavPage.profile) {
                //   Navigator.of(context).pushReplacementNamed('/profile');
                // }
              },
              icon: Icon(Icons.person_rounded, color: widget.profileColor),
              iconSize: 32,
            ),
          ],
        ),
      ),
    );
  }
}
