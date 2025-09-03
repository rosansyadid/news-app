// Lokasi: lib/ApiScreen.dart

import 'package:flutter/material.dart';
import 'package:news_app/api/api.dart';
import 'package:news_app/screen/detail_screen.dart';
import 'package:intl/intl.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  String _selectedCategory = '';
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allNews = [];
  List<Map<String, dynamic>> _filteredNews = [];
  bool isLoading = false;

  Future<void> fetchNews(String type) async {
    setState(() {
      isLoading = true;
    });
    final data = await Api().getApi(category: type);
    setState(() {
      _allNews = data;
      _filteredNews = data;
      isLoading = false;
    });
  }

  _applySearch(String query) {
    setState(() {
      if (query.isEmpty) {
        setState(() {
          _filteredNews = _allNews;
        });
      } else {
        setState(() {
          _filteredNews = _allNews.where((item) {
            final title = item['title'].toString().toLowerCase();
            final snippet = item['contentSnippet'].toString().toLowerCase();
            final search = query.toLowerCase();
            return title.contains(search) || snippet.contains(search);
          }).toList();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNews(_selectedCategory);
    _searchController.addListener(() {
      _applySearch(_searchController.text);
    });
  }

  Widget categoryButton(String label, String type) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCategory == type ? Colors.blue : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _selectedCategory = type;
        });
      },
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyy, hh:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News App')),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  _applySearch('');
                },
                icon: Icon(Icons.search),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                categoryButton('semua', ''),
                SizedBox(width: 5),
                categoryButton('nasional', 'nasional'),
                SizedBox(width: 5),
                categoryButton('internasional', 'internasional'),
                SizedBox(width: 5),
                categoryButton('ekonomi', 'ekonomi'),
                SizedBox(width: 5),
                categoryButton('olahraga', 'olahraga'),
                SizedBox(width: 5),
                categoryButton('hiburan', 'hiburan'),
                SizedBox(width: 5),
                categoryButton('gaya-hidup', 'gaya-hidupg'),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredNews.isEmpty
                ? Center(child: Text('No News Found'))
                : ListView.builder(
                    // Beri sedikit padding pada list agar kartu tidak menempel di tepi layar
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _filteredNews.length,
                    itemBuilder: (context, index) {
                      final item = _filteredNews[index];

                      // =======================================================================
                      // BAGIAN INI YANG KITA UBAH DARI LISTTILE MENJADI CONTAINER
                      // =======================================================================
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(newsDetail: item),
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
                                      formatDate(item['isoDate']),
                                      // Anda bisa format ini nanti
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
                  ),
          ),
        ],
      ),
    );
  }
}
