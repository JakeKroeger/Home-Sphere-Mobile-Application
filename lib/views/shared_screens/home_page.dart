// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_home_application/services/auth.dart';
import 'package:smart_home_application/views/shared_screens/devices.dart';
import 'package:smart_home_application/views/shared_screens/rooms.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async'; 
import 'package:url_launcher/url_launcher.dart';



// Import views
import 'package:smart_home_application/models/user/views/profile.dart';
import 'package:smart_home_application/models/user/views/login.dart';
import 'package:smart_home_application/models/user/views/setting.dart';

import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';
import 'package:smart_home_application/views/shared_screens/bedroom.dart';
import 'package:smart_home_application/views/shared_screens/garden.dart';
import 'package:smart_home_application/views/shared_screens/kitchen.dart';
import 'package:smart_home_application/views/shared_screens/living.dart';
import 'package:smart_home_application/views/shared_screens/about_us.dart';

// Import models
import 'package:smart_home_application/models/user.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  late stt.SpeechToText _speech;

  // Database references
  DatabaseReference kitchenDatabase = FirebaseDatabase.instance.ref("Kitchen");
  DatabaseReference livingDatabase = FirebaseDatabase.instance.ref("LivingRoom");
  DatabaseReference gardenDatabase = FirebaseDatabase.instance.ref("Garden");
  DatabaseReference bedroomDatabase = FirebaseDatabase.instance.ref("Bedroom");
  DatabaseReference settings = FirebaseDatabase.instance.ref("Settings");

  bool isListening = false;

  int temp = 0;
  int humidity = 0;

  bool isDarkMode = false;

  bool isLILightOn = false;
  bool isKILightOn = false;
  bool isBDLightOn = false;
  bool isGALightOn = false;

  bool isDoorLocked = false;

  bool isWindowOn = false;

  bool isFanON = false;

/* Flame/gas notification */
  bool flameAlert = false;
  bool gasAlert = false;

  bool pirAlert = false;
  bool rainAlert = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    initializeNotifications();

    // Set up event listener to update state based on Firebase changes
    bedroomDatabase.onValue.listen((event) {
      if (event.snapshot.value != null) {
      setState(() {
        Map? snapshotValue = event.snapshot.value as Map?;
        isBDLightOn = snapshotValue?['BedroomLights'];
        temp = snapshotValue?['Temperature'];
        humidity = snapshotValue?['Humidity'];
      });
      }
    });

    kitchenDatabase.onValue.listen((event) {
      if (event.snapshot.value != null) {
      setState(() {
        Map? snapshotValue = event.snapshot.value as Map?;
        isKILightOn = snapshotValue?['KitchenLights'];
        bool newGasAlert = snapshotValue?['GasStatus'];
        bool newFlameAlert = snapshotValue?['FlameStatus'];
        if (newGasAlert != gasAlert) {
        gasAlert = newGasAlert;
        gasNotification(gasAlert);
        }
        if (newFlameAlert != flameAlert) {
        flameAlert = newFlameAlert;
        flameNotification(flameAlert);
        }
      });
      }
    });

    settings.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          Map? snapshotValue = event.snapshot.value as Map?;
          isDarkMode = snapshotValue?['Theme'];
        });
      }
    });

    livingDatabase.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          Map? snapshotValue = event.snapshot.value as Map?;
          isLILightOn = snapshotValue?['LivingLights'];
          isDoorLocked = snapshotValue?['DoorLock'];
          isWindowOn = snapshotValue?['Window'];
        });
      }
    });
  
    gardenDatabase.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          Map? snapshotValue = event.snapshot.value as Map?;
          isGALightOn = snapshotValue?['GardenLights'];
          bool newPirAlert = snapshotValue?['pirNoti'];
          bool newRainAlert = snapshotValue?['rainNoti'];
          if (newPirAlert != pirAlert) {
          pirAlert = newPirAlert;
          pirNotification(pirAlert);
          }
          if (newRainAlert != rainAlert) {
          rainAlert = newRainAlert;
          rainNotification(rainAlert);
        }
        });
      }
    });
  }

  void LivingLights() async {
    await livingDatabase.update({
      "LivingLights": isLILightOn,
    });
  }
  
  void KitchenLights() async {
    await kitchenDatabase.update({
      "KitchenLights": isKILightOn,
    });
  }

  void BedroomLights() async {
    await bedroomDatabase.update({
      "BedroomLights": isBDLightOn,
    });
  }
  
  void fan() async {
    await bedroomDatabase.update({
      "Fan": isFanON,
    });
  }
  
  void GardenLights() async {
    await gardenDatabase.update({
      "GardenLights": isGALightOn,
    });
  }

  /* turn all lights off/on */
  void allLights() async {
    await livingDatabase.update({
      "LivingLights": false,
    });
    await kitchenDatabase.update({
      "KitchenLights": false,
    });
    await bedroomDatabase.update({
      "BedroomLights": false,
    });
    await gardenDatabase.update({
      "GardenLights": false,
    });
  }

  void doorLock() async {
    await livingDatabase.update({
      "DoorLock": isDoorLocked,
    });
  }

  void windowSwitch() async {
      await livingDatabase.update({
        "Window": isWindowOn,
      });
    }

  void handleLightON(String room) async {
    switch (room) {
      case 'Kitchen':
        await kitchenDatabase.update({
          "KitchenLights": true,
        });
        break;
      case 'Garden':
        await gardenDatabase.update({
          "GardenLights": true,
        });
        break;
      case 'LivingRoom':
        await livingDatabase.update({
          "LivingLights": true,
        });
        break;
      case 'Bedroom':
        await bedroomDatabase.update({
          "BedroomLights": true,
        });
        break;
    }
  }

  void handleLightOff(String room) async {
    switch (room) {
      case 'Kitchen':
        await kitchenDatabase.update({
          "KitchenLights": false,
        });
        break;
      case 'Garden':
        await gardenDatabase.update({
          "GardenLights": false,
        });
        break;
      case 'LivingRoom':
        await livingDatabase.update({
          "LivingLights": false,
        });
        break;
      case 'Bedroom':
        await bedroomDatabase.update({
          "BedroomLights": false,
        });
        break;
    }
  }

  void _handleVoiceCommand(String command) async {
    String lowerCaseCommand = command.toLowerCase();
    // Turn on lights
    if (lowerCaseCommand.contains('turn') &&
        lowerCaseCommand.contains('on') &&
        lowerCaseCommand.contains('lights')) {
      if (lowerCaseCommand.contains('kitchen')) {
        handleLightON('Kitchen');
      } else if (lowerCaseCommand.contains('garden')) {
        handleLightON('Garden');
      } else if (lowerCaseCommand.contains('living room')) {
        handleLightON('LivingRoom');
      } else if (lowerCaseCommand.contains('bedroom')) {
        handleLightON('Bedroom');
      }
      // Turn off lights
    } else if (lowerCaseCommand.contains('turn') &&
        lowerCaseCommand.contains('off') &&
        lowerCaseCommand.contains('lights')) {
      if (lowerCaseCommand.contains('kitchen')) {
        handleLightOff('Kitchen');
      } else if (lowerCaseCommand.contains('garden')) {
        handleLightOff('Garden');
      } else if (lowerCaseCommand.contains('living room')) {
        handleLightOff('LivingRoom');
      } else if (lowerCaseCommand.contains('bedroom')) {
        handleLightOff('Bedroom');
      }
    }
    // Turn on/off fan
    else if (lowerCaseCommand.contains('turn') &&
        lowerCaseCommand.contains('on') &&
        lowerCaseCommand.contains('fan')) {
        await bedroomDatabase.update({
          "Fan": true,
        });
    } else if (lowerCaseCommand.contains('turn') &&
        lowerCaseCommand.contains('off') &&
        lowerCaseCommand.contains('fan')) {
        await bedroomDatabase.update({
          "Fan": false,
        });
    }
    // Turn on/off window
    else if (lowerCaseCommand.contains('open') &&
        lowerCaseCommand.contains('window')) {
        await livingDatabase.update({
          "Window": true,
        });
    } else if (lowerCaseCommand.contains('close') &&
        lowerCaseCommand.contains('window')) {
        await livingDatabase.update({
          "Window": false,
        });
    }
    // Turn on/off door
    else if (lowerCaseCommand.contains('open') &&
        lowerCaseCommand.contains('door')) {
        await livingDatabase.update({
          "DoorLock": false,
        });
    } else if (lowerCaseCommand.contains('close') &&
        lowerCaseCommand.contains('door')) {
        await livingDatabase.update({
          "DoorLock": true,
        });
    }
  }

  Timer? _timer;

  void _listen() async {
    if (!_speech.isListening) {
      setState(() {
        isListening = true;
      });
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Listening Status: $status');
          if (status == 'notListening') {
            setState(() {
              isListening = false;
            });
            _timer?.cancel();
          }
        },
        onError: (errorNotification) {
          print('Error: $errorNotification');
          setState(() {
            isListening = false;
          });
          _timer?.cancel();
        },
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              print('Recognized: ${result.recognizedWords}');
              _handleVoiceCommand(result.recognizedWords);
            });
          },
        );
        _timer = Timer(Duration(seconds: 10), () {
          setState(() {
            isListening = false;
          });
          _speech.stop();
        });
      }
    } else {
      setState(() {
        isListening = false;
      });
      _speech.stop();
      _timer?.cancel();
    }
  }

  
//--------------------------------- Notifications ---------------------------------
 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
     FlutterLocalNotificationsPlugin();

  void initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void flameNotification(bool flameAlert) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'flame_channel_id',
      'flame Alert',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    if (flameAlert) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Flame Alert',
        'There is fire in the house!',
        platformChannelSpecifics,
        payload: 'flame_notification_payload',
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Flame Alert',
        'Fire Cleared',
        platformChannelSpecifics,
        payload: 'flame_notification_payload',
      );
    }
  }

  void gasNotification(bool gasAlert) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'gas_channel_id',
      'Gas Alert',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    if (gasAlert) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Gas Alert',
        'Gas Leak Detected!',
        platformChannelSpecifics,
        payload: 'gas_notification_payload',
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Gas Alert',
        'Gas Alert Cleared!',
        platformChannelSpecifics,
        payload: 'gas_notification_payload',
      );
    }
  }
  
  void pirNotification(bool pirAlert) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'pir_channel_id',
      'Motion Alert',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    if (pirAlert) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Motion Alert',
        'There is a motion detected outside the house!',
        platformChannelSpecifics,
        payload: 'pir_notification_payload',
      );
    }
  }
  
  void rainNotification(bool rainAlert) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'rain_channel_id',
      'Rain Alert',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    if (rainAlert) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Rain Alert',
        'Windows Closed due to rain!',
        platformChannelSpecifics,
        payload: 'rain_notification_payload',
      );
    }
    else {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Rain Alert',
        'The rain has stopped',
        platformChannelSpecifics,
        payload: 'rain_notification_payload',
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,

      //---------------------------------AppBar---------------------------------
      appBar: AppBar(
        /* menu icon */
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Image.asset(
          isDarkMode
          ? 'assets/logo white.png'
          : 'assets/logo black.png',
          width: 170,
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
        /*=================== Header =================*/
        DrawerHeader(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : sharedcolors.lime,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Column(
            children: [
              ListTile(
            /*=================== Icon =================*/
            leading: Icon(
              FontAwesomeIcons.userCircle,
              color: isDarkMode ? Colors.white : Colors.white,
              size: 40,
            ),
            /*=================== Hi messege =================*/
            title: Text(
              'Hi, ${user?.username ?? ''}!',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.white,
                fontSize: 17,
                fontFamily: 'Roboto',
              ),
            ),
            /*=================== Email =================*/
            subtitle: Text(
              user?.email ?? '',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.white,
                fontSize: 15,
                fontFamily: 'Roboto',
              ),
            ),
              ),
              /*=================== edit profile button =================*/
              Column(
            children: [
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => profile()),
              );
                },
                style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? sharedcolors.lime
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
                ),
                child: Text(
              'Edit Profile',
              style: TextStyle(
                color: isDarkMode
                ? Colors.white
                : sharedcolors.lime,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
                ),
              ),
            ],
              ),
            ],
          ),
            ],
          ),
        ),
        /*=================== Rooms =================*/
        ListTile(
          leading: Icon(
            Icons.home,
            color: Colors.white,
          ),
          title: Text(
            'Rooms',
            style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            // Navigate to another page
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RoomsPage()),
            );
          },
        ),

        /*=================== Home Devices =================*/
        ListTile(
          leading: Icon(
            Icons.devices,
            color: Colors.white,
          ),
          title: Text(
            'Home Devices',
            style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            // Navigate to another page
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeDevicesPage()),
            );
          },
        ),

        /*=================== Settings =================*/
        ListTile(
          leading: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          title: Text(
            'Settings',
            style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            // Navigate to another page
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => setting()),
            );
          },
        ),
      ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(90),
        bottomRight: Radius.circular(90),
          ),
        ),
        elevation: 1,
        backgroundColor: isDarkMode ? Colors.black : sharedcolors.lime,
        width: MediaQuery.of(context).size.width * 0.6,
      ),

      //---------------------------------Body---------------------------------
      body: Container(
        decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white, 
            ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //---------------------------------header Section---------------------------------
                header(isDarkMode, user),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'Quick Access',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //--------------------------------- Lights ---------------------------------
                    GestureDetector(
                      onTap: () {
                      // Show options from the bottom
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                        return Container(
                          height: 500,
                          color: isDarkMode ? Colors.black : Colors.white,
                          child: Column(
                          children: [
                            SizedBox(height: 20,),

                            /* Living Room */
                            ListTile(
                              onTap: () async {
                                  setState(() {
                                   isLILightOn = !isLILightOn;
                                   LivingLights();
                                     });
                                Navigator.pop(context);
                                },
                              leading: Icon(Icons.lightbulb, color: isDarkMode ? Colors.white : Colors.black,),
                              title: Text(
                                'Living Room',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                isLILightOn ? 'On' : 'Off',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                           
                            /* Kitchen */
                            ListTile(
                              onTap: () async {
                                  setState(() {
                                   isKILightOn = !isKILightOn;
                                   KitchenLights();
                                     });
                                Navigator.pop(context);
                              },
                             leading: Icon(Icons.lightbulb, color: isDarkMode ? Colors.white : Colors.black,),
                              title: Text(
                                'Kitchen',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                isKILightOn ? 'On' : 'Off',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            
                            /* Bedroom */
                            ListTile(
                              onTap: () async {
                                  setState(() {
                                   isBDLightOn = !isBDLightOn;
                                   BedroomLights();
                                     });
                                Navigator.pop(context);
                              },
                            leading: Icon(Icons.lightbulb, color: isDarkMode ? Colors.white : Colors.black,),
                              title: Text(
                                'Bedroom',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                isBDLightOn ? 'On' : 'Off',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            
                            /* Garden */
                            ListTile(
                              onTap: () async {
                                  setState(() {
                                   isGALightOn = !isGALightOn;
                                   GardenLights();
                                     });
                                Navigator.pop(context);
                              },
                            leading: Icon(Icons.lightbulb, color: isDarkMode ? Colors.white : Colors.black,),
                              title: Text(
                                'Garden',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                isGALightOn ? 'On' : 'Off',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          
                            Divider( color: isDarkMode ? Colors.white : Colors.black, height: 20, thickness: 1, indent: 20, endIndent: 20, ),
                            ListTile(
                              onTap: () async {
                                  setState(() {
                                   allLights();
                                     });
                                Navigator.pop(context);
                              },
                            leading: Icon(Icons.lightbulb, color: isDarkMode ? Colors.white : Colors.black,),
                              title: Text(
                                'Turn Off All Lights',
                                style: TextStyle(
                                fontSize: 14, // Reduce font size
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          
                          ],
                          ),
                        );
                        },
                      );
                      },
                      child: Column(
                      children: [
                        Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          color: sharedcolors.lime,
                        ),
                        child: Center(
                          child: Icon(
                          Icons.lightbulb,
                          color: Colors.white,
                          ),
                        ),
                        ),
                        SizedBox(height: 5),
                        Text(
                        'Lights',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                        ),
                      ],
                      ),
                    ),

                    //-------------------------------- Fan ---------------------------------
                    GestureDetector(
                      onTap: () {
                      // Handle fan tap
                      setState(() {
                        isFanON = !isFanON;
                        fan();
                      });
                      },
                      child: Column(
                      children: [
                        Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          color: isFanON ? sharedcolors.lime : Colors.red,
                        ),
                        child: Center(
                          child: Icon(Icons.ac_unit, color: Colors.white),
                        ),
                        ),
                        SizedBox(height: 5),
                        Text(
                        'Fan',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                        ),
                      ],
                      ),
                    ),
                    //--------------------------------- Door ---------------------------------
                    GestureDetector(
                      onTap: () {
                      // Handle door tap
                      setState(() {
                        isDoorLocked = !isDoorLocked;
                        doorLock();
                      });
                      },
                      child: Column(
                      children: [
                        Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          color: isDoorLocked ? sharedcolors.lime : Colors.red,
                        ),
                        child: Center(
                          child: isDoorLocked ? Icon(Icons.lock, color: Colors.white) : Icon(Icons.lock_open, color: Colors.white),
                        ),
                        ),
                        SizedBox(height: 5),
                        Text(
                        'Door Lock',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                        ),
                      ],
                      ),
                    ),

                    //--------------------------------- Window ---------------------------------
                    GestureDetector(
                      onTap: () {
                      // Handle window tap
                      setState(() {
                        isWindowOn = !isWindowOn;
                        windowSwitch();
                      });
                      },
                      child: Column(
                      children: [
                        Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          color: isWindowOn ? sharedcolors.lime : Colors.red,
                        ),
                        child: Center(
                          child: isWindowOn ? Icon(Icons.window, color: Colors.white) : Icon(Icons.window_sharp, color: Colors.white),
                        ),
                        ),
                        SizedBox(height: 5),
                        Text(
                        'Window',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                        ),
                      ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'All Rooms',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 170),
                        GestureDetector(
                        onTap: () {
                          // Navigate to another page
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoomsPage()),
                          );
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: isDarkMode ? Colors.white : Colors.black,
                          size: 30,
                        ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: false,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.9,
                  ),
                  items: [
                  //---------------------------------LIVING ROOM---------------------------------
                  GestureDetector(
                    onTap: () {
                      // Navigate to another page
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => livingRoom()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/living room.jpg'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                        color: isDarkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                        ),
                      ],
                      ),
                      child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                        'Living Room',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),
                      ),
                    ),
                    ),

                  //---------------------------------KITCHEN---------------------------------
                  GestureDetector(
                    onTap: () {
                    // Navigate to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => kitchenPage()),
                    );
                    },
                    child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                      image: AssetImage('assets/kitchen.jpg'),
                      fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                        ),
                      ],
                      ),
                      child: Center(
                      child: Text(
                        'Kitchen',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                    ),
                    ),
                  ),

                  //---------------------------------BEDROOM---------------------------------
                  GestureDetector(
                    onTap: () {
                    // Navigate to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => bedroomPage()),
                    );
                    },
                    child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                      image: AssetImage('assets/bedroom.jpg'),
                      fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                        ),
                      ],
                      ),
                      child: Center(
                      child: Text(
                        'Bedroom',
                        style: TextStyle(
                        color:Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                    ),
                    ),
                  ),

                  //---------------------------------GARDEN---------------------------------
                  GestureDetector(
                    onTap: () {
                    // Navigate to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GardenPage()),
                    );
                    },
                    child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                      image: AssetImage('assets/garden.jpg'),
                      fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                        ),
                      ],
                      ),
                      child: Center(
                      child: Text(
                        'Garden',
                        style: TextStyle(
                        color:Colors.white,
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
              SizedBox(height: 100),
              
              /* FaQ(), */
              footer(),
            ],
          ),
        ),
      ),
      
      //---------------------------------Voice Command---------------------------------
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(0,00,15,65),
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            color: isDarkMode? Colors.black : Colors.white,
          ),
          backgroundColor: isDarkMode ? Colors.white : sharedcolors.lime,
        ),
      ),
    );
  }
//---------------------------------FAQ'S---------------------------------
  /* Container FaQ() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white : sharedcolors.lime,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'FAQs',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text(
              'How do I turn on the lights in the kitchen?',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'You can turn on the lights in the kitchen by saying "Turn on the lights in the kitchen"',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'How do I turn off the lights in the garden?',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'You can turn off the lights in the garden by saying "Turn off the lights in the garden"',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'How do I turn on the lights in the living room?',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'You can turn on the lights in the living room by saying "Turn on the lights in the living room"',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            title
            : Text(
              'How do I turn off the lights in the bedroom?',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'You can turn off the lights in the bedroom by saying "Turn off the lights in the bedroom"',
              style: TextStyle(
                color: isDarkMode ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  } */
//---------------------------------FOOTER AND COPYRIGHTS---------------------------------
  Container footer(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white : sharedcolors.lime,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      child: Text(
        '© 2024 Home Shpere.                                        \n All rights reserved.',
        style: TextStyle(
          color: isDarkMode ? Colors.black : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
//---------------------------------LOGO Section---------------------------------
  Container header(bool isDarkMode, MyUser? user) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            DateFormat('EEE, d MMMM yyyy').format(DateTime.now()),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
         SizedBox(height: 20),
          /* welcome user */
          Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hi ${user?.username ?? ''}!',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child:Text(
            'Welcome to Home Sphere',
            style: TextStyle(
              color:sharedcolors.lime,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                FontAwesomeIcons.cloudSun,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 25,
              ),
              SizedBox(width: 20),
              Text(
                '$temp°',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 100),
                Icon(
                  FontAwesomeIcons.thermometerEmpty,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 30,
                ),
              Text(
                '$humidity%',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          /* ================ Flame and Gas Alert ===============*/
          SizedBox(height: 20),
          Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Alert Status',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
          ),
          SizedBox(height: 20),
          Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            /* fire alert */
            GestureDetector(
              child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                CircleAvatar(
                  backgroundColor: flameAlert ? Colors.red : isDarkMode ? Colors.black : Colors.grey[200],
                  radius: 25, // Change the circle size
                  child: Icon(
                  flameAlert
                    ? Icons.fire_extinguisher
                    : Icons.check,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 20, // Reduce icon size
                  ),
                ),
                SizedBox(height: 8), // Reduce spacing
                Text(
                  flameAlert ? 'Flame Detected' : 'No Flame',
                  style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18, // Reduce font size
                  fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4), // Reduce spacing
                
                if (flameAlert)
                    ElevatedButton(
                      onPressed: () async {
                      await launch('tel: 180');
                      },
                      child: Column(
                      children: [
                        Icon(
                        Icons.call,
                        color: isDarkMode ? Colors.white : sharedcolors.lime,
                        ),
                        SizedBox(height: 4),
                        Text(
                      'Call Fire Department.',
                      style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight:FontWeight.w500,
                      ),
                    ),
                      ],
                      ),
                      style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      textStyle: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      backgroundColor: isDarkMode ? Colors.black : Colors.white , // Change the button color here
                      ),
                    ),
                ],
              ),
              ),
            ),

            /* Gas Alert */
            GestureDetector(
              child: Container(
                margin: EdgeInsets.all(5), // Reduce margin size
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: gasAlert ? Colors.red : isDarkMode ? Colors.black : Colors.grey[200],
                  radius: 25, // Change the circle size
                  child: Icon(
                gasAlert
                    ? Icons.warning
                    : Icons.check,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 20, // Reduce icon size
                  ),
                ),
                SizedBox(height: 8), // Reduce spacing
                Text(
                gasAlert ? 'Gas Detected' : 'No Gas',
                  style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 18, // Reduce font size
                fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4), // Reduce spacing
                
                if (gasAlert)
                    ElevatedButton(
                      onPressed: () async {
                      await launch('tel: 123');
                      },
                      child: Column(
                      children: [
                        Icon(
                        Icons.call,
                        color: isDarkMode ? Colors.white : sharedcolors.lime,
                        ),
                        SizedBox(height: 4),
                        Text(
                      'Call Ambulance.',
                      style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight:FontWeight.w500,
                      ),
                    ),
                      ],
                      ),
                      style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      textStyle: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      backgroundColor: isDarkMode ? Colors.black : Colors.white , // Change the button color here
                      ),
                    ),
                  ],
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
