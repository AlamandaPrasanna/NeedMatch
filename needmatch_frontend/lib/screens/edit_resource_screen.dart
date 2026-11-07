import 'package:flutter/material.dart';

import '../services/api_service.dart';

class EditResourceScreen extends StatefulWidget {
  final int resourceId;

  const EditResourceScreen({
    super.key,
    required this.resourceId,
  });

  @override
  State<EditResourceScreen> createState() =>
      _EditResourceScreenState();
}

class _EditResourceScreenState
    extends State<EditResourceScreen> {
  final titleController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = 'Other';

  bool isLoading = true;
  bool isSaving = false;

  String? errorMessage;

  final List<String> categories = [
    'Books',
    'Clothes',
    'Food',
    'Furniture',
    'Electronics',
    'Educational Materials',
    'Medical Supplies',
    'Skills',
    'Services',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    loadResource();
  }

  Future<void> loadResource() async {
    try {
      final resource =
          await ApiService.getResource(widget.resourceId);

      titleController.text =
          resource['title']?.toString() ?? '';

      quantityController.text =
          resource['quantity']?.toString() ?? '';

      locationController.text =
          resource['location']?.toString() ?? '';

      descriptionController.text =
          resource['description']?.toString() ?? '';

      final category =
          resource['category']?.toString() ?? 'Other';

      selectedCategory =
          categories.contains(category)
              ? category
              : 'Other';

      if (!mounted) return;

      setState(() {
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

  Future<void> saveResource() async {
    if (titleController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields.',
          ),
        ),
      );

      return;
    }

    final quantity =
        int.tryParse(quantityController.text.trim());

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid quantity.',
          ),
        ),
      );

      return;
    }

    final userId =
        await ApiService.getCurrentUserId();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login again.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await ApiService.updateResource(
        id: widget.resourceId,
        userId: userId,
        title: titleController.text.trim(),
        category: selectedCategory,
        quantity: quantity,
        location: locationController.text.trim(),
        description:
            descriptionController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Resource updated successfully!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update resource: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    quantityController.dispose();
    locationController.dispose();
    descriptionController.dispose();

    super.dispose();
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
          onPressed: isSaving
              ? null
              : () {
                  Navigator.pop(context);
                },
        ),

        title: const Text(
          'Edit Resource',
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Update Resource',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Update the information about the resource you are offering.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 25),

                      buildLabel('Resource Name'),

                      buildTextField(
                        controller: titleController,
                        hint: 'Enter resource name',
                        icon: Icons.inventory_2_outlined,
                      ),

                      const SizedBox(height: 18),

                      buildLabel('Category'),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),

                        child:
                            DropdownButtonFormField<String>(
                          value: selectedCategory,

                          decoration:
                              InputDecoration(
                            prefixIcon:
                                const Icon(
                              Icons.category_outlined,
                              color:
                                  Color(0xFF168B45),
                            ),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),

                          items:
                              categories.map(
                            (category) {
                              return DropdownMenuItem(
                                value: category,
                                child:
                                    Text(category),
                              );
                            },
                          ).toList(),

                          onChanged: isSaving
                              ? null
                              : (value) {
                                  if (value !=
                                      null) {
                                    setState(() {
                                      selectedCategory =
                                          value;
                                    });
                                  }
                                },
                        ),
                      ),

                      const SizedBox(height: 18),

                      buildLabel('Quantity'),

                      buildTextField(
                        controller:
                            quantityController,
                        hint: 'Example: 20',
                        icon:
                            Icons.numbers_outlined,
                        keyboardType:
                            TextInputType.number,
                      ),

                      const SizedBox(height: 18),

                      buildLabel('Location'),

                      buildTextField(
                        controller:
                            locationController,
                        hint:
                            'Enter pickup location',
                        icon: Icons
                            .location_on_outlined,
                      ),

                      const SizedBox(height: 18),

                      buildLabel('Description'),

                      TextField(
                        controller:
                            descriptionController,

                        maxLines: 5,

                        decoration:
                            InputDecoration(
                          hintText:
                              'Describe your resource',

                          prefixIcon:
                              const Padding(
                            padding:
                                EdgeInsets.only(
                              bottom: 70,
                            ),
                            child: Icon(
                              Icons
                                  .description_outlined,
                              color: Color(
                                  0xFF168B45),
                            ),
                          ),

                          filled: true,
                          fillColor: Colors.white,

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : saveResource,

                          style: ElevatedButton
                              .styleFrom(
                            backgroundColor:
                                const Color(
                                    0xFF168B45),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                            ),
                          ),

                          child: isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color:
                                        Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: OutlinedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  Navigator.pop(
                                      context);
                                },

                          style: OutlinedButton
                              .styleFrom(
                            side:
                                const BorderSide(
                              color:
                                  Color(0xFF168B45),
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      12),
                            ),
                          ),

                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color:
                                  Color(0xFF168B45),
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(
          icon,
          color: const Color(0xFF168B45),
        ),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}