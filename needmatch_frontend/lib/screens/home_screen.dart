import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_resource_screen.dart';
import 'create_request_screen.dart';
import 'matches_screen.dart';
import 'volunteer_screen.dart';
import 'explore_screen.dart';
import 'impact_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'request_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  String _userName = 'Welcome';

  List<dynamic> _requests = [];

  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      final user = await ApiService.getCurrentUser();

      final requests = await ApiService.getRequests();

      if (!mounted) return;

      setState(() {
        _userName = user?['name']?.toString() ?? 'Welcome';
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to load community data.',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> refreshHome() async {
    setState(() {
      _isLoading = true;
    });
    await loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/heart.jpeg',
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 10),

            const Text(
              'NeedMatch',
              style: TextStyle(
                color: Color(0xFF168B45),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NotificationsScreen(),
                ),
              );
            },

            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfileScreen(),
                ),
              );
            },

            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),

      // BODY
      body: RefreshIndicator(
        color: const Color(0xFF168B45),

        onRefresh: refreshHome,

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // WELCOME
              Text(
                'Welcome, $_userName 👋',

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Connect resources with real community needs.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              // MAIN ACTION TITLE
              const Text(
                'What would you like to do?',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // I HAVE + I NEED
              Row(
                children: [
                  Expanded(
                    child: actionCard(
                      context,

                      title: 'I Have',
                      subtitle: 'Share resources',

                      icon:
                          Icons.inventory_2_outlined,

                      color:
                          const Color(0xFF168B45),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                                const AddResourceScreen(),
                          ),
                        ).then((_) {
                          refreshHome();
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: actionCard(
                      context,

                      title: 'I Need',
                      subtitle: 'Request support',

                      icon: Icons.search,

                      color:
                          const Color(0xFF3F7FDB),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                                const CreateRequestScreen(),
                          ),
                        ).then((_) {
                          refreshHome();
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // VOLUNTEER + MATCHES
              Row(
                children: [
                  Expanded(
                    child: actionCard(
                      context,

                      title: 'Volunteer',
                      subtitle: 'Offer your time',

                      icon: Icons
                          .volunteer_activism_outlined,

                      color:
                          const Color(0xFFE89A20),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                                const VolunteerScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: actionCard(
                      context,

                      title: 'Matches',
                      subtitle: 'View smart matches',

                      icon: Icons.favorite_outline,

                      color:
                          const Color(0xFF8A55C7),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                                const MatchesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // COMMUNITY NEEDS
              const Text(
                'Community Needs',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),

                    child: CircularProgressIndicator(
                      color: Color(0xFF168B45),
                    ),
                  ),
                )
              else if (_requests.isEmpty)
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(15),

                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.04),

                        blurRadius: 8,

                        offset:
                            const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: const Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 42,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 10),

                      Text(
                        'No community requests yet.',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'Create a request to help someone in need.',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._requests
                    .take(5)
                    .map(
                      (request) =>
                          Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child:
                            buildRequestCard(
                          request,
                        ),
                      ),
                    ),

              const SizedBox(height: 30),

              // YOUR IMPACT
              const Text(
                'Your Impact',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              InkWell(
                borderRadius:
                    BorderRadius.circular(16),

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const ImpactScreen(),
                    ),
                  );
                },

                child: Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFEAF7EF),

                    borderRadius:
                        BorderRadius.circular(16),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,

                    children: [
                      impactItem(
                        icon: Icons
                            .inventory_2_outlined,
                        value: '0',
                        label: 'Items',
                      ),

                      impactItem(
                        icon: Icons
                            .volunteer_activism_outlined,
                        value: '0',
                        label: 'Hours',
                      ),

                      impactItem(
                        icon:
                            Icons.favorite_outline,
                        value: '0',
                        label: 'Helped',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 0,

        selectedItemColor:
            const Color(0xFF168B45),

        unselectedItemColor:
            Colors.grey,

        type:
            BottomNavigationBarType.fixed,

        onTap: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ExploreScreen(),
                ),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MatchesScreen(),
                ),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ImpactScreen(),
                ),
              );
              break;

            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProfileScreen(),
                ),
              );
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon:
                Icon(Icons.home_outlined),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.favorite_outline),
            label: 'Matches',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.bar_chart_outlined),
            label: 'Impact',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // REQUEST CARD
  Widget buildRequestCard(
    Map<String, dynamic> request,
  ) {
    final title =
        request['title']?.toString() ??
            'Community Request';

    final description =
        request['description']?.toString() ??
            'Support is required.';

    final location =
        request['location']?.toString() ??
            'Location not specified';

    final urgency =
        request['urgency']?.toString() ??
            'OPEN';

    final id = request['id'];

    return InkWell(
      borderRadius:
          BorderRadius.circular(15),

      onTap: id == null
          ? null
          : () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) =>
    RequestDetailsScreen(
  requestId:
      int.tryParse(
            id.toString(),
          ) ??
          0,
),
                ),
              );
            },

      child: Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(15),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.04),

              blurRadius: 8,

              offset:
                  const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color:
                    const Color(0xFFEAF7EF),

                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: const Icon(
                Icons.volunteer_activism_outlined,
                color:
                    Color(0xFF168B45),
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style:
                        const TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,

                    maxLines: 2,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 3),

                      Expanded(
                        child: Text(
                          location,

                          maxLines: 1,

                          overflow:
                              TextOverflow.ellipsis,

                          style:
                              const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        formatUrgency(urgency),

                        style:
                            const TextStyle(
                          fontSize: 11,
                          color:
                              Color(0xFF168B45),
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  String formatUrgency(String value) {
    final formatted =
        value.toLowerCase();

    if (formatted == 'high') {
      return 'High Priority';
    }

    if (formatted == 'medium') {
      return 'Medium Priority';
    }

    if (formatted == 'low') {
      return 'Low Priority';
    }

    if (formatted == 'open') {
      return 'Open';
    }

    return value;
  }

  // ACTION CARD
  Widget actionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(16),

      child: Container(
        height: 150,

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.05),

              blurRadius: 10,

              offset:
                  const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color:
                    color.withOpacity(0.12),

                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),

            const Spacer(),

            Text(
              title,

              style:
                  const TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,

              style:
                  const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // IMPACT ITEM
  Widget impactItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,

          color:
              const Color(0xFF168B45),

          size: 28,
        ),

        const SizedBox(height: 6),

        Text(
          value,

          style:
              const TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        Text(
          label,

          style:
              const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}