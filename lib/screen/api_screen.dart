// Lokasi: lib/ApiScreen.dart

// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

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
    final bool isSelected = _selectedCategory == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = type;
        });
        fetchNews(type);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(height: 4),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: 3,
              width: isSelected ? 50 : 0,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMM yyy, hh:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Newsly',
          style: TextStyle(fontFamily: 'Playfair Display', fontSize: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                prefixIcon: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          _searchController.clear();
                          _applySearch('');
                        },
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[100],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
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
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // --- BLOK TEKS DI KIRI ---
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // --- BARIS INFO ATAS (KATEGORI & TANGGAL) ---
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Tag Kategori
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Category', // Ganti dengan data kategori dari API jika ada
                                              style: TextStyle(
                                                color: Colors.blue[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                          // Tanggal
                                          Text(
                                            formatDate(item['isoDate']),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // --- JUDUL BERITA ---
                                      Text(
                                        item['title'],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.4, // Jarak antar baris
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // --- GAMBAR DI KANAN ---
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    item['image']['small'],
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 90,
                                        height: 90,
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey[400],
                                        ),
                                      );
                                    },
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
      ),
    );
  }
}
