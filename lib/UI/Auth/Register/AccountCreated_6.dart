// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/SplashScreen/Welcome/WelcomeScreen.dart';


class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: WelcomePage(),
            );
          }));
    });
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //================================================== Text
          Container(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 53,
            ),
            child: Text(
              "Akaun selesai didaftarkan",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1D1D),
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          //================================================== Text
          Container(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
            ),
            child: Text(
              "Tahniah! akaun anda berjaya \ndidaftarkan",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF474747),
              ),
            ),
          ),

          //===================================================== Image
          SizedBox(
            height: 78,
          ),
          Center(
            child: Container(
              width: 309,
              height: 312.04,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Quran.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          //===================================================== Text
          SizedBox(
            height: 131.96,
          ),
          Container(
            padding: EdgeInsets.only(left: 21),
            child: Text(
              "Beralih ke Halaman Utama Secara \nAutomatik, Sila tunggu..",
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000).withOpacity(0.50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
