// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:jhein_beta/BaseUrl/Api.dart';
import 'package:jhein_beta/UI/MainHome/Log/Filter%20Log.dart';
import 'package:shimmer/shimmer.dart';
import '../../../model/Model Berita.dart';

class LogSelesaiPage extends StatefulWidget {
  const LogSelesaiPage({super.key});

  @override
  State<LogSelesaiPage> createState() => _LogSelesaiPageState();
}

class _LogSelesaiPageState extends State<LogSelesaiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Berita>> beritaListFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    beritaListFuture = _fetchBerita();
    initializeDateFormatting('ms_My', null);
  }

  void _filterLogPage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: FilterLogPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 27),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "Acara",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1D1D),
                ),
              ),
            ),
            SizedBox(height: 18),

            //!========================== Tab Bar
            Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Color(0xFF5268B5),
                    labelColor: Color(0xFF5268B5),
                    unselectedLabelColor: Color(0xFF777777),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(
                        child: Center(
                          child: Text(
                            "Arkib",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Center(
                          child: Text(
                            "Akan Datang",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _filterLogPage(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: 48,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: AssetImage("images/Vector Filter.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height,
            //   child: TabBarView(
            //     controller: _tabController,
            //     children: [
            //       ListViewArkib(
            //         beritaListFuture: beritaListFuture,
            //       ),
            //       ListViewAkanDatang(
            //         futureDateBerita: beritaListFuture,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

Future<List<Berita>> _fetchBerita() async {
  final response = await http.get(Uri.parse(Api.berita));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> beritaJsonList = data['data']['berita'];

    // Filter berita berdasarkan status
    List<Berita> filteredBeritaList = beritaJsonList
        .map((json) => Berita.fromJson(json))
        .where((berita) =>
            berita.status ==
            0) // !Hanya menampilkan berita dengan status 0 Arkib
        .toList();

    return filteredBeritaList;
  } else {
    throw Exception('Failed to load data');
  }
}

class ListViewArkib extends StatefulWidget {
  final Future<List<Berita>> beritaListFuture;
  const ListViewArkib({super.key, required this.beritaListFuture});

  @override
  State<ListViewArkib> createState() => _ListViewArkibState();
}

class _ListViewArkibState extends State<ListViewArkib> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Berita>>(
      future: _fetchBerita(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitFadingCircle(
              color: Color(0xFF5268B5),
            ),
          );
        } else if (snapshot.hasError) {
          print('Error ${snapshot.hasError}');
          return _LoadAcara();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('No data available');
          return _LoadAcara();
        } else {
          final beritaList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: beritaList.length,
            itemBuilder: (context, index) {
              final berita = beritaList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Color(0xffDFE5EE),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        color: Color(0xff000000).withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        berita.tajuk != null
                            ? berita.tajuk!
                            : 'data  tidak tersedia',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${berita.tanggal != null ? DateFormat('dd MMMM yyyy', 'ms_MY').format(berita.tanggal!) : '--:--:--'} - ${berita.acaraAwal ?? '-:-'} ~ ${berita.acaraAkhir ?? '-:-'}',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4C4C4C),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            berita.getStatusText(),
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: berita.getStatusColor(),
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
}

Widget _LoadAcara() {
  return ListView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: 10, // Jumlah shimmer item placeholder
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Color(0xffDFE5EE),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 5,
                  color: Color(0xff000000).withOpacity(0.05),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 80,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
