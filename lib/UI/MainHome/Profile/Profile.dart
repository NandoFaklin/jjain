import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jhein_beta/UI/SplashScreen/Welcome/WelcomeScreen.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/Model User Profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile?> _userProfileFuture;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _userProfileFuture = fetchUserProfile();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data dari SharedPreferences
    // Navigator.of(context).pushAndRemoveUntil(
    //   PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
    //   ),
    //       (Route<dynamic> route) =>
    //   false, // Menghapus semua rute lain dari tumpukan rute
    // );
  }

  void _showLoginDialog() {
    // ! == Jika ada dialog yang terbuka, tidak menampilkan yang baru
    // if (Navigator.canPop(context)) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Required'),
        content: Text(
          'Sila Log Masuk terlebih dahulu....',
          maxLines: 2,
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xff1D1D1D),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Container(
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xffF1F4F8),
              ),
              child: Center(
                child: Text(
                  'Batal',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffD1331B),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => WelcomePage()),
                    (Route<dynamic> route) => false,
              );
            },
            child: Container(
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff293882),
              ),
              child: Center(
                child: Text(
                  'Log Masuk',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: FutureBuilder<UserProfile?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            logger.e('Error : ${snapshot.error}');
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Tampilkan dialog jika pengguna belum login
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _showLoginDialog());
            return Center(child: Text('Silahkan Login Kembali'));
          } else {
            final user = snapshot.data!.user;
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),

                    //======================= PROFILE
                    Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: user.photo != null && user.photo.isNotEmpty
                                ? NetworkImage(user.photo)
                                : AssetImage("images/placeholder.jpg")
                            as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 9,
                    ),
                    //======================= NAME
                    Text(
                      user.name,
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff1D1D1D),
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    //======================= RM 1.000
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: 123,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffF1F4F8),
                      ),
                      child: Text(
                        "RM 1.000",
                        style: GoogleFonts.roboto(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1D1D1D),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 9,
                    ),
                    //======================= JUMLAH INFAQ
                    Text(
                      "Jumlah Infaq",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1D1D1D),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Column(
                        children: [
                          //===================== UBAH PROFILE
                          ListTile(
                            onTap: () {
                              // Navigator.of(context).pushReplacement(
                              //     PageRouteBuilder(pageBuilder:
                              //         (context, animation, secondaryAnimation) {
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: EditProfilePage(
                              //           name: user.name,
                              //           email: user.email,
                              //           phone: user.phone,
                              //           photo: user.photo,
                              //         ),
                              //       );
                              //     }));
                            },
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20),
                            leading: SizedBox(
                              height: 24,
                              width: 24,
                              child: Image.asset("images/Vector person_3.png"),
                            ),
                            title: Text(
                              "Ubah profil",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff323232),
                              ),
                            ),
                            trailing: SizedBox(
                              height: 24,
                              width: 24,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Color(0xff1D1D1D),
                              ),
                            ),
                          ),

                          //===================== PILIHAN BAHASA
                          ListTile(
                            onTap: () {
                              _showLanguageDialog(context);
                            },
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20),
                            leading: SizedBox(
                              height: 24,
                              width: 24,
                              child: Image.asset("images/Vector language.png"),
                            ),
                            title: Text(
                              "Pilihan Bahasa",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff323232),
                              ),
                            ),
                            trailing: SizedBox(
                              height: 24,
                              width: 24,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Color(0xff1D1D1D),
                              ),
                            ),
                          ),

                          //==================== TERMA & SYARAT
                          ListTile(
                            onTap: () {
                              // Navigator.of(context).pushReplacement(
                              //     PageRouteBuilder(pageBuilder:
                              //         (context, animation, secondaryAnimation) {
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: Terma_SyaratPage(),
                              //       );
                              //     }));
                            },
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20),
                            leading: SizedBox(
                              height: 24,
                              width: 24,
                              child:
                              Image.asset("images/Vector description.png"),
                            ),
                            title: Text(
                              "Terma & Syarat",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff323232),
                              ),
                            ),
                            trailing: SizedBox(
                              height: 24,
                              width: 24,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Color(0xff1D1D1D),
                              ),
                            ),
                          ),

                          //======================= MENGENAI APLIKASI
                          ListTile(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20),
                            leading: SizedBox(
                              height: 24,
                              width: 24,
                              child: Image.asset("images/Vector info.png"),
                            ),
                            title: Text(
                              "Mengenai Aplikasi",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff323232),
                              ),
                            ),
                            trailing: SizedBox(
                              height: 24,
                              width: 24,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Color(0xff1D1D1D),
                              ),
                            ),
                          ),

                          //======================== LOG KELUAR
                          ListTile(
                            onTap: () {
                              _showLogoutDialog(context);
                            },
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 20),
                            leading: SizedBox(
                              height: 23,
                              width: 23,
                              child: Image.asset("images/Vector LogOut.png"),
                            ),
                            title: Text(
                              "Log Keluar",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffD62020),
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {},
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Color(0xff1D1D1D),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 90,
                  right: 113,
                  bottom: 16,
                  child: Container(
                    alignment: Alignment.center,
                    width: 157,
                    height: 20,
                    child: Text(
                      "Version : 1.0",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff323232),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),

      //=================================== B O T T O M - N A V I G A T I O N
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 65,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Color(0xffD9D9D9),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //======================== H O M E
            InkWell(
              onTap: () {
                // Navigator.of(context).pushReplacement(PageRouteBuilder(
                //     pageBuilder: (context, animation, secondaryAnimation) {
                //       return FadeTransition(
                //         opacity: animation,
                //         child: HomePage(),
                //       );
                //     }));
              },
              child: Container(
                width: 80,
                height: 47,
                margin: EdgeInsets.only(
                  left: 20,
                  top: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Image.asset(
                          "images/Vector Laman Utama.png",
                          color: Color(0xff474747),
                        ),
                      ),
                    ),
                    Text(
                      "Laman Utama",
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff474747),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //======================= L O G
            InkWell(
              onTap: () {
                // Navigator.of(context).pushReplacement(PageRouteBuilder(
                //     pageBuilder: (context, animation, secondaryAnimation) {
                //       return FadeTransition(
                //         opacity: animation,
                //         child: LogSelesaiPage(),
                //       );
                //     }));
              },
              child: Container(
                width: 80,
                height: 47,
                margin: EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset("images/Log.png"),
                      ),
                    ),
                    Text(
                      "Log",
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff474747),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //========================== M E S E J
            InkWell(
              onTap: () {
                // Navigator.of(context).pushReplacement(PageRouteBuilder(
                //     pageBuilder: (context, animation, secondaryAnimation) {
                //       return FadeTransition(
                //         opacity: animation,
                //         child: ChatPage(),
                //       );
                //     }));
              },
              child: Container(
                width: 80,
                height: 47,
                margin: EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset("images/Mesej.png"),
                      ),
                    ),
                    Text(
                      "Mesej",
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff474747),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //====================== P R O F I L E
            InkWell(
              onTap: () {},
              child: Container(
                width: 80,
                height: 47,
                margin: EdgeInsets.only(
                  right: 30,
                  top: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset("images/Vector Profile Blue.png"),
                      ),
                    ),
                    Text(
                      "Profile",
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5268B5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Metode untuk menampilkan SimpleDialog dengan pilihan bahasa
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 320,
            height: 392,
            decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //============================ ICON
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20, right: 35),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),

                //============================ PILIH BAHASA
                Text(
                  "Pilih Bahasa",
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1D1D1D),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),

                //============================ MALAYSIA (RUMI)
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 24),
                  leading: SizedBox(
                    height: 24,
                    width: 32,
                    child: Image.asset("images/Bendera Malay.png"),
                  ),
                  title: Text(
                    "Malaysia (Rumi)",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1D1D1D),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),

                //============================ MALAYSIA (JAWI)
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 24),
                  leading: SizedBox(
                    height: 24,
                    width: 32,
                    child: Image.asset("images/Bendera Malay.png"),
                  ),
                  title: Text(
                    "Malaysia (Jawi)",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1D1D1D),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),

                //============================ MALAYSIA (ENGLISH)
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 24),
                  leading: SizedBox(
                    height: 24,
                    width: 32,
                    child: Image.asset("images/Bendera America (US).png"),
                  ),
                  title: Text(
                    "English",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1D1D1D),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Metode untuk menampilkan dialog konfirmasi logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 320,
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 38,
                ),

                //============================ Keluar dari Aplikasi
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Keluar dari Aplikasi?",
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1D1D1D),
                    ),
                  ),
                ),
                SizedBox(
                  height: 58,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //=======================BATAL
                      MaterialButton(
                        minWidth: 100,
                        height: 40,
                        color: Color(0xffE9E9E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog
                        },
                        child: Text(
                          "Batal",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1D1D1D),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      //=======================KELUAR
                      MaterialButton(
                        minWidth: 100,
                        height: 40,
                        color: Color(0xffFF0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: () {
                          // Tambahkan logika logout di sini
                          logout(context);
                        },
                        child: Text(
                          "Keluar",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
