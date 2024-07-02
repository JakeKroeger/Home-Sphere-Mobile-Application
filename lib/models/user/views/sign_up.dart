// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:smart_home_application/models/user/views/login.dart';
import 'package:smart_home_application/services/auth.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';
import 'package:smart_home_application/views/shared_screens/home_page.dart';
import 'package:smart_home_application/views/shared_screens/loading.dart';

class sign_up extends StatefulWidget {
  const sign_up({Key? key}) : super(key: key);

  @override
  State<sign_up> createState() => _SignUpState();
}

class _SignUpState extends State<sign_up> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _formAnimation;
  late Animation<double> _buttonAnimation;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  GlobalKey<FormState> birthDateKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  authService _auth = authService();
  DateTime? selectedDate;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _formAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _passwordValidation(String? value) {
    if (confirmPasswordController.text != passwordController.text) {
      return 'passwords Do not match';
    } else if (value == null || value.isEmpty) {
      return 'This field is required';
    } else
      return null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/sign up.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FadeTransition(
                        opacity: _formAnimation,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create new \n   Account',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: sharedcolors.lime,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Already have an account?',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 157, 168, 163),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        login_screen()),
                                              );
                                            },
                                            child: Text(
                                              'Log in',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: sharedcolors.lime,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 0),
                                FadeTransition(
                                  opacity: _formAnimation,
                                  child: CustomField(
                                    fieldModel: FieldModel(
                                      controller: nameController,
                                      icon: Icons.person,
                                      hintText: 'Name',
                                      type: TextInputType.text,
                                      validator: _validateField,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0),
                                FadeTransition(
                                  opacity: _formAnimation,
                                  child: CustomField(
                                    fieldModel: FieldModel(
                                      controller: emailController,
                                      icon: Icons.email,
                                      hintText: 'Email',
                                      type: TextInputType.emailAddress,
                                      validator: _validateField,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0),
                                FadeTransition(
                                  opacity: _formAnimation,
                                  child: CustomField(
                                    fieldModel: FieldModel(
                                      controller: passwordController,
                                      icon: Icons.lock,
                                      hintText: 'Password',
                                      type: TextInputType.visiblePassword,
                                      validator: _passwordValidation,
                                      obscureText: !showPassword,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                        icon: Icon(
                                          showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0),
                                FadeTransition(
                                  opacity: _formAnimation,
                                  child: CustomField(
                                    fieldModel: FieldModel(
                                      controller: confirmPasswordController,
                                      icon: Icons.lock,
                                      hintText: 'Confirm Password',
                                      type: TextInputType.visiblePassword,
                                      validator: _passwordValidation,
                                      obscureText: !showConfirmPassword,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showConfirmPassword =
                                                !showConfirmPassword;
                                          });
                                        },
                                        icon: Icon(
                                          showConfirmPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                FadeTransition(
                                  opacity: _buttonAnimation,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      print(passwordController);
              
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        dynamic result =
                                            await _auth.registerWithEmailPassword(
                                                emailController.text,
                                                passwordController.text,
                                                nameController.text);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  login_screen()),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: sharedcolors
                                          .lime, // Change button color here
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Change button shape here
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical:
                                              10), // Change button padding here
                                    ),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors
                                            .white, // Change button text color here
                                        fontSize:
                                            20, // Change button text size here
                                        fontWeight: FontWeight
                                            .bold, // Change button text weight here
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
