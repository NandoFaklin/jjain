// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jhein_beta/BaseUrl/Api.dart';
import 'package:jhein_beta/UI/Loading%20Shimmer/Loading%20Shimmer.dart';
import 'package:jhein_beta/UI/MainHome/Home/Waktu%20Sholat.dart';
import 'package:jhein_beta/model/Model%20Berita.dart';
import '../../../model/Model Masjid.dart';
import '../../../model/Model fotoMasjid.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late HijriCalendar _hijriCalendar;
  late List<Map<String, dynamic>> _waktuSholat;
  late Timer _timer;
  late PageController _pageController;
  int _activePrayerIndex = 0;
  late Future<List<Masjid>> futureMasjid;
  late Future<List<FotoMasjid>> futureFotoMasjid;
  late Future<List<dynamic>> _futureData;
  late StreamSubscription<Position> positionStream;
  late Position _currentLocation;
  bool servicePermission = false;
  late LocationPermission permission;
  String _currentAddress = "";
  late TabController _tabController;

  // ! ========================== dispose

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose(); // Hentikan controller
    positionStream.cancel(); // Hentikan stream
    super.dispose();
    _tabController.dispose();
  }

  // ! ========================== IniState

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Update UI when tab is changed
    });
    _waktuSholat = [];
    _hijriCalendar = HijriCalendar.now();
    _pageController = PageController(
      initialPage: _waktuSholat.length ~/ 2,
      viewportFraction: 0.7,
    );

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _hijriCalendar = HijriCalendar.now();
      });
      if (mounted) {
        _fetchWaktuSholat(
            _currentLocation.latitude, _currentLocation.longitude);
      }
    });

    initializeDateFormatting('ms_My', null);

    futureMasjid = fetchMasjid();
    futureFotoMasjid = fetchFotoMasjid();
    _futureData = Future.wait([futureMasjid, futureFotoMasjid]);

    if (mounted) {
      _getLocation();
      _listenToLocationChanges();
      _monitorLocationServiceStatus();
    }

    _fetchDataFuture = fetchBeritaData();
  }

  //!===================================== Geolocator

  void _listenToLocationChanges() {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = position;
      });
      _getAddressCoordinates();
      _fetchWaktuSholat(position.latitude, position.longitude);
    });
  }

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      Fluttertoast.showToast(
        msg: "Layanan lokasi tidak aktif.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
          msg: "Izin lokasi ditolak.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: "Izin lokasi ditolak secara permanen.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _getLocation() async {
    try {
      Position position = await _getCurrentLocation();
      setState(() {
        _currentLocation = position;
      });
      await _getAddressCoordinates();
      _fetchWaktuSholat(position.latitude, position.longitude);
      print("$_currentLocation");
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAddressCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation.latitude, _currentLocation.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = "${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // ! ============================ Update Prayer

  void _updateActivePrayerIndex() {
    final now = DateTime.now();
    int activeIndex = -1;

    for (int i = 0; i < _waktuSholat.length; i++) {
      final prayerDate = DateFormat.Hm().parse(_waktuSholat[i]['date']);

      if (now.isBefore(prayerDate) || now.isAtSameMomentAs(prayerDate)) {
        activeIndex = i;
        break;
      }
    }

    if (activeIndex != -1 && mounted) {
      setState(() {
        _activePrayerIndex = activeIndex;
      });
    }
  }

// ! =============================== Read waktu sholat
  void _fetchWaktuSholat(double latitude, double longitude) async {
    final url = 'https://api.waktusolat.app/v2/solat/gps/$latitude/$longitude';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> prayers = data['prayers'];
        final todayPrayer = prayers.firstWhere(
              (prayer) => prayer['day'] == DateTime.now().day,
          orElse: () => null,
        );
        if (todayPrayer != null && mounted) {
          setState(() {
            _waktuSholat = [
              {
                "title": "Subuh",
                "subtitle": "Solat fardu",
                "date": _convertEpochToTime(todayPrayer['fajr']),
                "gambar": "Dzuhur Subuh dsb.png",
              },
              {
                "title": "Zohor",
                "subtitle": "Solat fardu",
                "date": _convertEpochToTime(todayPrayer['dhuhr']),
                "gambar": "Dzuhur Subuh dsb.png",
              },
              {
                "title": "Ashar",
                "subtitle": "Solat fardu",
                "date": _convertEpochToTime(todayPrayer['asr']),
                "gambar": "Dzuhur Subuh dsb.png",
              },
              {
                "title": "Maghrib",
                "subtitle": "Solat fardu",
                "date": _convertEpochToTime(todayPrayer['maghrib']),
                "gambar": "Maghrib Isya.png",
              },
              {
                "title": "Isya",
                "subtitle": "Solat fardu",
                "date": _convertEpochToTime(todayPrayer['isha']),
                "gambar": "Maghrib Isya.png",
              },
            ];
          });
        } else {
          print('Data waktu sholat tidak tersedia untuk hari ini');
        }
      } else {
        //! === Menyesuaikan tampilan teks jika di luar Malaysia
        _currentAddress.contains('Malaysia')
            ? print('Failed to fetch waktu sholat')
            : print('Anda Berada di Luar Negara Malaysia');
      }
    } catch (e) {
      print('Error fetching waktu sholat: $e');
    }
  }

// ! ========================== Epoch Time waktu sholat
  String _convertEpochToTime(int epoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    return DateFormat('hh:mm a')
        .format(dateTime); // Mengubah format waktu menjadi hh:mm AM/PM
  }

// ! ========================== Check Status Location on/of
  void _monitorLocationServiceStatus() {
    Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        Fluttertoast.showToast(
          msg:
          "Layanan lokasi dinonaktifkan. Harap aktifkan untuk melanjutkan.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  // ! Fungsi untuk mendapatkan tanggal Hijriah Malaysia
  String _getHijriDate() {
    int hijriDay = _hijriCalendar.hDay;
    String hijriMonth = bulanHijriyah[_hijriCalendar.hMonth - 1];
    int hijriYear = _hijriCalendar.hYear;

    return '$hijriDay $hijriMonth $hijriYear';
  }

  // ! ============================================================ Masjid
  Future<List<Masjid>> fetchMasjid() async {
    final response = await http.get(Uri.parse(Api.Masjid));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Masjid.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ! =============================== FOTO Masjid

  Future<List<FotoMasjid>> fetchFotoMasjid() async {
    final response = await http.get(Uri.parse(Api.fotoMasjid));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['foto'];
      return data.map((json) => FotoMasjid.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 269,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xff293882),
                image: DecorationImage(
                  image: AssetImage("images/bakGround.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 59,
                  ),

                  //============================ Lokasi Waktu Sholat
                  // ! ======== Mengubah Text di bawah menjadi kondisional
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      _currentAddress.contains('Malaysia')
                          ? "Jadual Waktu Solat $_currentAddress"
                          : "Anda berada di luar negara Malaysia",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  // ! ============================ Kondisi W A K T U  S H O L A T
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 103,
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _currentAddress.contains('Malaysia')
                          ? _waktuSholat.length
                          : _jadwalSholat.length,
                      onPageChanged: (int index) {
                        setState(() {
                          _activePrayerIndex =
                              index; // Perbarui indeks waktu sholat aktif
                        });
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _showWaktuSholatModal(context, index);
                          },
                          child:
                          //! === Menyesuaikan tampilan teks jika di luar Malaysia
                          _currentAddress.contains('Malaysia')
                              ? Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: 5),
                            width: 250,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(
                                  "images/${_waktuSholat[index]['gambar']}",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 15, top: 15),
                                      child: Text(
                                        "${_waktuSholat[index]['subtitle']}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffFFFFFF),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: 19, top: 15),
                                      child: Text(
                                        "${_waktuSholat[index]['title']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 17,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 19, bottom: 7),
                                  child: Text(
                                    "${_waktuSholat[index]['date']}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffFFFFFF),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                              : Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: 5),
                            width: 250,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(
                                  "images/${_jadwalSholat[index]['gambar']}",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 15, top: 15),
                                      child: Text(
                                        "${_jadwalSholat[index]['subtitle']}",
                                        style: GoogleFonts.roboto(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffFFFFFF),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: 19, top: 15),
                                      child: Text(
                                        "${_jadwalSholat[index]['title']}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

//============================ L O A D I N G
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 60,
                    height: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        _currentAddress.contains('Malaysia')
                            ? _waktuSholat.length
                            : _jadwalSholat.length,
                            (index) {
                          return Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _activePrayerIndex
                                  ? Color(0xff23792A) // Warna aktif
                                  : Color(0xffDCDCDC), // Warna tidak aktif
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  //============================ D A T E
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //================ Tanggal Biasa
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        width: 128,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Color(0xff0F1856),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('dd MMMM yyyy', 'ms_MY')
                                .format(DateTime.now()),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                        ),
                      ),

                      //================ Tanggal hijriyah
                      Container(
                        margin: EdgeInsets.only(right: 20, top: 3),
                        child: FutureBuilder<String?>(
                          future: Future.value(
                              _getHijriDate()), // Panggil fungsi untuk mendapatkan tanggal Hijriah
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String? hijriDate = snapshot.data;
                              return Text(
                                hijriDate ??
                                    "", // Format tanggal Hijriah Malaysia
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffFFFFFF),
                                ),
                              );
                            } else {
                              return Text(
                                "Loading...",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff313131),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(right: 20, top: 4),
                      //   child: Text(
                      //     "${_hijriCalendar.hDay} ${_getHijriMonthName(_hijriCalendar.hMonth)} ${_hijriCalendar.hYear}",
                      //     style: GoogleFonts.poppins(
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.w500,
                      //       color: Color(0xffFFFFFF),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            //=============================== MENU

            SizedBox(
              height: 32,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 106,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //=========================  DERMA
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(PageRouteBuilder(
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) {
                          //       return FadeTransition(
                          //         opacity: animation,
                          //         child: InfaqSumbanganPage(),
                          //       );
                          //     }));
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFFFFF),
                            border: Border.all(
                              width: 1,
                              color: Color(0xffDFE5EE),
                            ),
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset("images/vector infaq.png"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 79,
                        child: Text(
                          "Derma",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff474747),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //============================ MISI SUMBANGAN
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffFFFFFF),
                          border: Border.all(
                            width: 1,
                            color: Color(0xffDFE5EE),
                          ),
                        ),
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                            Image.asset("images/Vector Misi Sumbangan.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 79,
                        child: Text(
                          "Misi \nSumbangan",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff474747),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //=========================== Informasi Aktiviti
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(PageRouteBuilder(
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) {
                          //       return FadeTransition(
                          //         opacity: animation,
                          //         child: PerkhidmatanPage(),
                          //       );
                          //     }));
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFFFFF),
                            border: Border.all(
                              width: 1,
                              color: Color(0xffDFE5EE),
                            ),
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset("images/vector informasi.png"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 79,
                        child: Text(
                          "Informasi \nAktiviti",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff474747),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //=========================== Info Masjid
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(PageRouteBuilder(
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) {
                          //       return FadeTransition(
                          //         opacity: animation,
                          //         child: InfoMasjidPage(),
                          //       );
                          //     }));
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFFFFF),
                            border: Border.all(
                              width: 1,
                              color: Color(0xffDFE5EE),
                            ),
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset("images/vector masjid1.png"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 79,
                        child: Text(
                          "Info \nMasjid",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff474747),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //======================= MENU 2
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 106,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //=========================  ARAH KIBLAT
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(PageRouteBuilder(
                          //   pageBuilder:
                          //       (context, animation, secondaryAnimation) {
                          //     return FadeTransition(
                          //       opacity: animation,
                          //       child: CompasPage(),
                          //     );
                          //   },
                          // ));
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFFFFF),
                            border: Border.all(
                              width: 1,
                              color: Color(0xffDFE5EE),
                            ),
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset("images/Vector Kabbah.png"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 79,
                        child: Text(
                          "Arah Kiblat",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff474747),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //============================  Doa dan Dzikir
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffFFFFFF),
                          border: Border.all(
                            width: 1,
                            color: Color(0xffDFE5EE),
                          ),
                        ),
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                            Image.asset("images/Vector Doa dan Dzikir.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 79,
                        child: Text(
                          "Doa & \nZikir",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff474747),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //=========================== Media Islam
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffFFFFFF),
                          border: Border.all(
                            width: 1,
                            color: Color(0xffDFE5EE),
                          ),
                        ),
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset("images/Vector Media Islam.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 79,
                        child: Text(
                          "Media \nIslam",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff474747),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //=========================== L I H A T S E M U A
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(PageRouteBuilder(
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) {
                          //       return FadeTransition(
                          //         opacity: animation,
                          //         child: LainnyaPage(),
                          //       );
                          //     }));
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffFFFFFF),
                            border: Border.all(
                              width: 1,
                              color: Color(0xffDFE5EE),
                            ),
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child:
                              Image.asset("images/vector lihat semua.png"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 79,
                        child: Text(
                          "Lihat Semua",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff474747),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //============================ M E S J I D - T E R D E K A T
            SizedBox(
              height: 26,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Masjid Terdekat",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1D1D1D),
                    ),
                  ),

                  //==================================== M A S J I D - S U L T A N - I S K A N D A R
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 368,
                    child: FutureBuilder(
                      future: _futureData,
                      builder:
                          (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Menampilkan Shimmer ketika masih menunggu hasil
                          return LoadingShimmer();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError || snapshot.data == null) {
                            // Menampilkan Shimmer ketika terjadi kesalahan atau data null
                            print('Error: ${snapshot.error}');
                            Fluttertoast.showToast(
                              msg: "Tidak dapat terhubung ke server",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color(0xff293882),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return LoadingShimmer();
                          } else {
                            final List<Masjid> masjids = snapshot.data![0];
                            final List<FotoMasjid> fotoMasjids =
                            snapshot.data![1];

                            // Membuat map untuk memetakan id foto ke objek Masjid
                            final Map<int, Masjid> masjidMap = {};
                            for (var masjid in masjids) {
                              masjidMap[masjid.id] = masjid;
                            }

                            // Menggabungkan data foto dan masjid yang sesuai
                            final List<FotoMasjid> combinedData = fotoMasjids
                                .where((fotoMasjid) =>
                            masjidMap
                                .containsKey(fotoMasjid.mesjidId) &&
                                fotoMasjid.kategori == "primary")
                                .toList();

                            // Batasi jumlah data yang ditampilkan menjadi maksimal empat
                            final List<Masjid> limitedMasjids =
                            masjids.take(4).toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: limitedMasjids.length,
                              itemBuilder: (context, index) {
                                final masjid = limitedMasjids[index];
                                final fotoMasjid = fotoMasjids.firstWhere(
                                      (foto) =>
                                  foto.mesjidId == masjid.id &&
                                      foto.kategori == 'primary',
                                  orElse: () => FotoMasjid(
                                    id: 0,
                                    namaFoto: 'Default Foto',
                                    mesjidId: masjid.id,
                                    kategori: 'default',
                                    photo: 'images/placeholder.jpg',
                                  ),
                                );

                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  margin: EdgeInsets.only(bottom: 12),
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xffFFFFFF),
                                    border: Border.all(
                                        width: 1, color: Color(0xffDFE5EE)),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      // Navigator.of(context)
                                      //     .push(PageRouteBuilder(
                                      //   pageBuilder: (context, animation,
                                      //       secondaryAnimation) {
                                      //     return FadeTransition(
                                      //       opacity: animation,
                                      //       child: DetailMasjidPage(
                                      //         masjid: masjid,
                                      //         previousPage: 'HomePage',
                                      //       ),
                                      //     );
                                      //   },
                                      // ));
                                    },
                                    titleAlignment: ListTileTitleAlignment.top,
                                    contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                    leading: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        height: 64,
                                        width: 64,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(6),
                                          image: DecorationImage(
                                            image: fotoMasjid.photo.startsWith(
                                                'images/placeholder.jpg')
                                                ? AssetImage(fotoMasjid.photo)
                                                : NetworkImage(fotoMasjid.photo)
                                            as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      masjid.namaMesjid,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff1D1D1D),
                                      ),
                                    ),
                                    subtitle: Text(
                                      masjid.address,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff4C4C4C),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: 50,
                                      height: 15,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: Image.asset(
                                                "images/placeholder red.png"),
                                          ),
                                          Text(
                                            "1.2 km ",
                                            style: GoogleFonts.poppins(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff474747),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        } else {
                          // Tampilkan Shimmer ketika future belum selesai
                          return LoadingShimmer();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            //================================ Acara Masjid Terkini
            SizedBox(
              height: 24,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Acara Masjid Terkini",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D1D1D),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            // TODO ========================== TabBar
            SizedBox(
              width: 220,
              height: 30,
              child: TabBar(
                labelColor: Colors.amber,
                dividerColor: Colors.transparent,
                controller: _tabController,
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _tabController.index == 0
                            ? Color(0xff5268B5)
                            : Color(0xffF1F4F8),
                      ),
                      child: Center(
                        child: Text(
                          "Semua",
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _tabController.index == 0
                                ? Color(0xffFFFFFF)
                                : Color(0xff4C4C4C),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _tabController.index == 1
                            ? Color(0xff5268B5)
                            : Color(0xffF1F4F8),
                      ),
                      child: Center(
                        child: Text(
                          "Terdekat",
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _tabController.index == 1
                                ? Color(0xffFFFFFF)
                                : Color(0xff4C4C4C),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 12,
            ),
            //!=============================== Page View TabBar
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab Semua
                      _listMasjidSemua(_fetchDataFuture, futureMasjid),
                      // Tab Terdekat
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              height: 42,
                              width: 42,
                              child:
                              Image.asset("images/mingcute_news-fill.png"),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Tiada notis acara buat masa ini",
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff4C4C4C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //! =============================== Modal Bottom
  void _showWaktuSholatModal(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        if (_currentAddress.contains('Malaysia')) {
          return SizedBox(
            height: 565,
            child: WaktuSholatPage(
              title: _waktuSholat[index]['title'],
              gambar: 'images/${_waktuSholat[index]['gambar']}',
              date: _waktuSholat[index]['date'],
              selectedPrayerIndex: index,
              showWaktuSholatModal:
              _showWaktuSholatModal, // Teruskan fungsi di sini
            ),
          );
        } else {
          return SizedBox(
            height: 565,
            child: WaktuSholatPage(
              title: _jadwalSholat[index]['title'],
              gambar: 'images/${_jadwalSholat[index]['gambar']}',
              date: _jadwalSholat[index]['date'],
              selectedPrayerIndex: index,
              showWaktuSholatModal:
              _showWaktuSholatModal, // Teruskan fungsi di sini
            ),
          );
        }
      },
    );
  }

  final List<String> bulanHijriyah = [
    'Muharram',
    'Safar',
    'Rabiulawal',
    'Rabiulakhir',
    'Jamadilawal',
    'Jamadilakhir',
    'Rejab',
    'Syaaban',
    'Ramadan',
    'Syawal',
    'Zulkaedah',
    'Zulhijjah'
  ];

  final List<Map<String, dynamic>> _jadwalSholat = [
    {
      "title": "Subuh",
      "subtitle": "Solat fardu",
      "gambar": "Dzuhur Subuh dsb.png",
      "date": "00",
    },
    {
      "title": "Zohor",
      "subtitle": "Solat fardu",
      "gambar": "Dzuhur Subuh dsb.png",
      "date": "00",
    },
    {
      "title": "Ashar",
      "subtitle": "Solat fardu",
      "gambar": "Dzuhur Subuh dsb.png",
      "date": "00",
    },
    {
      "title": "Maghrib",
      "subtitle": "Solat fardu",
      "gambar": "Maghrib Isya.png",
      "date": "00",
    },
    {
      "title": "Isya",
      "subtitle": "Solat fardu",
      "gambar": "Maghrib Isya.png",
      "date": "00",
    },
  ];
}

//!======================================== Function Berita
late Future<List<Berita>> _fetchDataFuture;
Future<List<Berita>> fetchBeritaData() async {
  final response = await http.get(Uri.parse(Api.berita));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> beritaJsonList = data['data']['berita'];
    return beritaJsonList.map((json) => Berita.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

Widget _listMasjidSemua(Future<List<Berita>> beritaListFuture,
    Future<List<Masjid>> masjidListFuture) {
  return FutureBuilder<List<Berita>>(
    future: beritaListFuture,
    builder: (context, beritaSnapshot) {
      if (beritaSnapshot.connectionState == ConnectionState.waiting) {
        return Center(
            child: SpinKitFadingCircle(
              color: Color(0xFF5268B5),
            ));
      } else if (beritaSnapshot.hasError) {
        print('Error fetching berita data: ${beritaSnapshot.error}');
        return LoadingBerita();
      } else {
        return FutureBuilder<List<Masjid>>(
          future: masjidListFuture,
          builder: (context, masjidSnapshot) {
            if (masjidSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: SpinKitFadingCircle(
                    color: Color(0xFF5268B5),
                  ));
            } else if (masjidSnapshot.hasError) {
              print('Error fetching masjid data: ${masjidSnapshot.error}');
              return Text('Failed to load masjid data');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: beritaSnapshot.data!.length,
                itemBuilder: (context, index) {
                  final berita = beritaSnapshot.data![index];
                  final namaMesjid =
                  _getNamaMesjid(berita.mesjidId, masjidSnapshot.data!);
                  final masjid = masjidSnapshot.data!
                      .firstWhere((masjid) => masjid.id == berita.mesjidId);
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffFFFFFF),
                        border: Border.all(
                          width: 1,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            berita.tajuk != null
                                ? berita.tajuk!
                                : 'data tidak tersedia',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1D1D1D),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            namaMesjid,
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff1D1D1D),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      height: 20,
                                      width: 20,
                                      child:
                                      Image.asset("images/Calendar.png")),
                                  SizedBox(width: 6),
                                  Text(
                                    berita.tanggal != null
                                        ? DateFormat('yyyy-MM-dd')
                                        .format(berita.tanggal!)
                                        : '--:--:--',
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff4C4C4C),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                          "images/Time Circle.png")),
                                  SizedBox(width: 6),
                                  Text(
                                    berita.acaraAwal ?? '--:--',
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff4C4C4C),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.of(context).push(PageRouteBuilder(
                                  //   pageBuilder: (context, animation,
                                  //       secondaryAnimation) {
                                  //     return FadeTransition(
                                  //       opacity: animation,
                                  //       child: ButiranAktivitiPage(
                                  //           masjid: masjid, berita: berita),
                                  //     );
                                  //   },
                                  // ));
                                },
                                child: Container(
                                  width: 70,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xffF1F4F8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Info",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff5268B5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      }
    },
  );
}

// Fungsi untuk mendapatkan nama masjid berdasarkan id
String _getNamaMesjid(int mesjidId, List<Masjid> masjidList) {
  final masjid = masjidList.firstWhere(
        (masjid) => masjid.id == mesjidId,
  );
  return masjid.namaMesjid;
}
