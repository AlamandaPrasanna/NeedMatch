import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();

  String selectedCategory = 'Books';
  String selectedUrgency = 'Medium';

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

  final List<String> urgencyLevels = [
    'Low',
    'Medium',
    'High',
    'Emergency',
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> submitRequest() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final quantityText = quantityController.text.trim();
    final location = locationController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        quantityText.isEmpty ||
        location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final userId = await ApiService.getCurrentUserId();
    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in before creating a request.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quantity must be a valid number greater than zero.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ApiService.createRequest(
        userId: userId,
        title: title,
        category: selectedCategory,
        quantity: quantity,
        location: location,
        urgency: selectedUrgency,
        description: description,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF168B45),
                ),
                const SizedBox(width: 10),
                const Text('Request Posted'),
              ],
            ),
            content: Text(
              'Your request for "$title" has been posted successfully!\n\n'
              'NeedMatch will search for suitable resources and contributors.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Color(0xFF168B45),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to post request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
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
          'Create Request',
          style: TextStyle(
            color: Color(0xFF222222),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What do you need?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tell the community what support you need.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 25),
            buildLabel('Request Title *'),
            const SizedBox(height: 8),
            buildTextField(
              controller: titleController,
              hint: 'Example: School Books Needed',
              icon: Icons.assignment_outlined,
            ),
            const SizedBox(height: 20),
            buildLabel('Category *'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: inputDecoration(
                hint: 'Select Category',
                icon: Icons.category_outlined,
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            buildLabel('Description *'),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: inputDecoration(
                hint: 'Describe what you need and why...',
                icon: Icons.description_outlined,
              ),
            ),
            const SizedBox(height: 20),
            buildLabel('Quantity Required *'),
            const SizedBox(height: 8),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(
                hint: 'Example: 50',
                icon: Icons.numbers_outlined,
              ),
            ),
            const SizedBox(height: 20),
            buildLabel('Urgency Level'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedUrgency,
              decoration: inputDecoration(
                hint: 'Select Urgency',
                icon: Icons.priority_high_outlined,
              ),
              items: urgencyLevels.map((urgency) {
                return DropdownMenuItem(
                  value: urgency,
                  child: Text(urgency),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedUrgency = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            buildLabel('Location *'),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: inputDecoration(
                hint: 'Enter city or area',
                icon: Icons.location_on_outlined,
              ),
            ),
            const SizedBox(height: 20),
            buildLabel('Additional Requirements'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF3F7FDB),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You can provide additional details after posting the request.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F7FDB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Post Request',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: inputDecoration(
        hint: hint,
        icon: icon,
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF3F7FDB),
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF3F7FDB),
          width: 2,
        ),
      ),
    );
  }
}
