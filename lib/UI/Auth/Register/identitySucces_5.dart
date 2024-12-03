// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/Auth/Register/identityInsert_4.dart';


class IdentityScreen extends StatefulWidget {
  const IdentityScreen({super.key});

  @override
  _IdentityScreenState createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  String? _selectedGender;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 17, right: 27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //================================================== Icon , Text
              ListTile(
                horizontalTitleGap: 12,
                contentPadding: EdgeInsets.only(top: 53),
                leading: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(PageRouteBuilder(
                    //     pageBuilder: (context, animation, secondaryAniation) {
                    //       return FadeTransition(
                    //         opacity: animation,
                    //         child: VerifNumberCodeScreen(),
                    //       );
                    //     }));
                  },
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset(
                      "images/back.png",
                    ),
                  ),
                ),
                title: Text(
                  "Isi Maklumat anda",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
              ),

              //================================================== Text
              Container(
                padding: EdgeInsets.only(left: 2),
                child: Text(
                  "Isi borang maklumat dibawah",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF474747),
                  ),
                ),
              ),

              SizedBox(height: 32),

              //================================================== Nama Penuh
              TextField(
                focusNode: _focusNode,
                onTap: () {
                  _focusNode.unfocus();
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: IdentityInsertScreen(),
                        );
                      }));
                },
                decoration: InputDecoration(
                  prefixIcon: SizedBox(
                    width: 15,
                    height: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset("images/person.png"),
                    ),
                  ),
                  hintText: 'Nama Penuh',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999898),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xffC9C9C9),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              SizedBox(height: 17),

              //================================================== Email
              TextField(
                decoration: InputDecoration(
                  prefixIcon: SizedBox(
                    width: 15,
                    height: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset("images/email.png"),
                    ),
                  ),
                  hintText: 'E-mail',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999898),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xffC9C9C9),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              SizedBox(height: 17),

              //================================================== Number Phone
              TextField(
                decoration: InputDecoration(
                  prefixIcon: SizedBox(
                    width: 15,
                    height: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset("images/phone.png"),
                    ),
                  ),
                  hintText: '+62',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999898),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xffC9C9C9),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              SizedBox(height: 17),

              //================================================== Card
              TextField(
                decoration: InputDecoration(
                  prefixIcon: SizedBox(
                    width: 15,
                    height: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset("images/card.png"),
                    ),
                  ),
                  hintText: 'Mykad No',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999898),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xffC9C9C9),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              SizedBox(height: 17),

              //================================================== Jenis Kelamin
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(right: 18),
                        height: 50,
                        width: 146,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Radio<String>(
                              activeColor: Color(0xff5268B5),
                              value: 'Lelaki',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            Image.asset(
                              "images/lelaki.png",
                              width: 16,
                              height: 16,
                            ),
                            Text(
                              'Lelaki',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF999898),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(right: 18),
                        height: 50,
                        width: 146,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 5,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Radio<String>(
                              activeColor: Color(0xff5268B5),
                              value: 'Wanita',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                            Image.asset(
                              "images/wanita.png",
                              width: 16,
                              height: 16,
                            ),
                            Text(
                              'Wanita',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF999898),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),

              //================================================== Negara
              TextField(
                decoration: InputDecoration(
                  prefixIcon: SizedBox(
                    width: 15,
                    height: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset("images/real estate.png"),
                    ),
                  ),
                  hintText: 'Negara, Negeri, Daerah',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999898),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xffC9C9C9),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              SizedBox(
                height: 16,
              ),

              //==================================================== Address
              TextField(
                decoration: InputDecoration(
                  prefixIcon: SizedBox(
                    width: 15,
                    height: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset("images/address.png"),
                    ),
                  ),
                  hintText: 'Alamat',
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999898),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xffC9C9C9),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              //=============================================== Text
              SizedBox(
                height: 38,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Dengan mendaftar, Anda bersetuju dengan",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "terma &",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "syarat",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "dan",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        " Akta pelindungan privasi",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Jainji",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),

              //======================================== Button
              Container(
                margin: EdgeInsets.only(
                  left: 40,
                  right: 40,
                  bottom: 67,
                ),
                child: MaterialButton(
                  color: Color(0xff5268B5).withOpacity(0.30),
                  height: 48,
                  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {},
                  child: Text(
                    "Hantar",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // //======================================== Button
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 67, top: 50.h),
      //   child: MaterialButton(
      //     color: Color(0xff5268B5).withOpacity(0.30),
      //     height: 48.h,
      //     minWidth: MediaQuery.of(context).size.width.w,
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(8.r)),
      //     onPressed: () {},
      //     child: Text(
      //       "Hantar",
      //       style: GoogleFonts.poppins(
      //         fontSize: 16,
      //         fontWeight: FontWeight.w300,
      //         color: Color(0xFFFFFFFF),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
