import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ImpactScreen extends StatefulWidget {
  const ImpactScreen({super.key});

  @override
  State<ImpactScreen> createState() => _ImpactScreenState();
}

class _ImpactScreenState extends State<ImpactScreen> {
  bool isLoading = true;
  int totalContributions = 0;
  int itemCount = 0;
  int matchCount = 0;
  int peopleHelped = 0;
  final List<Map<String, String>> recentContributions = [];

  @override
  void initState() {
    super.initState();
    _loadImpact();
  }

  Future<void> _loadImpact() async {
    try {
      final currentUser = await ApiService.getCurrentUser();
      final currentUserId = currentUser?['id'] as int?;
      final userName = currentUser?['name']?.toString() ?? 'Community Member';

      final resources = currentUserId == null
          ? <dynamic>[]
          : (await ApiService.getResources())
              .where((item) => item['user'] == currentUserId)
              .toList();

      final requests = currentUserId == null
          ? <dynamic>[]
          : (await ApiService.getRequests())
              .where((item) => item['user'] == currentUserId)
              .toList();

      final matches = await ApiService.getMatches();
      final userMatches = matches.where((match) {
        final donor = match['donor_name']?.toString() ?? '';
        final requester = match['requester_name']?.toString() ?? '';
        return donor == userName || requester == userName;
      }).toList();

      final recent = <Map<String, String>>[];
      for (final item in [...resources, ...requests]) {
        recent.add({
          'title': item['title']?.toString() ?? 'Contribution',
          'description': '${item['quantity'] ?? 1} item(s) shared',
          'status': 'Completed',
        });
      }

      if (recent.isEmpty) {
        recent.add({
          'title': 'No contributions yet',
          'description': 'Start by sharing a resource or creating a request.',
          'status': 'Pending',
        });
      }

      if (!mounted) return;

      setState(() {
        totalContributions = resources.length + requests.length + userMatches.length;
        itemCount = resources.length + requests.length;
        matchCount = userMatches.length;
        peopleHelped = userMatches.length > 0 ? userMatches.length : 0;
        recentContributions.clear();
        recentContributions.addAll(recent);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load your impact: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Impact',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF168B45),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF168B45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Community Impact',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Every contribution makes a difference.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          '$totalContributions',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Total contributions',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Contribution Summary',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: statistic(
                          Icons.inventory_2_outlined,
                          '$itemCount',
                          'Items',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: statistic(
                          Icons.volunteer_activism_outlined,
                          '${matchCount * 2}',
                          'Hours',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: statistic(
                          Icons.handshake_outlined,
                          '$matchCount',
                          'Matches',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: statistic(
                          Icons.people_outline,
                          '$peopleHelped',
                          'People Helped',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Recent Contributions',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...recentContributions.map(
                    (item) => contribution(
                      item['title'] ?? 'Contribution',
                      item['description'] ?? '',
                      item['status'] ?? 'Completed',
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget statistic(
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF168B45),
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget contribution(
    String title,
    String description,
    String status,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF168B45),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF168B45),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}