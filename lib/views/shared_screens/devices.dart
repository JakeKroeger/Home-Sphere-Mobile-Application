import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeDevicesPage extends StatefulWidget {
  const HomeDevicesPage({Key? key});

  @override
  State<HomeDevicesPage> createState() => _HomeDevicesPageState();
}

class _HomeDevicesPageState extends State<HomeDevicesPage> {
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
          'Home Devices',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          /* =================== Primary Devices ======================= */
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Primary Devices',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                ),
                child: Column(
                  children: [
                    /* =================== Lights ======================= */
                    ListTile(
                      leading: Icon(
                      Icons.lightbulb,
                      color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      title: Text(
                      'Lights',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      ),
                      subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        'Control the lights in the house',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          fontSize: 15,
                        ),
                        ),
                        Text(
                        'Located: All Rooms',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        ),
                      ],
                      ),
                    ),
                    Divider( color: isDarkMode ? Colors.white : Colors.black, thickness: 0.2,),
                    /* =================== Doors ======================= */
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.doorClosed,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      title: Text(
                        'Doors',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control the doors in the house',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Located: Living Room',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider( color: isDarkMode ? Colors.white : Colors.black, thickness: 0.2,),
                    /* =================== Windows ======================= */
                    ListTile(
                      leading: Icon(
                        Icons.window,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      title: Text(
                        'Windows',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control the windows in the house',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Located: Living Room',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider( color: isDarkMode ? Colors.white : Colors.black, thickness: 0.2,),
                    /* =================== Air Conditioner ======================= */
                    ListTile(
                      leading: Icon(
                        Icons.ac_unit,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      title: Text(
                        'Air Conditioner',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Control the temperature in the house',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Located: Bedroom',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),

            SizedBox(height: 20),
            /* =================== Security System ======================= */
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              'Security System',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
              ),
              ),
              SizedBox(height: 10),
              Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDarkMode ? Colors.grey[800] : Colors.white,
              ),
              child: Column(
                children: [
                /* =================== Alarm ======================= */
                ListTile(
                  leading: Icon(
                  Icons.notifications_active,
                  color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                  'Alarm System',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  ),
                  subtitle: Text(
                  'Used to alert the owner of an intruder',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                  ),
                  ),
                ),
                Divider(  color: isDarkMode ? Colors.white : Colors.black, thickness: 0.2,),
                /* =================== PIR ======================= */
                ListTile(
                  leading: Icon(
                  Icons.visibility,
                  color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                  'PIR Sensor',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  ),
                  subtitle: Text(
                  'Detects motion in a room',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                  ),
                  ),
                ),
                Divider( color: isDarkMode ? Colors.white : Colors.black, thickness: 0.2,),
                /* =================== Rain Detector ======================= */
                ListTile(
                  leading: Icon(
                  Icons.cloud,
                  color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                  'Rain Detector',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  ),
                  subtitle: Text(
                  'Detects rain and closes the windows',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                  ),
                  ),
                ),
                Divider( color: isDarkMode ? Colors.white : Colors.black, thickness: 0.2,),
                /* =================== Flame Detector ======================= */
                ListTile(
                  leading: Icon(
                  FontAwesomeIcons.fireAlt,
                  color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                  'Flame Detector',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  ),
                  subtitle: Text(
                  'Detects fire and alerts the owner',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                  ),
                  ),
                ),
                Divider( color: isDarkMode ? Colors.white : Colors.black, thickness: 0.2,),
                /* =================== Gas Detector ======================= */
                ListTile(
                  leading: Icon(
                  Icons.gas_meter_rounded,
                  color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                  'Gas Detector',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  ),
                  subtitle: Text(
                  'Detects gas and alerts the owner',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                  ),
                  ),
                ),
                ],
              ),
              ),
            ],
            ),
            /* create a section for the LDR sensor */
            SizedBox(height: 20),
            /* =================== Light Sensor ======================= */
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              'Light Sensor',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 20,
              ),
              ),
              SizedBox(height: 10),
              Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDarkMode ? Colors.grey[800] : Colors.white,
              ),
              child: Column(
                children: [
                /* =================== LDR Sensor ======================= */
                ListTile(
                  leading: Icon(
                  FontAwesomeIcons.solidLightbulb,
                  color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                  'LDR Sensor',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  ),
                  subtitle: Text(
                  'Detects light intensity in a room',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                  ),
                  ),
                ),
                ],
              ),
              ),
            ],
            ),
         ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200],
    );
  }
}