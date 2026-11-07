import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedFilter = 'All';
  bool isLoading = true;
  List<dynamic> resources = [];
  List<dynamic> requests = [];

  final filters = [
    'All',
    'Resources',
    'Needs',
    'Food',
    'Education',
    'Emergency',
  ];

  @override
  void initState() {
    super.initState();
    _loadCommunityData();
  }

  Future<void> _loadCommunityData() async {
    try {
      final futureResources = ApiService.getResources();
      final futureRequests = ApiService.getRequests();

      final results = await Future.wait([futureResources, futureRequests]);

      if (!mounted) return;

      setState(() {
        resources = results[0] as List<dynamic>;
        requests = results[1] as List<dynamic>;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load community activity: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Map<String, dynamic>> get filteredItems {
    final items = <Map<String, dynamic>>[];

    for (final resource in resources) {
      items.add({
        'type': 'Resource',
        'title': resource['title']?.toString() ?? 'Community Resource',
        'category': resource['category']?.toString() ?? 'General',
        'location': resource['location']?.toString() ?? 'Community',
        'icon': Icons.inventory_2_outlined,
      });
    }

    for (final request in requests) {
      items.add({
        'type': 'Need',
        'title': request['title']?.toString() ?? 'Requested Support',
        'category': request['category']?.toString() ?? 'General',
        'location': request['location']?.toString() ?? 'Community',
        'icon': Icons.assignment_outlined,
      });
    }

    if (selectedFilter == 'All') {
      return items;
    }

    return items.where((item) {
      final category = item['category'] as String;
      final type = item['type'] as String;

      switch (selectedFilter) {
        case 'Resources':
          return type == 'Resource';
        case 'Needs':
          return type == 'Need';
        case 'Food':
          return category.toLowerCase().contains('food');
        case 'Education':
          return category.toLowerCase().contains('education') ||
              category.toLowerCase().contains('book');
        case 'Emergency':
          return category.toLowerCase().contains('medical') ||
              category.toLowerCase().contains('emergency');
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Explore',
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
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search resources or needs...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF168B45),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final selected = selectedFilter == filter;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF168B45)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Nearby Community Activity',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (items.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        'No community activity matches this filter yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ...items.map((item) => exploreCard(
                          title: item['title'] as String,
                          category: item['category'] as String,
                          location: item['location'] as String,
                          type: item['type'] as String,
                          icon: item['icon'] as IconData,
                        )),
                ],
              ),
            ),
    );
  }

  Widget exploreCard({
    required String title,
    required String category,
    required String location,
    required String type,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7EF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF168B45),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$location • $type',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF168B45),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}