import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'add_resource_screen.dart';
import 'resource_details_screen.dart';
import 'edit_resource_screen.dart';

class MyResourcesScreen extends StatefulWidget {
  const MyResourcesScreen({super.key});

  @override
  State<MyResourcesScreen> createState() => _MyResourcesScreenState();
}

class _MyResourcesScreenState extends State<MyResourcesScreen> {
  List<dynamic> resources = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadResources();
  }

  Future<void> loadResources() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final allResources = await ApiService.getResources();
      final currentUserId = await ApiService.getCurrentUserId();

      if (currentUserId == null) {
        throw Exception('Please login again.');
      }

      final myResources = allResources.where((resource) {
        if (resource is! Map) return false;

        final user = resource['user'];

        if (user is int) {
          return user == currentUserId;
        }

        if (user is String) {
          return int.tryParse(user) == currentUserId;
        }

        if (user is Map) {
          final id = user['id'];
          return id == currentUserId ||
              int.tryParse(id?.toString() ?? '') == currentUserId;
        }

        return false;
      }).toList();

      if (!mounted) return;

      setState(() {
        resources = myResources;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> openAddResource() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddResourceScreen(),
      ),
    );

    if (result == true) {
      loadResources();
    }
  }

  String resourceStatus(Map resource) {
    final status = resource['status'];

    if (status == null) {
      return 'Available';
    }

    return status.toString();
  }

  Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return Colors.blue;

      case 'MATCHED':
      case 'PARTIALLY_FULFILLED':
        return Colors.orange;

      case 'CLOSED':
        return Colors.grey;

      default:
        return const Color(0xFF168B45);
    }
  }

  IconData categoryIcon(String category) {
    final value = category.toLowerCase();

    if (value.contains('book') ||
        value.contains('education')) {
      return Icons.menu_book_outlined;
    }

    if (value.contains('cloth')) {
      return Icons.checkroom_outlined;
    }

    if (value.contains('food')) {
      return Icons.fastfood_outlined;
    }

    if (value.contains('electronic')) {
      return Icons.laptop_mac_outlined;
    }

    if (value.contains('furniture')) {
      return Icons.chair_outlined;
    }

    if (value.contains('medical')) {
      return Icons.medical_services_outlined;
    }

    if (value.contains('skill')) {
      return Icons.psychology_outlined;
    }

    if (value.contains('service')) {
      return Icons.handyman_outlined;
    }

    return Icons.inventory_2_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'My Resources',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF168B45),

        onPressed: openAddResource,

        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        label: const Text(
          'Add Resource',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: loadResources,

        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF168B45),
                ),
              )
            : errorMessage != null
                ? ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      const SizedBox(height: 100),

                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.redAccent,
                      ),

                      const SizedBox(height: 15),

                      Center(
                        child: Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: loadResources,
                          child: const Text('Retry'),
                        ),
                      ),
                    ],
                  )
                : resources.isEmpty
                    ? ListView(
                        physics:
                            const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        children: [
                          const SizedBox(height: 80),

                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 70,
                            color: Color(0xFF168B45),
                          ),

                          const SizedBox(height: 20),

                          const Center(
                            child: Text(
                              'No Resources Yet',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Center(
                            child: Text(
                              'Add a resource and help someone in need.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          Center(
                            child: ElevatedButton.icon(
                              onPressed: openAddResource,
                              icon: const Icon(Icons.add),
                              label: const Text(
                                'Add Resource',
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF168B45),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        physics:
                            const AlwaysScrollableScrollPhysics(),

                        padding: const EdgeInsets.all(20),

                        children: [
                          const Text(
                            'Resources You Have',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Manage the resources you have offered to the community.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 20),

                          ...resources.map(
                            (resource) {
                              return resourceCard(
                                resource,
                              );
                            },
                          ),

                          const SizedBox(height: 90),
                        ],
                      ),
      ),
    );
  }

  Widget resourceCard(Map resource) {
    final int id = int.tryParse(
          resource['id']?.toString() ?? '',
        ) ??
        0;

    final String title =
        resource['title']?.toString() ?? 'Untitled Resource';

    final String category =
        resource['category']?.toString() ?? 'Other';

    final String quantity =
        resource['quantity']?.toString() ?? '0';

    final String location =
        resource['location']?.toString() ?? 'Not specified';

    final String description =
        resource['description']?.toString() ?? '';

    final String status = resourceStatus(resource);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,

                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7EF),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  categoryIcon(category),
                  size: 30,
                  color: const Color(0xFF168B45),
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
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: statusColor(status)
                      .withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor(status),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 17,
                color: Colors.grey,
              ),

              const SizedBox(width: 7),

              Text(
                quantity,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),

              const SizedBox(width: 20),

              const Icon(
                Icons.location_on_outlined,
                size: 17,
                color: Colors.grey,
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: id == 0
                      ? null
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResourceDetailsScreen(
                                resourceId: id,
                              ),
                            ),
                          );

                          loadResources();
                        },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF168B45),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      color: Color(0xFF168B45),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: id == 0
                      ? null
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditResourceScreen(
                                resourceId: id,
                              ),
                            ),
                          );

                          loadResources();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF168B45),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}