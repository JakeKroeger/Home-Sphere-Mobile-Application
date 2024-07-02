// ignore_for_file: unused_import, unused_local_variable, duplicate_ignore

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:smart_home_application/models/user/views/login.dart';
import 'package:smart_home_application/services/auth.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_application/models/user.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(17),
          color: Colors.white,
        ),
        
        child: IconButton(
          icon: Icon(Icons.keyboard_arrow_left_rounded),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/profile.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: UserDetails(
            pickedImage: pickedImage,
            onImagePick: (File image) {
              setState(() {
                pickedImage = image;
              });
            },
          ),
        ),
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  final File? pickedImage;
  final Function(File) onImagePick;

  const UserDetails({Key? key, this.pickedImage, required this.onImagePick})
      : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool gender = false;
  bool editable = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final authService _auth = authService();

  @override
  void initState() {
    super.initState();
    // Initialize the user data here
    phoneController.text = '1234567890';
    gender = true;
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    // ignore: unnecessary_null_comparison
    if (context != null) {
      final user = Provider.of<MyUser?>(context);
      setState(() {
        emailController.text =
            user?.email ?? ''; // Use default value if email is null
        usernameController.text =
            user?.username ?? ''; // Use default value if username is null
      });
    } else {
      // Handle the case when context is null
    }
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 255,
          ),
          GestureDetector(
            onTap: () async {
              final ImagePicker _picker = ImagePicker();
              final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                widget.onImagePick(File(image.path));
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:  Colors.black,
                      width: 4,
                    ),
                  ),
                  child: widget.pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.file(
                            widget.pickedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 100,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            trailing: IconButton(
              alignment: Alignment.center,
              icon: Icon(editable ? Icons.done : Icons.edit),
              iconSize: 20,
              onPressed: () {
                setState(() {
                  editable = !editable;
                });
              },
            ),
          ),
          CustomField(
            fieldModel: FieldModel(
              controller: usernameController,
              icon: Icons.person,
              hintText: 'Username',
              type: TextInputType.name,
              enabled: editable,
            ),
          ),
          CustomField(
            fieldModel: FieldModel(
              controller: phoneController,
              icon: Icons.phone,
              hintText: 'Phone number',
              type: TextInputType.phone,
              enabled: editable,
            ),
          ),
          CustomField(
            fieldModel: FieldModel(
              controller: emailController,
              icon: Icons.email,
              hintText: 'Email',
              type: TextInputType.emailAddress,
              enabled: false,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Change User',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 157, 168, 163),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // ignore: unused_local_variable
                    dynamic result = await _auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'login', (route) => false);
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 20,
                      color: sharedcolors.lime,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  final FieldModel fieldModel;

  const CustomField({Key? key, required this.fieldModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: fieldModel.controller,
        keyboardType: fieldModel.type,
        enabled: fieldModel.enabled,
        decoration: InputDecoration(
          prefixIcon: Icon(fieldModel.icon),
          hintText: fieldModel.hintText,
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 157, 168, 163),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 157, 168, 163),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: sharedcolors.lime,
            ),
          ),
        ),
      ),
    );
  }
}

class FieldModel {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final TextInputType type;
  final bool enabled;

  FieldModel({
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.type,
    required this.enabled,
  });
}