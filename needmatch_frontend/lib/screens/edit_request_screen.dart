import 'package:flutter/material.dart';

class EditRequestScreen extends StatefulWidget {
  final String title;
  final String category;
  final String quantity;
  final String location;
  final String urgency;
  final String description;

  const EditRequestScreen({
    super.key,
    required this.title,
    required this.category,
    required this.quantity,
    required this.location,
    required this.urgency,
    required this.description,
  });

  @override
  State<EditRequestScreen> createState() =>
      _EditRequestScreenState();
}

class _EditRequestScreenState
    extends State<EditRequestScreen> {

  late TextEditingController titleController;
  late TextEditingController quantityController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;

  late String selectedCategory;
  late String selectedUrgency;

  final List<String> categories = [
    'Education',
    'Food',
    'Clothing',
    'Electronics',
    'Medical',
    'Household',
    'Emergency',
    'Other',
  ];

  final List<String> urgencyLevels = [
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.title);

    quantityController =
        TextEditingController(text: widget.quantity);

    locationController =
        TextEditingController(text: widget.location);

    descriptionController =
        TextEditingController(text: widget.description);

    selectedCategory = widget.category;
    selectedUrgency = widget.urgency;

    if (!categories.contains(selectedCategory)) {
      selectedCategory = 'Other';
    }

    if (!urgencyLevels.contains(selectedUrgency)) {
      selectedUrgency = 'Medium';
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Edit Request',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Update Request',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Update the information about the support you need.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 25),

            buildLabel('What Do You Need?'),

            buildTextField(
              controller: titleController,
              hint: 'Example: School Books',
              icon: Icons.assignment_outlined,
            ),

            const SizedBox(height: 18),

            buildLabel('Category'),

            buildDropdown(
              value: selectedCategory,
              items: categories,
              icon: Icons.category_outlined,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            buildLabel('Quantity Needed'),

            buildTextField(
              controller: quantityController,
              hint: 'Example: 50 Books',
              icon: Icons.numbers_outlined,
            ),

            const SizedBox(height: 18),

            buildLabel('Location'),

            buildTextField(
              controller: locationController,
              hint: 'Where is support needed?',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 18),

            buildLabel('Urgency'),

            buildDropdown(
              value: selectedUrgency,
              items: urgencyLevels,
              icon: Icons.priority_high_outlined,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedUrgency = value;
                  });
                }
              },
            ),

            const SizedBox(height: 18),

            buildLabel('Description'),

            TextField(
              controller: descriptionController,
              maxLines: 5,

              decoration: InputDecoration(
                hintText: 'Explain why this resource is needed.',

                prefixIcon: const Padding(
                  padding: EdgeInsets.only(
                    bottom: 70,
                  ),

                  child: Icon(
                    Icons.description_outlined,
                    color: Color(0xFF168B45),
                  ),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: saveRequest,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF168B45),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF168B45),
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF168B45),
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
  }) {
    return TextField(
      controller: controller,

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

  Widget buildDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: DropdownButtonFormField<String>(
        value: value,

        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF168B45),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),

        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),

        onChanged: onChanged,
      ),
    );
  }

  void saveRequest() {
    if (titleController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields.',
          ),
        ),
      );

      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Request updated successfully!',
        ),
      ),
    );
  }
}