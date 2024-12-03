import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/MainHome/Home/Home.dart';


class LoadingLogin extends StatefulWidget {
  const LoadingLogin({
    super.key,
  });

  @override
  _LoadingLoginState createState() => _LoadingLoginState();
}

class _LoadingLoginState extends State<LoadingLogin> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: const HomePage(),
                );
              },
            ),
                (Route<dynamic> route) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //================================================== Text
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 8,
                top: 53,
              ),
              child: Text(
                "Selamat datang kembali",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D1D1D),
                ),
              ),
            ),
            const SizedBox(height: 6),
            //================================================== Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Selamat datang kembali",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Ahmad",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1D1D1D),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "noor",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1D1D1D),
                    ),
                  ),
                ],
              ),
            ),

            //===================================================== Image
            const SizedBox(height: 78),
            Center(
              child: Container(
                width: 309,
                height: 312.04,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/Vector Account.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            //===================================================== Text
            const SizedBox(height: 131.96),
            Padding(
              padding: const EdgeInsets.only(left: 21),
              child: Text(
                "Beralih ke Halaman Utama Secara \nAutomatik, Sila tunggu..",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF000000).withOpacity(0.50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
