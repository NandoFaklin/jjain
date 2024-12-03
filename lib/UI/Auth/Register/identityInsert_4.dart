// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jhein_beta/UI/Auth/Register/AccountCreated_6.dart';
import 'package:jhein_beta/UI/Auth/Register/identitySucces_5.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class IdentityInsertScreen extends StatefulWidget {
  const IdentityInsertScreen({super.key});

  @override
  _IdentityInsertScreenState createState() => _IdentityInsertScreenState();
}

class _IdentityInsertScreenState extends State<IdentityInsertScreen> {
  final logger = Logger();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController daerahController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  String? _selectedGender;
  Color selectedBorderColor = Colors.transparent;
  bool isPhoneNumberValid = false;
  PhoneNumber number = PhoneNumber(isoCode: 'ID');

  final _keyForm = GlobalKey<FormState>();

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    cardController.clear();
    daerahController.clear();
    alamatController.clear();
    setState(() {
      _selectedGender = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Padding(
        padding: EdgeInsets.only(left: 17, right: 27),
        child: SingleChildScrollView(
          child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //================================================== Icon , Text
                ListTile(
                  horizontalTitleGap: 12,
                  contentPadding: EdgeInsets.only(top: 53),
                  leading: InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(pageBuilder:
                          (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: IdentityScreen(),
                        );
                      }));
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
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    return value!.isEmpty ? 'tidak boleh kosong' : null;
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
                    hintText: 'Name',
                    // hintText: 'Jamal Abdulllah',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF474747),
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
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    return value!.isEmpty ? 'tidak boleh kosong' : null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 15,
                      height: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset("images/email.png"),
                      ),
                    ),
                    // hintText: 'Jamalabdullah123@gmail.com',
                    hintText: 'Emel',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF474747),
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
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    setState(() {
                      isPhoneNumberValid = value;
                    });
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    leadingPadding: 0,
                    setSelectorButtonAsPrefixIcon: false,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  initialValue: number,
                  textFieldController: phoneController,
                  formatInput: true,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputDecoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 15,
                      height: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset("images/phone.png"),
                      ),
                    ),
                    hintText: 'Number Phone',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF474747),
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
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid phone number';
                    }
                    return null; // Validasi berhasil
                  },
                  inputBorder: OutlineInputBorder(),
                ),

                SizedBox(height: 17),

                //================================================== Card
                TextFormField(
                  controller: cardController,
                  validator: (value) {
                    return value!.isEmpty ? 'tidak boleh kosong' : null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 15,
                      height: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset("images/card.png"),
                      ),
                    ),
                    // hintText: '12371040181',
                    hintText: 'Card',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF474747),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 18),
                      height: 50,
                      width: 146,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: _selectedGender == 'Lelaki'
                              ? Color(0xff5268B5)
                              : Colors.transparent,
                        ),
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
                                // Set border color
                                selectedBorderColor = Color(0xff5268B5);
                              });
                            },
                          ),
                          SizedBox(
                            child: Image.asset(
                              "images/lelaki.png",
                              width: 16,
                              height: 16,
                            ),
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
                    Container(
                      padding: EdgeInsets.only(right: 18),
                      height: 50,
                      width: 146,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: _selectedGender == 'Wanita'
                              ? Color(0xff5268B5)
                              : Colors.transparent,
                        ), // Gunakan selectedBorderColor di sini
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
                                // Atur selectedBorderColor di sini
                                selectedBorderColor = Color(0xff5268B5);
                              });
                            },
                          ),
                          SizedBox(
                            child: Image.asset(
                              "images/wanita.png",
                              width: 16,
                              height: 16,
                            ),
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
                  ],
                ),
                SizedBox(
                  height: 16,
                ),

                //================================================== Negara
                TextFormField(
                  controller: daerahController,
                  validator: (value) {
                    return value!.isEmpty ? 'tidak boleh kosong' : null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 15,
                      height: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset("images/real estate.png"),
                      ),
                    ),
                    // hintText: 'Distrik Johor Bahru, Johor, Malaysia',
                    hintText: 'Daerah',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF474747),
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
                TextFormField(
                  controller: alamatController,
                  validator: (value) {
                    return value!.isEmpty ? 'tidak boleh kosong' : null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      width: 15,
                      height: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset("images/address.png"),
                      ),
                    ),
                    // hintText: "Jalan Dato' Onn 2, Bandar Dato Onn",
                    hintText: 'Alamat',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF474747),
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
                    Container(
                      padding: EdgeInsets.only(
                        left: 40,
                        right: 40,
                        bottom: 67,
                      ),
                      child: MaterialButton(
                        color: Color(0xff5268B5),
                        height: 48,
                        minWidth: MediaQuery.of(context).size.width,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: AccountCreatedScreen(),
                            );
                          }));
                        },
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cardController.dispose();
    daerahController.dispose();
    alamatController.dispose();
    super.dispose();
  }
}

