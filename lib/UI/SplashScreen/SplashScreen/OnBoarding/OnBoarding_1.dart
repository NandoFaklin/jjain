import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/SplashScreen/SplashScreen/OnBoarding/OnBoarding_2.dart';


class OnBoarding_Satu extends StatelessWidget {
  const OnBoarding_Satu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //================================================== Image Masjid
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Masjid1.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),

          //================================================= Text
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat datang ke \nJHEIN Apps",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Aplikasi sistem komuniti masjid digital \nbersepadu Johor, Informasi antara \nmasjid & acara islamic",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4C4C4C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      //================================================= Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 24, right: 22, bottom: 31),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //============================================= Loading
            Row(
              children: [
                Container(
                  height: 11,
                  width: 11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5268B5),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Container(
                  height: 11,
                  width: 11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDCDCDC),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Container(
                  height: 11,
                  width: 11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDCDCDC),
                  ),
                ),
              ],
            ),

            //================================================ Button
            MaterialButton(
              height: 48,
              minWidth: 115,
              color: Color(0xFF5268B5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => OnBoarding_Dua(),
                    ));
              },
              child: Text(
                "Seterusnya",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
