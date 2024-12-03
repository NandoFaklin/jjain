import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/Auth/Login/LoadingLogin_4.dart';
import 'package:jhein_beta/UI/Auth/Register/identityInsert_4.dart';
import 'package:lottie/lottie.dart';


class VerifSuccessLogin extends StatelessWidget {
  const VerifSuccessLogin({super.key, required this.password});
  final String password;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: LoadingLogin(),
            );
          }));
    });
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //===================================================== Icon, Text
          ListTile(
            horizontalTitleGap: 12,
            contentPadding: EdgeInsets.only(top: 53, left: 20),
            title: Text(
              "Pengesahan berjaya!",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1D1D1D),
              ),
            ),
          ),

          //===================================================== Text
          Container(
            padding: EdgeInsets.only(left: 18),
            child: Text(
              "Tahniah! Nombor telefon anda telah \ndisahkan",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF474747),
              ),
            ),
          ),
          SizedBox(
            height: 28,
          ),

          //===================================================== Box Number
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Widgets untuk menampilkan password dalam bentuk box
                _buildPasswordBox(password[0]),
                _buildPasswordBox(password[1]),
                _buildPasswordBox(password[2]),
                _buildPasswordBox(password[3]),
              ],
            ),
          ),
          SizedBox(
            height: 259,
          ),
          //============================================ Image Success
          Center(
            child: SizedBox(
              height: 120,
              width: 120,
              child: Lottie.asset(
                "lottie/Success.json",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Method untuk membuat box password
Widget _buildPasswordBox(String passwordCharacter) {
  return Container(
    height: 71,
    width: 71,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        width: 2,
        color: Color(0xffC9C9C9),
      ),
    ),
    child: Center(
      child: Text(
        passwordCharacter,
        style: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1D1D1D),
        ),
      ),
    ),
  );
}
