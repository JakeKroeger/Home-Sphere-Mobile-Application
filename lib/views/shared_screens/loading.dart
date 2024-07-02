import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitChasingDots(
          color: sharedcolors.bluecolor,
          size: 50.0,
        ),
      ),
    );
  }
}
