import 'package:flutter/material.dart';
import 'package:smart_home_application/views/shared_screens/bedroom.dart';
import 'package:smart_home_application/views/shared_screens/garden.dart';
import 'package:smart_home_application/views/shared_screens/kitchen.dart';
import 'package:smart_home_application/views/shared_screens/living.dart';
import 'package:firebase_database/firebase_database.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool isDarkMode = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Settings");

  @override
  void initState() {
    super.initState();

    // Set up event listener to update state based on Firebase changes
    ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          Map? snapshotValue = event.snapshot.value as Map?;
          isDarkMode = snapshotValue?['Theme'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode?  Colors.black:  Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              color: isDarkMode? Colors.white : Colors.black,
            ),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left_rounded),
              color: isDarkMode? Colors.black : Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text(
          'Rooms',
          style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white, // Change the background color here
        child: ListView(
          children: [
            //---------------------------------Title---------------------------------
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                'Select a room to control',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //---------------------------------LIVING ROOM---------------------------------
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to living room page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => livingRoom()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/living room.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: isDarkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Living Room',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //---------------------------------KITCHEN---------------------------------
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to kitchen page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => kitchenPage()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/kitchen.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: isDarkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Kitchen',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //---------------------------------BEDROOM---------------------------------
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to bedroom page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => bedroomPage()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bedroom.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: isDarkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Bedroom',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //---------------------------------GARDEN---------------------------------
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to garden page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GardenPage()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/garden.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: isDarkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Garden',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
