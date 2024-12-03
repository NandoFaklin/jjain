// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopUpChangePage extends StatelessWidget {
  const PopUpChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        children: [
          SizedBox(
            height: 45,
          ),
          //============================ D E R M A
          Text(
            "Derma",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff1D1D1D),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          //============================ I N F A Q & S U M B A N G A N
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector infaq.png"),
                ),
              ),
              title: Text(
                "Infaq & Sumbangan",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          //============================ B E R K O N G S I -  K E B A I K A N
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector berkongsi.png"),
                ),
              ),
              title: Text(
                "Berkongsi Kebaikan",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),

          //============================ M A S J I D & P E R K H I D M A T A N
          Text(
            "Masjid & Perkhidmatan",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff1D1D1D),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          //============================ I N F O R M A S I - A K T I V I T I
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector informasi.png"),
                ),
              ),
              title: Text(
                "Informasi Aktiviti",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          //============================ I N F O - M A S J I D
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Stack(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(5.2),
                      child: Image.asset("images/vector masjid1.png"),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SizedBox(
                      // height: 30,
                      // width: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Image.asset(
                          "images/vector masjid2.png",
                          width: 8.33,
                          height: 8.33,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                "Info Masjid",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          //============================ P E R K H I D M A T A N
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector perkhidmatan.png"),
                ),
              ),
              title: Text(
                "Perkhidmatan",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          //============================ K E C E M A S A N
          Text(
            "Kecemasan",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff1D1D1D),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          //============================ P E N G U R U S A N - J E N A Z A H
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector jenazah.png"),
                ),
              ),
              title: Text(
                "Pengurusan Jenazah",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          //============================ K E N D E R A A N - J E N A Z A H
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector kendaraan.png"),
                ),
              ),
              title: Text(
                "Kenderaan Jenazah",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          //============================ B A C A A N - D O A - Y A S I N / TAHLIL
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector bacaan doa.png"),
                ),
              ),
              title: Text(
                "Bacaan Doa/ Yasin/ Tahlil",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          //============================ S H O L A T - J E N A Z A H - G H A I B
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector sholat jenazah.png"),
                ),
              ),
              title: Text(
                "Sholat Jenazah Ghaib",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          //============================ R U Q Y A H
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector ruqyah.png"),
                ),
              ),
              title: Text(
                "Ruqyah",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          //============================ L A I N - L A I N
          Text(
            "Kecemasan",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff1D1D1D),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          //============================ T A H F I Z
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector tahfiz.png"),
                ),
              ),
              title: Text(
                "Tahfiz",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),

          //============================ J U A L A N -  A S N A F
          Material(
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.2),
                  child: Image.asset("images/vector jualan.png"),
                ),
              ),
              title: Text(
                "Jualan asnaf",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
