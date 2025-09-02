// Lokasi: lib/ApiScreen.dart

import 'package:flutter/material.dart';
import 'package:news_app/api/api.dart';
import 'package:news_app/screen/detail_screen.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  String _selectedCategory = '';
  
  Widget categoryButton(String label, String type) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = type;
        });
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News App')),
      body: Column(
        children: [
          FutureBuilder(
            future: Api().getApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
          
              final data = snapshot.data!;
              return ListView.builder(
                // Beri sedikit padding pada list agar kartu tidak menempel di tepi layar
                padding: const EdgeInsets.all(8.0),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
          
                  // =======================================================================
                  // BAGIAN INI YANG KITA UBAH DARI LISTTILE MENJADI CONTAINER
                  // =======================================================================
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(newsDetail: item),
                        ),
                      );
                    },
                    // Beri efek sudut tumpul pada "splash" klik
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      // 1. STYLING KARTU
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      // 2. KONTEN DI DALAM KARTU
                      child: Row(
                        children: [
                          // GAMBAR DI KIRI
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item['image']['small'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              // (Opsional) Tampilkan loading saat gambar dimuat
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                      );
                              },
                              // (Opsional) Tampilkan ikon jika gambar gagal dimuat
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
          
                          // TEKS DI KANAN
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  maxLines:
                                      2, // Beri 2 baris agar judul lebih terbaca
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['isoDate'], // Anda bisa format ini nanti
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  // =======================================================================
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
