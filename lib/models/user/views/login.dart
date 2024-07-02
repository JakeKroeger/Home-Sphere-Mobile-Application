import 'package:flutter/material.dart';
import 'package:smart_home_application/models/user/views/sign_up.dart';
import 'package:smart_home_application/services/auth.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';
import 'package:smart_home_application/views/shared_screens/home_page.dart';
import 'package:smart_home_application/views/shared_screens/loading.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _loginState();
}

class _loginState extends State<login_screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _formAnimation;
  late Animation<double> _buttonAnimation;

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  GlobalKey<FormState> emailkey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordkey = GlobalKey<FormState>();
  GlobalKey<FormState> Formkey = GlobalKey<FormState>();

  String error = '';
  bool showPassword = false;
  bool loading = false;
  final authService _auth = authService();

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
        curve: Interval(0, 0.5),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1),
      ),
    );

    _animationController.forward();
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
                    image: AssetImage('assets/login.png'),
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
                            key: Formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: sharedcolors.lime,
                                        ),
                                      ),
                                      Text(
                                        'Sign in to continue.',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 157, 168, 163),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
              
                                //--------------------------EMAIL--------------------------------
                                FadeTransition(
                                  opacity: _formAnimation,
                                  child: CustomField(
                                    fieldModel: FieldModel(
                                      controller: emailcontroller,
                                      icon: Icons.email,
                                      hintText: 'Username / Email',
                                      type: TextInputType.emailAddress,
                                      validator: _validateField,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
              
                                //--------------------------PASSWORD-----------------------------
                                FadeTransition(
                                  opacity: _formAnimation,
                                  child: CustomField(
                                    fieldModel: FieldModel(
                                      controller: passwordcontroller,
                                      icon: Icons.lock,
                                      hintText: 'Password',
                                      type: TextInputType.visiblePassword,
                                      validator: _validateField,
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
                                SizedBox(height: 40),
              
                                FadeTransition(
                                  opacity: _buttonAnimation,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (Formkey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        dynamic result =
                                            await _auth.loginWithEmailPassword(
                                                emailcontroller.text,
                                                passwordcontroller.text);
                                        if (result == null) {
                                          setState(() {
                                            error =
                                                'Could not sign in with those Credentials';
                                            loading = false;
                                          });
                                          print(error);
                                        } else {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      home_page()));
                                        }
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
                                          horizontal: 5,
                                          vertical:
                                              10), // Change button padding here
                                    ),
                                    child: Text(
                                      'Login',
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
                                SizedBox(height: 10),
                                FadeTransition(
                                  opacity: _buttonAnimation,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Don\'t have an account?',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 157, 168, 163),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => sign_up()),
                                          );
                                        },
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: sharedcolors.lime,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Error message Display
                                SizedBox(height: 10),
                                Text(
                                  error,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),

                                //Forgot Password
                                /* FadeTransition(
                                  opacity: _buttonAnimation,
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => forgot_password()),
                                      // );
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: sharedcolors.lime,
                                      ),
                                    ),
                                  ),
                                ), */
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

class CustomField extends StatelessWidget {
  final FieldModel fieldModel;

  const CustomField({Key? key, required this.fieldModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: fieldModel.controller,
        decoration: InputDecoration(
          labelText: fieldModel.hintText,
          prefixIcon: Icon(fieldModel.icon),
          suffixIcon: fieldModel.suffixIcon,
        ),
        keyboardType: fieldModel.type,
        enabled: fieldModel.enabled,
        validator: fieldModel.validator,
        obscureText: fieldModel.obscureText,
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
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Widget? suffixIcon;

  const FieldModel({
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.type,
    this.enabled = true,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  });
}

String? _validateField(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}
