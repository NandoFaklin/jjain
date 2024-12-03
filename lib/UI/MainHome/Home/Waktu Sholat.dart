// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class WaktuSholatPage extends StatefulWidget {
  const WaktuSholatPage(
      {super.key,
      required this.title,
      required this.gambar,
      required this.date,
      required this.selectedPrayerIndex,
      required this.showWaktuSholatModal});

  final String title;
  final String gambar;
  final String date;
  final int selectedPrayerIndex;
  final Function(BuildContext, int) showWaktuSholatModal;

  @override
  State<WaktuSholatPage> createState() => _WaktuSholatPageState();
}

class _WaktuSholatPageState extends State<WaktuSholatPage> {
  late HijriCalendar _hijriCalendar;
  late List<Map<String, dynamic>> _waktuSholat = [];
  String _currentAddress = "";
  late Position _currentLocation;

  late Timer _timer;

  // TODO ====================== Tambahan tgl 23
  late int _selectedDayIndex;
  late PageController _pageController;

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

  @override
  void initState() {
    super.initState();

    // TODO ====================== Tambahan tgl 23
    _selectedDayIndex = 0;
    _pageController = PageController(
      initialPage: _selectedDayIndex,
      viewportFraction: 0.25,
    );
    _startTimer();
    _hijriCalendar = HijriCalendar.now();
    _initializeLocationAndFetchWaktuSholat();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _updateWaktuSholat();
      });
    });

    initializeDateFormatting('ms_My', null);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Hentikan timer di sini
    super.dispose();
  }

  // TODO ====================== Tambahan tgl 23
  void _startTimer() {
    _timer = Timer.periodic(Duration(days: 1), (timer) {
      setState(() {
        _selectedDayIndex = DateTime.now().weekday - 1;
      });
    });
  }

  bool _isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  // TODO ====================== Tambahan tgl 23
  List<DateTime> _getDaysInWeek(DateTime date) {
    final List<DateTime> days = [];
    final DateTime firstDayOfWeek = DateTime(date.year, date.month, date.day);
    for (int i = 0; i < 7; i++) {
      days.add(firstDayOfWeek.add(Duration(days: i)));
    }
    return days;
  }

  Future<void> _initializeLocationAndFetchWaktuSholat() async {
    try {
      _currentLocation = await _getCurrentLocation();
      await _getAddressCoordinates(); // Set _currentAddress here
      _fetchWaktuSholat(); // Fetch waktu sholat data
    } catch (e) {
      print('Error initializing location: $e');
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

  // Mendapatkan lokasi pengguna
  Future<Position> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      throw Exception('Error getting current location');
    }
  }

  String getSubtitle(DateTime prayerTime) {
    // Cek apakah pengguna berada di luar Malaysia
    if (!_currentAddress.contains('Malaysia')) {
      // Jika ya, kembalikan pesan yang sesuai untuk menghentikan penghitungan waktu sholat
      return 'Adzan tidak tersedia di luar Malaysia';
    } else {
      // Jika tidak, lanjutkan perhitungan waktu sholat seperti biasa
      DateTime now = DateTime.now(); 
      if (now.isAfter(prayerTime)) {
        return 'Sudah Berlalu';
      } else {
        Duration difference = prayerTime.difference(now);
        String hours = difference.inHours.toString().padLeft(2, '0');
        String minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
        String seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

        // Tambahkan logika untuk menampilkan pesan "Belum masuk waktu sholat" jika dipilih tanggal besok
        if (prayerTime.day != now.day) { // TODO ====================== Tambahan tgl 23
          return 'Belum masuk waktu sholat';
        } else {
          return 'Azan dalam masa : $hours:$minutes:$seconds';
        }
      }
    }
  }

// Memperbarui _waktuSholat dengan deskripsi subtitle
  // Fetch waktu sholat
  // Memperbarui _updateWaktuSholat() untuk menampilkan pesan dan gambar yang sesuai jika pengguna berada di luar Malaysia
  void _updateWaktuSholat() async {
    try {
      Position position = await _getCurrentLocation();

      final response = await http.get(Uri.parse(
          'https://api.waktusolat.app/v2/solat/gps/${position.latitude}/${position.longitude}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> prayers = data['prayers'];

        final todayPrayer = prayers.firstWhere(
          (prayer) => prayer['day'] == DateTime.now().day,
          orElse: () => null,
        );

        if (todayPrayer != null) {
          DateTime fajrTime = _parseTime(todayPrayer['fajr']);
          DateTime dhuhrTime = _parseTime(todayPrayer['dhuhr']);
          DateTime asrTime = _parseTime(todayPrayer['asr']);
          DateTime maghribTime = _parseTime(todayPrayer['maghrib']);
          DateTime ishaTime = _parseTime(todayPrayer['isha']);

          if (mounted) {
            setState(() {
              _selectedDayIndex = _selectedDayIndex; // TODO ====================== Tambahan tgl 23
              _waktuSholat = [
                {
                  "title": "Subuh",
                  "subtitle": getSubtitle(fajrTime),
                  "date": _convertEpochToTime(todayPrayer['fajr']),
                  "gambar": "subuh.png", // pastikan gambar tersedia
                },
                {
                  "title": "Zohor",
                  "subtitle": getSubtitle(dhuhrTime),
                  "date": _convertEpochToTime(todayPrayer['dhuhr']),
                  "gambar": "zohor.png",
                },
                {
                  "title": "Ashar",
                  "subtitle": getSubtitle(asrTime),
                  "date": _convertEpochToTime(todayPrayer['asr']),
                  "gambar": "ashar.png",
                },
                {
                  "title": "Maghrib",
                  "subtitle": getSubtitle(maghribTime),
                  "date": _convertEpochToTime(todayPrayer['maghrib']),
                  "gambar": "maghrib.png",
                },
                {
                  "title": "Isya",
                  "subtitle": getSubtitle(ishaTime),
                  "date": _convertEpochToTime(todayPrayer['isha']),
                  "gambar": "isya.png",
                },
              ];
            });
          }
        } else {
          _handleLocationOutsideMalaysia();
        }
      } else {
        _handleLocationOutsideMalaysia();
      }
    } catch (e) {
      print('Error fetching waktu sholat: $e');
    }
  }

  void _handleLocationOutsideMalaysia() {
    if (mounted) {
      setState(() {
        _waktuSholat = [];
        _waktuSholat.add({
          "title":
              "Anda mungkin berada di luar negara Malaysia atau semak semula fungsi lokasi/GPS peranti anda",
          "subtitle": "",
          "date": "",
          "gambar": "error.png", // gunakan gambar error jika diperlukan
        });
      });
    }
  }

  DateTime _parseTime(int epoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    return dateTime;
  }

// Memperbarui _fetchWaktuSholat() untuk menampilkan pesan dan gambar yang sesuai jika pengguna berada di luar Malaysia
  void _fetchWaktuSholat() async {
    Position position = await _getCurrentLocation();
    try {
      final response = await http.get(Uri.parse(
          'https://api.waktusolat.app/v2/solat/gps/${position.latitude}/${position.longitude}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> prayers = data['prayers'];

        final todayPrayer = prayers.firstWhere(
          (prayer) => prayer['day'] == DateTime.now().day,
          orElse: () => null,
        );

        if (todayPrayer != null) {
          _updateWaktuSholat();
        } else {
          // Tampilkan pesan dan gambar yang sesuai jika pengguna berada di luar Malaysia
          if (mounted) {
            setState(() {
              _waktuSholat = [];
              _waktuSholat.add({
                "title":
                    "Anda mungkin berada di luar negara Malaysia atau semak semula fungsi lokasi/GPS peranti anda",
                "subtitle": "",
                "date": "",
              });
            });
          }
        }
      } else {
        _currentAddress.contains('Malaysia')
            ? print('Failed to fetch waktu sholat')
            : print('Anda Berada di Luar Negara Malaysia');
      }
    } catch (e) {
      print('Error fetching waktu sholat: $e');
    }
  }

  // Mengubah epoch time ke format hh:mm a
  String _convertEpochToTime(int epoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    return DateFormat('hh:mm a')
        .format(dateTime); // Mengubah format waktu menjadi hh:mm AM/PM
  }

  // Ubah format tanggal ke dalam bahasa Malaysia
  String _getHijriDate() {
    int hijriDay = _hijriCalendar.hDay;
    String hijriMonth = bulanHijriyah[_hijriCalendar.hMonth - 1];
    int hijriYear = _hijriCalendar.hYear;

    return '$hijriDay $hijriMonth $hijriYear';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _currentAddress.contains('Malaysia')
            ? Material(
                borderOnForeground: false,
                elevation: 0,
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.gambar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 85,
                            height: 32,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff002281).withOpacity(0.5),
                            ),
                            child: Text(
                              "00:${widget.date}",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
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
              )
            : Material(
                borderOnForeground: false,
                elevation: 0,
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SizedBox(
                  height: 140,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.gambar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

        //==================================== DATE - WAKTU SHOLAT
        _currentAddress.contains('Malaysia')
            ? Expanded(
                child: Container(
                  color: Color(0xffFFFFFF),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 24, top: 12),
                        child: FutureBuilder<String?>(
                          future: Future.value(_getHijriDate()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              String? hijriDate = snapshot.data;
                              return Text(
                                hijriDate ?? "",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff313131),
                                ),
                              );
                            } else {
                              return Text(
                                "Loading...",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff313131),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 5),

                      //=================================== Tanggal biasa
                      Container(
                        margin: EdgeInsets.only(left: 24),
                        child: Text(
                          DateFormat("EEEE, dd MMMM yyyy", 'ms_MY')
                              .format(DateTime.now()),
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4C4C4C),
                          ),
                        ),
                      ),

                      // !=================================== DAYS  
                      SizedBox(height: 9),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            DateTime date =
                                DateTime.now().add(Duration(days: index));
                            String dayAbbreviation =
                                getDayAbbreviation(date.weekday);
                            bool isToday =
                                DateTime.now().weekday == date.weekday;

                            return GestureDetector(
                              // onTap: () {
                              //   setState(() {
                              //     _selectedDayIndex = index;
                              //     _updateWaktuSholat(); // TODO ====================== Tambahan tgl 23
                              //   });
                              // },
                              child: Container(
                                width: 60,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dayAbbreviation,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff4C4C4C),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isToday
                                            ? Color(0xffDFE8FB)
                                            : Color(0xffFFFFFF),
                                        border: _selectedDayIndex == index
                                            ? Border.all(
                                                color: Color(0xff002281))
                                            : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${date.day}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: isToday
                                                ? Color(0xff002281)
                                                : Color(0xff4C4C4C),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _isLeapYear(DateTime.now().year) ? 53 : 52,
                          itemBuilder: (context, index) {
                            DateTime startDate =
                                DateTime(DateTime.now().year, 1, 1);
                            startDate =
                                startDate.add(Duration(days: index * 7));
                            final daysInWeek = _getDaysInWeek(startDate);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: daysInWeek.map((day) {
                                bool isToday = DateTime.now().day == day.day;
                                String dayAbbreviation = getDayAbbreviation(day
                                    .weekday); // Panggil fungsi getDayAbbreviation
                                return GestureDetector(
                                  // onTap: () {
                                  //   setState(() {
                                  //     _updateWaktuSholat(); // TODO ====================== Tambahan tgl 23
                                  //     _selectedDayIndex =
                                  //         daysInWeek.indexOf(day);
                                  //   });
                                  // },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: _selectedDayIndex ==
                                              daysInWeek.indexOf(day)
                                          ? Colors.blue
                                          : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dayAbbreviation,
                                          style: TextStyle(
                                              color:
                                                  isToday ? Colors.blue : null),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "${day.day}",
                                          style: TextStyle(
                                              color:
                                                  isToday ? Colors.blue : null),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 12),
                      Divider(
                        thickness: 1,
                        height: 1,
                      ),

                      //===================================== List Sholat
                      SizedBox(
                        height: 269,
                        child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _waktuSholat.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              thickness: 1,
                              height: 1,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> prayer = _waktuSholat[index];
                            String title = prayer['title'];
                            String subtitle = prayer['subtitle'];
                            String formattedDate = prayer[
                                'date']; // Di sini, date seharusnya sudah berupa String

                            bool isSelected =
                                index == widget.selectedPrayerIndex;

                            return Material(
                              child: Container(
                                color: isSelected ? Color(0xffDFE8FB) : null,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 7),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: GoogleFonts.roboto(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff313131),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          subtitle,
                                          style: GoogleFonts.roboto(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff4C4C4C),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      formattedDate, // Menggunakan Text widget untuk menampilkan teks
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff313131),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: Container(
                  color: Color(0xffFFFFFF),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 158,
                          width: 158,
                          child: Image.asset("images/JHEIN Logo 1.png")),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        "Fungsi Waktu Solat gagal",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1D1D1D),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      SizedBox(
                        width: 236,
                        child: Text(
                          "Anda mungkin berada di luar negara Malaysia atau semak semula fungsi lokasi/GPS peranti anda",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4C4C4C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  // Fungsi untuk mengonversi angka menjadi singkatan hari
  String getDayAbbreviation(int day) {
    switch (day) {
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      case 7:
        return 'S';
      default:
        return '';
    }
  }
}
