import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsDetail;
  const DetailScreen({super.key, required this.newsDetail});

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('News Detail'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                newsDetail['image']['large'],
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Judul
            Text(
              newsDetail['title'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Info penulis & tanggal
            Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: Colors.black87,
                ),
                const SizedBox(width: 8),
                Text(
                  "Author",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(width: 16),
                Text(
                  formatDate(newsDetail['isoDate']),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Konten
            Text(
              newsDetail['contentSnippet'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
