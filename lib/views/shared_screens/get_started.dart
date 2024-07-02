import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home_application/models/user/views/login.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_application/models/user.dart';
import 'package:smart_home_application/views/shared_screens/home_page.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print("User: $user");
    return _showSplash ? buildSplashScreen() : buildGetStartedScreen(user);
  }

  Widget buildSplashScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash_screen.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildGetStartedScreen(MyUser? user) {
    return user != null ? home_page() : Scaffold(
      body: Container(
        child: PageView(
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            buildFirstPage(context, user),
            buildSecondPage(context, user),
            buildLastPage(context, user),
          ],
        ),
      ),
    );
  }

  Widget buildFirstPage(BuildContext context, MyUser? user) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/get_started.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  if (user == null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => login_screen()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => home_page()),
                    );
                  }
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
              onTap: _goToNextPage,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: sharedcolors.lime,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSecondPage(BuildContext context, MyUser? user) {
    return GestureDetector(
      onTap: _goToNextPage,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/get_started 2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (user == null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => login_screen()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => home_page()),
                      );
                    }
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: sharedcolors.lime,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                      ],
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

  Widget buildLastPage(BuildContext context, MyUser? user) {
    return GestureDetector(
      onTap: _goToNextPage,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/get_started 3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 30, 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
          ElevatedButton(
            onPressed: () {
              if (user == null) {
                Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => login_screen()),
                );
              } else {
                Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => home_page()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: sharedcolors.lime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            ),
            child: Text(
              'Get Started!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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