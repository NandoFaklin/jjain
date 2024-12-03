// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/MainHome/Log/Log%20Selesai.dart';


class FilterLogPage extends StatelessWidget {
  const FilterLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.1),
          topRight: Radius.circular(screenWidth * 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenWidth * 0.1),
              topRight: Radius.circular(screenWidth * 0.1),
            ),
            elevation: 0,
            color: Color(0xffFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.only(top: screenWidth * 0.06),
              title: Text(
                "Filter",
                style: GoogleFonts.roboto(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1D1D),
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: LogSelesaiPage(),
                      );
                    },
                  ));
                },
                child: Icon(
                  Icons.close,
                  color: Color(0xFF1D1D1D),
                ),
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          //================================== Tanggal
          Text(
            "Tanggal",
            style: GoogleFonts.roboto(
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1D1D1D),
            ),
          ),
          SizedBox(height: screenWidth * 0.007),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth * 0.65,
                height: screenWidth * 0.14,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  border: Border.all(
                    width: 1,
                    color: Color(0xffDCDCDC),
                  ),
                  color: Color(0xffFFFFFF),
                ),
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "XX/XX/XX",
                      hintStyle: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1D1D1D),
                      ),
                    ),
                    style: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),
                ),
              ),
              Material(
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: screenWidth * 0.09,
                    width: screenWidth * 0.09,
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.01),
                      child: Image.asset(
                        "images/Calendar.png",
                        color: Color(0xFF1D1D1D),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          //================================== Kegiatan
          Text(
            "Kegiatan",
            style: GoogleFonts.roboto(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1D1D1D),
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Wrap(
            spacing: screenWidth * 0.03,
            children: [
              FilterChip(
                label: Text(
                  "Ceramah",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Pegurusan Jenazah",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Tahfidz",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Kendaraan Jenazah",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Infaq & Sumbangan",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Sewa Ruang",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Perkhidmatan",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Info Masjid",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Aktiviti Masjid",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),
              FilterChip(
                label: Text(
                  "Bacaan Doa/ yasin/ Tahlil",
                  style: TextStyle(color: Color(0xFF1D1D1D)),
                ),
                onSelected: (_) {},
                selectedColor: Color(0xffE9E9E9),
                backgroundColor: Colors.transparent,
                selected: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xffD9D9D9)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.20),
                ),
              ),

              // Add more FilterChips here with the same pattern
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: MaterialButton(
              height: screenWidth * 0.12,
              minWidth: screenWidth,
              color: Color(0xff5268B5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              onPressed: () {
                // Navigator.of(context).pushReplacement(PageRouteBuilder(
                //   pageBuilder: (context, animation, secondaryAnimation) {
                //     return FadeTransition(
                //       opacity: animation,
                //       child: LogSelesaiPage(),
                //     );
                //   },
                // ));
              },
              child: Text(
                "Cari",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
