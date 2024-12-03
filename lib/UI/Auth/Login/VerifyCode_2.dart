import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/Auth/Login/VerifySucces_3.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class VerifCodeLogin extends StatelessWidget {
  const VerifCodeLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //===================================================== Icon, Text
            ListTile(
              horizontalTitleGap: 12,
              contentPadding: const EdgeInsets.only(top: 53, left: 20),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  height: 18.67,
                  width: 18.67,
                  child: Icon(Icons.arrow_back),
                ),
              ),
              title: Text(
                "Isi kod pengesahan anda",
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
                "Kod pengesahan anda telah dihantar. \nSemak mesej anda & masukkan kod \nanda dibawah",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF474747),
                ),
              ),
            ),
            const SizedBox(height: 32),

            //===================================================== Box Number
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 50,
                  style: const TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  obscureText: false,
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                    borderColor: Colors.grey,
                    enabledBorderColor: Colors.grey,
                    focusBorderColor: const Color(0xFF5268B5),
                  ),
                  onChanged: (pin) {
                    print("Changed: $pin");
                  },
                  onCompleted: (pin) {
                    print("Completed: $pin");
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            //===================================================== Text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Belum terima kod?",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1D1D1D),
                    ),
                  ),
                  const SizedBox(width: 3),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Ulang kiriman (01.00)",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF5268B5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      //=================================================== Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 67),
        child: MaterialButton(
          height: 48,
          minWidth: 280,
          color: const Color(0xff5268B5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VerifSuccessLogin(password: '1234'.toString(),),));
          },
          child: Text(
            "Sahkan Pendaftaran Anda",
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
