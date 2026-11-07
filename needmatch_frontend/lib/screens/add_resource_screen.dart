import 'package:flutter/material.dart';
import '../services/api_service.dart';
class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({super.key});
  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}
class _AddResourceScreenState extends State<AddResourceScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  String selectedCategory = 'Books';
  String selectedCondition = 'Good';
  bool isLoading = false;
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
  final List<String> conditions = [
    'New',
    'Excellent',
    'Good',
    'Used',
  ];
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    locationController.dispose();
    super.dispose();
  }
  Future<void> submitResource() async {
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
        ),
      );
      return;
    }
    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid quantity.'),
        ),
      );
      return;
    }
    final userId = await ApiService.getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login again to add a resource.'),
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await ApiService.createResource(
        userId: userId,
        title: title,
        category: selectedCategory,
        quantity: quantity,
        location: location,
        description: description,
      );
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF168B45),
                ),
                SizedBox(width: 10),
                Text('Resource Added'),
              ],
            ),
            content: Text(
              '$title has been added successfully!\n\n'
              'NeedMatch will now look for suitable requests.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context, true);
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

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to add resource: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
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
          'Add Resource',
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
          onPressed: isLoading
              ? null
              : () {
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
              'What would you like to share?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Add a resource and help someone in need.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Resource Image',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Image upload will be connected later.',
                    ),
                  ),
                );
              },

              child: Container(
                width: double.infinity,
                height: 160,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 55,
                      height: 55,

                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF7EF),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Color(0xFF168B45),
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Add Resource Image',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Tap to upload an image',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            buildLabel('Resource Title *'),

            const SizedBox(height: 8),

            buildTextField(
              controller: titleController,
              hint: 'Example: School Books',
              icon: Icons.inventory_2_outlined,
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

              onChanged: isLoading
                  ? null
                  : (value) {
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
                hint: 'Describe the resource you want to share...',
                icon: Icons.description_outlined,
              ),
            ),

            const SizedBox(height: 20),

            buildLabel('Quantity *'),

            const SizedBox(height: 8),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(
                hint: 'Example: 10',
                icon: Icons.numbers_outlined,
              ),
            ),

            const SizedBox(height: 20),

            buildLabel('Condition'),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedCondition,

              decoration: inputDecoration(
                hint: 'Select Condition',
                icon: Icons.star_outline,
              ),

              items: conditions.map((condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: Text(condition),
                );
              }).toList(),

              onChanged: isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          selectedCondition = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 8),

            const Text(
              'Condition is currently displayed in the UI only.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            buildLabel('Location *'),

            const SizedBox(height: 8),

            TextField(
              controller: locationController,
              decoration: inputDecoration(
                hint: 'Enter your city or area',
                icon: Icons.location_on_outlined,
              ),
            ),

            const SizedBox(height: 20),

            buildLabel('Availability'),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF168B45),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Available for matching immediately',
                      style: TextStyle(
                        fontSize: 14,
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
                onPressed: isLoading ? null : submitResource,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF168B45),
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Add Resource',
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
        color: const Color(0xFF168B45),
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
          color: Color(0xFF168B45),
          width: 2,
        ),
      ),
    );
  }
}