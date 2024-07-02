import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';
import 'package:smart_home_application/views/shared_screens/contact_us.dart';
import 'package:smart_home_application/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';


class setting extends StatefulWidget {
  const setting({Key? key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  bool isDarkMode = false;
  bool isAlarmOn = false;
  bool isPirOn = false;
  final authService _auth = authService();


  DatabaseReference setting = FirebaseDatabase.instance.ref("Settings");


  @override
  void initState() {
    super.initState();
    
    setting.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          Map? snapshotValue = event.snapshot.value as Map?;
          isAlarmOn = snapshotValue?['AlarmStatus'];
          isDarkMode = snapshotValue?['Theme'];
          isPirOn = snapshotValue?['pirState'];
        });
      }
    });
  }

  void Theme() async {
    await setting.update({
      "Theme": isDarkMode,
    });
  }
  
  void alarmSwitch() async {
    await setting.update({
      "AlarmStatus": isAlarmOn,
    });
  }

  void pirSwitch() async {
    await setting.update({
      "pirState": isPirOn,
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
          'Settings',
          style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          /* =================== Theme ======================= */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Theme',
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
                child: ListTile(
                leading: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  isDarkMode ? 'Light Mode' : 'Dark Mode',
                  style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Change the app theme',
                  style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 15,
                  ),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                    Theme();
                  });
                  },
                  activeColor: sharedcolors.Darklime,
                  activeTrackColor: sharedcolors.lime,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
                ),
              ),
              ],
            ),
           
            SizedBox(height: 20,),
            /* =================== Alarm + PIR ======================= */
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              'Security Settings',
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
                ListTile(
                  leading: Icon(
                  isAlarmOn ? Icons.notifications_active : Icons.notifications_off,
                  color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                  isAlarmOn ? 'Alarm On' : 'Alarm Off',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  ),
                  subtitle: Text(
                  'Turn on/off the alarm system',
                  style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 15,
                  ),
                ),
                  trailing: Switch(
                  value: isAlarmOn,
                  onChanged: (value) {
                    setState(() {
                    isAlarmOn = value;
                    alarmSwitch();
                    });
                  },
                  activeColor: sharedcolors.Darklime,
                  activeTrackColor: sharedcolors.lime,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                  ),
                ),
                Divider(
                  color: isDarkMode ? Colors.white : Colors.black,
                  thickness: 0.3,
                ),
                ListTile(
                  leading: Icon(
                  isPirOn ? Icons.visibility : Icons.visibility_off,
                  color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                  isPirOn ? 'PIR On' : 'PIR Off',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  ),
                  subtitle: Text(
                  'Turn on/off the PIR sensor',
                  style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 15,
                  ),
                ),
                  trailing: Switch(
                  value: isPirOn,
                  onChanged: (value) {
                    setState(() {
                    isPirOn = value;
                    pirSwitch();
                    });
                  },
                  activeColor: sharedcolors.Darklime,
                  activeTrackColor: sharedcolors.lime,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                  ),
                ),
                ],
              ),
              ),
            ],
            ),

            SizedBox(height: 20,),
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
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                ),
                child: Column(
                children: [
                  ListTile(
                  leading: Icon(
                    Icons.info,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'About Us',
                    style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Learn more about us',
                    style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                    ),
                  ),
                  onTap: () async {
                    await launch('https://hassiebb.github.io/Home-Sphere/');
                  },
                  ),
                  Divider(
                  color: isDarkMode ? Colors.white : Colors.black,
                  thickness: 0.3,
                  ),
                  
                  /* ListTile(
                  leading: Icon(
                    Icons.privacy_tip,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => profile(),
                    ),
                    );
                  },
                  ),
                  Divider(
                  color: isDarkMode ? Colors.white : Colors.black,
                  thickness: 0.3,
                  ), */

                  ListTile(
                  leading: Icon(
                    Icons.contact_support,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Contact Us',
                    style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Get in touch with us',
                    style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => contactUs(),
                    ),
                    );
                  },
                  ),
                ],
                ),
              ),
              ],
            ),

            SizedBox(height: 20,),
            /* =================== Logout ======================= */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Logout',
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
                child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color:  Colors.red,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                  color:  Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  ),
                ),
                onTap: () async {
                 // ignore: unused_local_variable
                 dynamic result = await _auth.signOut();
                 Navigator.pushNamedAndRemoveUntil(
                 context, 'login', (route) => false);
           },
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