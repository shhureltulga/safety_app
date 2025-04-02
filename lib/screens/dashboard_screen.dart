import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Хяналтын самбар',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.blueAccent,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Өнөөдрийн тойм',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Quick Stats Row
          Row(
            children: [
              _buildStatCard(
                title: 'Сургалт',
                value: '3',
                icon: Icons.play_circle_outline,
                color: Colors.blue,
              ),
              _buildStatCard(
                title: 'Зөрчил',
                value: '1',
                icon: Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
              _buildStatCard(
                title: 'Илгээсэн',
                value: '2',
                icon: Icons.send_outlined,
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Сүүлийн мэдээлэл',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          GFCard(
            title: GFListTile(
              avatar: const Icon(Icons.video_library, color: Colors.blueAccent),
              titleText: 'Галын аюулын сургалт',
              subTitleText: 'Үзсэн: 75%, Дуусгаагүй',
            ),
            buttonBar: GFButtonBar(
              children: [
                GFButton(
                  onPressed: () {},
                  text: 'Үзэх',
                  size: GFSize.SMALL,
                ),
              ],
            ),
          ),

          GFCard(
            title: GFListTile(
              avatar: const Icon(Icons.report, color: Colors.orange),
              titleText: 'Зөрчил илгээсэн',
              subTitleText: 'Тасралттай цахилгаан утас илэрсэн',
            ),
            buttonBar: GFButtonBar(
              children: [
                GFButton(
                  onPressed: () {},
                  text: 'Дэлгэрэнгүй',
                  color: GFColors.WARNING,
                  size: GFSize.SMALL,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.notoSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.notoSans(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
