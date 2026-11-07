import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'edit_resource_screen.dart';

class ResourceDetailsScreen extends StatefulWidget {
  final int resourceId;

  const ResourceDetailsScreen({
    super.key,
    required this.resourceId,
  });

  @override
  State<ResourceDetailsScreen> createState() =>
      _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState
    extends State<ResourceDetailsScreen> {
  Map<String, dynamic>? resource;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadResource();
  }

  Future<void> loadResource() async {
    try {
      final data =
          await ApiService.getResource(widget.resourceId);

      if (!mounted) return;

      setState(() {
        resource = data;
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
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Resource Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF168B45),
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.redAccent,
                        ),

                        const SizedBox(height: 15),

                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: loadResource,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : buildResourceDetails(),
    );
  }

  Widget buildResourceDetails() {
    final data = resource!;

    final String title =
        data['title']?.toString() ?? 'Untitled Resource';

    final String category =
        data['category']?.toString() ?? 'Other';

    final String quantity =
        data['quantity']?.toString() ?? '0';

    final String location =
        data['location']?.toString() ?? 'Not specified';

    final String description =
        data['description']?.toString() ??
            'No description available.';

    final String status =
        data['status']?.toString() ?? 'Available';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),

            child: Column(
              children: [
                Container(
                  width: 85,
                  height: 85,

                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7EF),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 45,
                    color: Color(0xFF168B45),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7EF),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Color(0xFF168B45),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Resource Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(16),
            ),

            child: Column(
              children: [
                detailRow(
                  Icons.inventory_2_outlined,
                  'Quantity',
                  quantity,
                ),

                const Divider(height: 25),

                detailRow(
                  Icons.location_on_outlined,
                  'Location',
                  location,
                ),

                const Divider(height: 25),

                detailRow(
                  Icons.category_outlined,
                  'Category',
                  category,
                ),

                const Divider(height: 25),

                detailRow(
                  Icons.check_circle_outline,
                  'Status',
                  status,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(16),
            ),

            child: Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditResourceScreen(
                      resourceId:
                          widget.resourceId,
                    ),
                  ),
                );

                loadResource();
              },

              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),

              label: const Text(
                'Edit Resource',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF168B45),

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget detailRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF168B45),
          size: 22,
        ),

        const SizedBox(width: 14),

        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),

        const Spacer(),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}