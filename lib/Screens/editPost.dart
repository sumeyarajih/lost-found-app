import 'package:flutter/material.dart';
import '../constants/color.dart';

class EditPostScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _category;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _category = widget.post['category'];
    _titleController = TextEditingController(text: widget.post['title']);
    _descController = TextEditingController(text: widget.post['description']);
    _locationController = TextEditingController(text: widget.post['location']);
    _contactController = TextEditingController(text: widget.post['contact'] ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildCategoryChip('Lost'),
                  const SizedBox(width: 10),
                  _buildCategoryChip('Found'),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField('Title', 'e.g., Lost Black Wallet', _titleController),
              const SizedBox(height: 15),
              _buildTextField('Description', 'Provide details about the item', _descController, maxLines: 3),
              const SizedBox(height: 15),
              _buildTextField('Location', 'Where was it lost/found?', _locationController),
              const SizedBox(height: 15),
              _buildTextField('Contact Information', 'Phone number or Email', _contactController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Implementation for updating post
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post updated successfully!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Update Post', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = _category == label;
    return GestureDetector(
      onTap: () => setState(() => _category = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
        ),
      ],
    );
  }
}
