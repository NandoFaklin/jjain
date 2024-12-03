import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/SplashScreen/Welcome/WelcomeScreen.dart';

class OnBoarding_Tiga extends StatelessWidget {
  const OnBoarding_Tiga({super.key});

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
                image: AssetImage("images/Sedekah.png"),
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
                  "Bersedekah lebih mudah \ntanpa halangan",
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
                  "Beramal tanpa mengira waktu, dimana \npun anda berada, pada bila-bila masa, \nlaksanakan dengan 1 klik sahaja",
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
                SizedBox(
                  width: 6,
                ),
                Container(
                  height: 11,
                  width: 11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5268B5),
                  ),
                ),
              ],
            ),

            //================================================ Button
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Kembali",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF999898),
                    ),
                  ),
                ),
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
                          builder: (context) => WelcomePage(),
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
          ],
        ),
      ),
    );
  }
}
