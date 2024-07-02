import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class livingRoom extends StatefulWidget {
  @override
  _livingRoomState createState() => _livingRoomState();
}

class _livingRoomState extends State<livingRoom> {
  bool isLightOn = false;
  bool isAlarmOn = false;
  bool isDoorLocked = false;
  bool isFanOn = false;
  bool isWindowOn = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref("LivingRoom");

  @override
  void initState() {
    super.initState();
    // Set up event listener to update state based on Firebase changes
    ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          Map? snapshotValue = event.snapshot.value as Map?;
          isLightOn = snapshotValue?['LivingLights'];
          isDoorLocked = snapshotValue?['DoorLock'];
          isWindowOn = snapshotValue?['Window'];
        });
      }
    });
  }

  void Lightswitch() async {
    await ref.update({
      "LivingLights": isLightOn,
    });
  }

  void doorLock() async {
    await ref.update({
      "DoorLock": isDoorLocked,
    });
  }

  void windowSwitch() async {
      await ref.update({
        "Window": isWindowOn,
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/living room.jpg'),
        fit: BoxFit.cover,
      ),
        ),
        child: Container(
      margin: EdgeInsets.fromLTRB(0, 300, 0, 0), // Reduce margin size
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(600),
        ),
        boxShadow: [
          BoxShadow(
        color: Colors.black.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        // Add glass effect
        border: Border.fromBorderSide(
          BorderSide(
        color: Colors.white.withOpacity(0.1),
        width: 2,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
        sharedcolors.lime.withOpacity(0.5),
        Colors.black.withOpacity(0.1),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(10), // Reduce margin size
        padding: EdgeInsets.all(8), // Reduce padding size
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Living Room',
            style: TextStyle(
          color: Colors.white,
          fontSize: 44, // Adjust font size
          fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8), // Reduce spacing
        Text(
          'Your Living room is connected                with the following devices:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20, // Adjust font size
          ),
        ),
        SizedBox(height: 16), // Adjust spacing
      
        Row(
          children: [
            Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
            isLightOn = !isLightOn;
            Lightswitch();
              });
            },
            child: Container(
              margin: EdgeInsets.all(10), // Reduce margin size
              padding: EdgeInsets.all(8), // Reduce padding size
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35, // Change the circle size
                child: Icon(
              isLightOn
                  ? Icons.lightbulb
                  : Icons.lightbulb_outline,
              color: sharedcolors.lime,
              size: 30, // Reduce icon size
                ),
              ),
              SizedBox(height: 8), // Reduce spacing
              Text(
                'Light',
                style: TextStyle(
              color: Colors.white,
              fontSize: 18, // Reduce font size
              fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4), // Reduce spacing
              Text(
                isLightOn ? 'On' : 'Off',
                style: TextStyle(
              color: Colors.white,
              fontSize: 14, // Reduce font size
              fontWeight: FontWeight.bold,
                ),
              ),
            ],
              ),
            ),
          ),
            ),
            Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
            isDoorLocked = !isDoorLocked;
            doorLock();
              });
            },
            child: Container(
              margin: EdgeInsets.all(10), // Reduce margin size
              padding: EdgeInsets.all(8), // Reduce padding size
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35, // Change the circle size
                child: Icon(
              isDoorLocked
                  ? Icons.lock_rounded
                  : Icons.lock_open_rounded,
              color: sharedcolors.lime,
              size: 30, // Reduce icon size
                ),
              ),
              SizedBox(height: 8), // Reduce spacing
              Text(
                'Door',
                style: TextStyle(
              color: Colors.white,
              fontSize: 18, // Reduce font size
              fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4), // Reduce spacing
              Text(
                isDoorLocked ? 'Locked' : 'Unlocked',
                style: TextStyle(
              color: Colors.white,
              fontSize: 14, // Reduce font size
              fontWeight: FontWeight.bold,
                ),
              ),
            ],
              ),
            ),
          ),
            ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isWindowOn = !isWindowOn;
                windowSwitch();
              });
            },
            child: Container(
              margin: EdgeInsets.all(10), // Reduce margin size
              padding: EdgeInsets.all(8), // Reduce padding size
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 35, // Change the circle size
                    child: Icon(
                      isWindowOn
                          ? FontAwesomeIcons.windowMaximize
                          : FontAwesomeIcons.windowMinimize,
                      color: sharedcolors.lime,
                      size: 30, // Reduce icon size
                    ),
                  ),
                  SizedBox(height: 8), // Reduce spacing
                  Text(
                    'Window',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Reduce font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4), // Reduce spacing
                  Text(
                    isWindowOn ? 'Open' : 'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14, // Reduce font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
          ],
        ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}
