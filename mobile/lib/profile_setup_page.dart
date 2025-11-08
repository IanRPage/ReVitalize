import 'package:flutter/material.dart';
import 'package:mobile/signUp_page.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final pad = w * 0.08;
    final maxContent = 560.0;
    final isSmall = h < 650;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF75F6B), Color(0xFFF2B177)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
      child: Column(
        children: [
          // Header
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF75F6B), Color(0xFFF2B177)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFFF75F6B),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Profile Setup",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: maxContent,
                minHeight: h * 0.95
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow:  [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: pad,
                    vertical: isSmall ? pad / 2.5 : pad / 1.5,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFFEDEDED),
                            child: const CircleAvatar(
                              radius: 46,
                              backgroundColor: Color(0xFFEDEDED),
                              child: Icon(
                                Icons.person,
                                size: 70,
                                color: Color(0xFF7C7C7C),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFF5FD1E2),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _buildTextField('Full Name', nameController, isSmall),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Date of Birth',
                        ageController,
                        isSmall,
                        keyboardType: TextInputType.number,
                        suffixIcon: 'assets/icons/calendar.png',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Gender',
                        genderController,
                        isSmall,
                        readOnly: true,
                        suffixIconWidget:
                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Height',
                        heightController,
                        isSmall,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Weight',
                        weightController,
                        isSmall,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            // Continue button works
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5FD1E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      bool isSmall, {
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
        String? suffixIcon,
        Widget? suffixIconWidget,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? const Color(0xFFF5F5F5) : Colors.grey[200],
            contentPadding:
            EdgeInsets.symmetric(vertical: isSmall ? 8 : 16, horizontal: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIconWidget ??
                (suffixIcon != null
                    ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    suffixIcon,
                    width: 20,
                    height: 20,
                    color: Colors.grey[600],
                  ),
                )
                    : null),
          ),
        ),
      ],
    );
  }
}
