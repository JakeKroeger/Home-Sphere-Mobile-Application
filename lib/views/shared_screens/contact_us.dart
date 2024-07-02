  import 'package:flutter/material.dart';
  import 'package:firebase_database/firebase_database.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:url_launcher/url_launcher.dart';


  class contactUs extends StatefulWidget {
    const contactUs({Key? key});

    @override
    State<contactUs> createState() => _contactUsState();
  }

  class _contactUsState extends State<contactUs> {
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
            'Contact Us',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            /* =================== Contact Information ======================= */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
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
                      /*================ Phone ==============*/
                        ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          '+1 123 456 7890',
                          style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          await launch('tel:+1 123 456 7890');
                        },
                        ),

                      /*================ Email ==============*/
                      ListTile(
                        leading: Icon(
                          Icons.email,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          'homesphere.eg@gmail.com',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          await launch('mailto: homesphere.eg@gmail.com');
                        },
                      ),

                      /*================ Address ==============*/
                      /* ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          '1234 Home Street, Home City',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          // Add your location link logic here
                        },
                      ), */
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            /* =================== Social Media Links ======================= */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social Media',
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
                          FontAwesomeIcons.facebook,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          'Facebook',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          await launch('https://www.facebook.com/');
                          /* await launchUrl(Uri(path: 'https://www.facebook.com/') ,mode: LaunchMode.inAppWebView); */
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.instagram,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          'Instagram',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                         await launch('https://www.instagram.com/homesphere.eg?igsh=MWRrMDZ1bWttZXdxZw==');
                         /* await launchUrl(Uri(path: 'https://www.instagram.com/homesphere.eg?igsh=MWRrMDZ1bWttZXdxZw==' , scheme: 'https' ), mode: LaunchMode.inAppWebView); */
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            /* =================== Website Link ======================= */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Website',
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
                          FontAwesomeIcons.globe,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        title: Text(
                          'Visit our website',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                         await launch('https://hassiebb.github.io/Home-Sphere/');
                        },
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
