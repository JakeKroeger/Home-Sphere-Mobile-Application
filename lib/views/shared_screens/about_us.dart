import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool isDarkMode = false;

  DatabaseReference setting = FirebaseDatabase.instance.ref("Settings");

    @override
  void initState() {
    super.initState();
    
    setting.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          Map? snapshotValue = event.snapshot.value as Map?;
          isDarkMode = snapshotValue?['Theme'];
        });
      }
    });
  }

  void Theme() async {
    await setting.update({
      "Theme": isDarkMode,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left_rounded),
              color: isDarkMode ? Colors.black : Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text(
          'About Us',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          /* =================== About Us ======================= */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'About Us',
                style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(38),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      'Home Sphere Application is a smart home application that allows you to control your home appliances from anywhere in the world.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),  
                    ),
                    Divider(color: isDarkMode ? Colors.white : Colors.black,),
                    Text(
                      'It is a user-friendly application that is easy to use and understand. ',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Divider(color: isDarkMode ? Colors.white : Colors.black,),
                    Text(
                      'Our mission is to make your home smarter and more efficient by providing you with the tools you need to control your home appliances from anywhere in the world.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ],
            ),
        ],
      ),
    );
  }
}