
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/Auth/Login/LoginOtp_1.dart';
import 'package:jhein_beta/UI/Auth/Register/RegisterOtp_1.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 273.71,
              width: 283.74,
              child: Image.asset("images/Hands Pray.png"),
            ),
          ),

          //======================================= Text
          Text(
            "Selamat Datang",
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D1D),
            ),
          ),
          const SizedBox(
            height: 17,
          ),

          //======================================= Text
          Text(
            "Asalamualaikum, Log masuk terlebih \ndahulu sebelum menggunakan aplikasi \nJHEIN Apps. Jika anda belum \nmempunyai akaun, anda harus \nmendaftar terlebih dahulu.",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF636363),
            ),
          ),
          const SizedBox(
            height: 127,
          ),

          //======================================= Button
          MaterialButton(
            height: 48,
            minWidth: 280,
            color: const Color(0xFF5268B5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: const Otp_Login(),
                    );
                  }));
            },
            child: Text(
              "Log Masuk",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),

          //======================================== TextButton
          TextButton(
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: const OTP_Register(),
                    );
                  }));
            },
            child: Text(
              "Daftar Baharu",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF5268B5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
