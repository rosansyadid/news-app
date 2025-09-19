import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controller/news_controller.dart';
import 'package:news_app/screen/detail_screen.dart';
import 'package:intl/intl.dart';

class ApiScreen extends StatelessWidget {
  var c = Get.put(NewsController());

  final NewsController controller = Get.put(NewsController());
  final TextEditingController searchController = TextEditingController();

  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return "Baru saja";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} menit lalu";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} jam lalu";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} hari lalu";
      } else {
        // fallback ke format tanggal biasa
        return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
      }
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    searchController.addListener(() {
      controller.applySearch(searchController.text);
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Newsly',
          style: TextStyle(fontFamily: 'Playfair Display', fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            // 🔍 Search bar
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 📌 Categories (chips style)
            Obx(() {
              final categories = [
                {'label': 'Semua', 'value': ''},
                {'label': 'Nasional', 'value': 'nasional'},
                {'label': 'Internasional', 'value': 'internasional'},
                {'label': 'Ekonomi', 'value': 'ekonomi'},
                {'label': 'Olahraga', 'value': 'olahraga'},
                {'label': 'Hiburan', 'value': 'hiburan'},
                {'label': 'Gaya Hidup', 'value': 'gaya-hidup'},
              ];

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected =
                        controller.selectedCategory.value == cat['value'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat['label']!),
                        selected: isSelected,
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (_) =>
                            controller.changeCategory(cat['value']!),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
            const SizedBox(height: 10),

            // 📑 News List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredNews.isEmpty) {
                  return const Center(child: Text("No News Found"));
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.filteredNews.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredNews[index];
                    final String title = item['title'] ?? 'No Title';
                    final String date = item['isoDate'] ?? '';
                    final String category = item['category'] ?? 'General';
                    final String imageUrl = item['image']?['small'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => DetailScreen(newsDetail: item));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🖼 Gambar
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Image.network(
                                imageUrl,
                                width: 120,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 120,
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),

                            // 📄 Info berita
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Category
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Judul
                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Date
                                    Text(
                                      formatDate(date),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
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
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
