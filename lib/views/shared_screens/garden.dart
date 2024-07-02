import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';

class GardenPage extends StatefulWidget {
  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  bool isLightOn = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Garden");

  @override
  void initState() {
    super.initState();

    // Set up event listener to update state based on Firebase changes
    ref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          Map? snapshotValue = event.snapshot.value as Map?;
          isLightOn = snapshotValue?['GardenLights'];
        });
      }
    });
  }

  void Lightswitch() async {
    await ref.update({
      "GardenLights": isLightOn,
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
        image: AssetImage('assets/garden.jpg'),
        fit: BoxFit.cover,
      ),
        ),
        child: Container(
      margin: EdgeInsets.fromLTRB(0, 350, 0, 0), // Reduce margin size
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
            'Garden',
            style: TextStyle(
          color: Colors.white,
          fontSize: 44, // Adjust font size
          fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8), // Reduce spacing
        Text(
          'Your Garden is connected with         the following devices:',
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
