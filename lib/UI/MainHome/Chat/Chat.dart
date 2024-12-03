// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _masjid = [
    {
      "gambar": "Masjid An Nur.jpeg",
    },
    {
      "gambar": "Masjid An Nur.jpeg",
    },
    {
      "gambar": "Masjid An Nur.jpeg",
    },
    {
      "gambar": "Masjid An Nur.jpeg",
    },
    {
      "gambar": "Masjid An Nur.jpeg",
    },
    {
      "gambar": "Masjid An Nur.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(top: 27, left: 20),
            horizontalTitleGap: 7,
            title: Text(
              "Mesej",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xff1D1D1D),
              ),
            ),
          ),

          //================================ S E A R C H
          SizedBox(
            height: 16,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              onTap: () {},
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(vertical: 12), // Atur tinggi di sini
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Color(0xff999898),
                ),
                hintText: 'Cari',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff999898),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                    width: 1,
                    color: Color(0xffDCDCDC),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 12,
          ),

          //============================== L I S T - G A M B A R
          //============================== GAMBAR
          Container(
            margin: EdgeInsets.only(left: 20),
            height: 54,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _masjid.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 18),
                  height: 52,
                  width: 52,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                "images/${_masjid[index]['gambar']}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (index > 0)
                        Opacity(
                          opacity:
                          0.6, // Atur tingkat opasitas di sini, dari 0.0 (transparan) hingga 1.0 (tidak transparan)
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .grey, // Warna latar belakang untuk menampilkan opasitas
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          //=================================== M E S J I D - AN - N U R
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Masjid An-Nur",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff313131),
                  ),
                ),

                //==================================== U S T A D - A N W A R
                SizedBox(
                  height: 12,
                ),

                ListTile(
                  // tileColor: Colors.amber,
                  contentPadding: EdgeInsets.zero,

                  //============================ Foto
                  leading: Stack(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("images/Ustad Anwar.jpeg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: Color(0xff5268B5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //============================ Title
                  title: Text(
                    "Ustad Anwar",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1D1D1D),
                    ),
                  ),
                  //============================ SubTitle
                  subtitle: Text(
                    "Salam mas, saya Anwar se...",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff959595),
                    ),
                  ),

                  //============================ Text
                  trailing: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Masjid An-Nur (Pengurus)",
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4C4C4C),
                          ),
                        ),
                        Text(
                          "5 minit yang lalu",
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff959595),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  thickness: 1,
                  height: 1,
                ),

                //=========================== U S T A D - M A L I K
                ListTile(
                  // tileColor: Colors.amber,
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    // Navigator.of(context).push(PageRouteBuilder(
                    //     pageBuilder: (context, animation, secondaryAnimation) {
                    //       return FadeTransition(
                    //         opacity: animation,
                    //         child: DetailChatPage(),
                    //       );
                    //     }));
                  },

                  //============================ Foto
                  leading: Stack(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("images/Ustad Malik.jpeg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //============================ Title
                  title: Text(
                    "Ustad Malik",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1D1D1D),
                    ),
                  ),
                  //============================ SubTitle
                  subtitle: Text(
                    "Salam mas, saya Malik se...",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff959595),
                    ),
                  ),

                  //============================ Text
                  trailing: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Masjid An-Nur (Sekretaris)",
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4C4C4C),
                          ),
                        ),
                        Text(
                          "5 minit yang lalu",
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff959595),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  thickness: 1,
                  height: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
