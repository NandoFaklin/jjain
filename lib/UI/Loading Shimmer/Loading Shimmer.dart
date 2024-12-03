import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

Widget _buildShimmerList() {
  return const LoadingShimmer();
}

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            margin: const EdgeInsets.only(bottom: 12),
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: const Color(0xffDFE5EE)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey[400],
                  ),
                ),
              ),
              title: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[400],
                ),
              ),
              subtitle: Container(
                height: 12,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[400],
                ),
                margin: const EdgeInsets.only(top: 4),
              ),
              trailing: SizedBox(
                width: 50,
                height: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey[400],
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget LoadingBerita() {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: 5,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: const Color(0xffFFFFFF),
              border: Border.all(
                width: 1,
                color: const Color(0xffD9D9D9),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("images/Calendar.png"),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 80,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset("images/Time Circle.png"),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 60,
                          height: 16,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 70,
                      height: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffF1F4F8),
                      ),
                      child: Center(
                        child: Text(
                          "Info",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff5268B5),
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
      );
    },
  );
}


class _LoadAcara extends StatelessWidget {
  const _LoadAcara({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10, // Jumlah shimmer item placeholder
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: const Color(0xffDFE5EE),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 5,
                    color: const Color(0xff000000).withOpacity(0.05),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    height: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 80,
                        height: 15,
                        color: Colors.white,
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
}
