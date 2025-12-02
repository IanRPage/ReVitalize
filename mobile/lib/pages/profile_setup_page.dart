import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/services/cloud_storage_service.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController usernameController = TextEditingController();
  File? profilePic; // TODO figure out how to get profile picture url
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other'
  ];

  Future<void> pickImage(ImageSource src) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      setState(() {
        profilePic = File(pickedFile.path);
      });
    }
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text(
              "Select Gender",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...genderOptions.map((gender) {
              return ListTile(
                title: Text(gender),
                onTap: () {
                  setState(() {
                    genderController.text = gender;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }



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
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 100,
              width: double.infinity,
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
                    minHeight: h * 0.95,
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
                      boxShadow: [
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

                        // PROFILE PICTURE
                        InkWell(
                          onTap: () => pickImage(ImageSource.gallery),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: const Color(0xFFEDEDED),
                                backgroundImage: profilePic != null
                                    ? FileImage(profilePic!) as ImageProvider
                                    : null,
                                child: profilePic == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 70,
                                        color: Color(0xFF7C7C7C),
                                      )
                                    : null,
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
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
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
                        ),

                        const SizedBox(height: 24),

                        // USERNAME
                        _buildTextField(
                          'Username',
                          usernameController,
                          isSmall,
                        ),

                        const SizedBox(height: 16),

                        // NAME
                        _buildTextField('Full Name', nameController, isSmall),

                        const SizedBox(height: 16),

                        // DATE OF BIRTH
                        _buildTextField(
                          'Date of Birth',
                          dobController,
                          isSmall,
                          keyboardType: TextInputType.number,
                          suffixIconWidget: IconButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now()
                              );
                              if(picked != null){
                                setState(() {
                                  dobController.text = "${picked.month}/${picked.day}/${picked.year}";
                                });
                              }
                            }, // TODO: add calendar drop down
                            icon: const ImageIcon(
                              AssetImage('assets/icons/calendar.png'),
                            ),
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // GENDER
                        _buildTextField(
                          'Gender',
                          genderController,
                          isSmall,
                          // readOnly: true,
                          suffixIconWidget: IconButton(
                            onPressed: _showGenderPicker, // TODO: add gender dropdown
                            icon: const Icon(Icons.keyboard_arrow_down),
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // HEIGHT
                        _buildTextField(
                          'Height',
                          heightController,
                          isSmall,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 16),

                        // WEIGHT
                        _buildTextField(
                          'Weight',
                          weightController,
                          isSmall,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 24),

                        // CONTINUE
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              final profileService = ProfileService();

                              // get profile picture
                              try {
                                String? profilePicUrl;
                                if (profilePic != null) {
                                  profilePicUrl = await CloudStorageService
                                      .instance
                                      .uploadProfilePicture(
                                        uid: uid,
                                        file: profilePic!,
                                      );
                                }

                                // setup data for database
                                Map<String, dynamic> data = {
                                  'username': usernameController.text,
                                  'profilePic': profilePicUrl,
                                  'fullName': nameController.text,
                                  'dob': dobController.text,
                                  'gender': genderController.text,
                                  'height': heightController.text,
                                  'weight': weightController.text,
                                };
                                await profileService.createProfile(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  data: data,
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Dashboard(),
                                  ),
                                );
                              } catch (e, st) {
                                debugPrint('Error creating profile: $e');
                                debugPrint('$st');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Failed to configure profile information',
                                    ),
                                  ),
                                );
                              }
                            }, // TODO database create
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
      ),
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? const Color(0xFFF5F5F5) : Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(
              vertical: isSmall ? 8 : 16,
              horizontal: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon:
                suffixIconWidget ??
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
