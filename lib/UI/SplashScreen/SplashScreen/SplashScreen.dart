
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/SplashScreen/SplashScreen/OnBoarding/OnBoarding_1.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => OnBoarding_Satu(),
          ));
    });
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Container(
          child: Image.asset(
            "images/JHEIN Logo 1.png",
            width: 257,
            height: 257,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Text(
          "Sistem Komuniti Masjid Digital\nbersepadu Johor ",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5268B5),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
