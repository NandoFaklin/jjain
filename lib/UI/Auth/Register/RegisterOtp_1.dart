import 'package:flutter/material.dart';
import 'package:jhein_beta/UI/Auth/Register/VerifyCode_2.dart';
import 'package:jhein_beta/UI/SplashScreen/Welcome/WelcomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class OTP_Register extends StatefulWidget {
  const OTP_Register({super.key});

  @override
  State<OTP_Register> createState() => _OTP_RegisterState();
}

class _OTP_RegisterState extends State<OTP_Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //===================================================== Icon, Text
          ListTile(
            horizontalTitleGap: 12,
            contentPadding: const EdgeInsets.only(top: 53, left: 20),
            leading: InkWell(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: const WelcomePage(),
                      );
                    }));
              },
              child: SizedBox(
                height: 18.67,
                width: 18.67,
                child: Image.asset("images/back.png"),
              ),
            ),
            title: Text(
              "Isi No. tel anda",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1D1D1D),
              ),
            ),
          ),

          //===================================================== Text
          Container(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              "Kami akan menghantarkan kod \npengesahan ke telefon anda",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF474747),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),

          //===================================================== Pick number
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          left: 40,
          right: 40,
          bottom: 67,
        ),
        child: MaterialButton(
          height: 48,
          minWidth: 280,
          color: const Color(0xff5268B5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VerifCodeRegister(),
                ));
          },
          child: Text(
            "Hantar Kod Pengesaan",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
