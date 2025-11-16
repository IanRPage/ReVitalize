import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))
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

  Stack _dayProgress(String day) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5FD1E2)),
              value: 0,
              backgroundColor: Color(0xFFEDEDED),
            ),
          ),
        ),
        Center(
          child: Text(
            day,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // gradient
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
            child: LayoutBuilder(builder: (context, c) {
              final w = c.maxWidth;
              final h = c.maxHeight;
              final pad = w * 0.08;
              final maxContent = 560.0;
              final isSmall = h < 780;

              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContent, minHeight: h),
                  child: Column(
                    children: [
                      // header
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: pad / 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: isSmall ? 12 : 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.circle, color: Colors.white, size: pad * 1.75),
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
                                    SizedBox(height: isSmall ? pad / 2 : pad / 1.75),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: pad, vertical: isSmall ? pad / 2.5 : pad / 1.5),
                          child: Column(
                            children: [
                              SizedBox(height: isSmall ? 8 : 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _dayProgress("S"),
                                  const SizedBox(width: 14),
                                  _dayProgress("M"),
                                  const SizedBox(width: 14),
                                  _dayProgress("T"),
                                  const SizedBox(width: 14),
                                  _dayProgress("W"),
                                  const SizedBox(width: 14),
                                  _dayProgress("T"),
                                  const SizedBox(width: 14),
                                  _dayProgress("F"),
                                  const SizedBox(width: 14),
                                  _dayProgress("S"),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // current streak
                              Container(
                                width: double.infinity,
                                height: pad * 2.5,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFF2AF77), Color(0xFFF76A6D)],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topCenter,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8), bottom: Radius.circular(8)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: pad / 2, vertical: pad / 3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        '0 days',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                                              value: 0,
                                              backgroundColor: Colors.white.withValues(alpha: 0.35),
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(8),
                                                bottom: Radius.circular(8),
                                              ),
                                              minHeight: 6,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '0%', // TODO: Connect to the streak percentage
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                height: pad * 2.5,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: pad / 3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Challenges',
                                            style: TextStyle(
                                              color: Color(0xFF2A2A2A),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'View all',
                                            style: TextStyle(
                                              color: Color(0xFF18B08E),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: double.infinity,
                                height: pad * 2.5,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: pad / 3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Habits',
                                            style: TextStyle(
                                              color: Color(0xFF2A2A2A),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'View all',
                                            style: TextStyle(
                                              color: Color(0xFF18B08E),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          Positioned(
            bottom: 30,
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
                              color: Colors.white, // ignored due to ShaderMask
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
                onPressed: () {},
                icon: Icon(Icons.workspace_premium_rounded, color: Color(0xFFB2B2B2)),
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.groups_rounded, color: Color(0xFFB2B2B2)),
                iconSize: 36,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_rounded, color: Color(0xFFB2B2B2)),
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {},
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
