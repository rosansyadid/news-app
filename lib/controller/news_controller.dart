// lib/controller/news_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:news_app/api/api.dart';

class NewsController extends GetxController {
  var newsList = <Map<String, dynamic>>[].obs;
  var filteredNews = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews('');
  }

  Future<void> fetchNews(String category) async {
    try {
      isLoading.value = true;

      if (category.isEmpty) {
        // Semua kategori
        final categories = [
          'nasional',
          'internasional',
          'ekonomi',
          'olahraga',
          'hiburan',
          'gaya-hidup',
        ];

        List<Map<String, dynamic>> allNews = [];

        for (var cat in categories) {
          final data = await Api().getApi(category: cat);
          final withCat = data.map((item) {
            return {...item, "category": cat};
          }).toList();
          allNews.addAll(withCat);
        }

        allNews.sort((a, b) {
          final dateA = DateTime.parse(a['isoDate']);
          final dateB = DateTime.parse(b['isoDate']);
          return dateB.compareTo(dateA); // descending, terbaru dulu
        });

        newsList.assignAll(allNews);
        filteredNews.assignAll(allNews);
      } else {
        // Satu kategori
        final data = await Api().getApi(category: category);
        final withCat = data.map((item) {
          return {...item, "category": category};
        }).toList();

        newsList.assignAll(withCat);
        filteredNews.assignAll(withCat);
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  void applySearch(String query) {
    if (query.isEmpty) {
      filteredNews.assignAll(newsList);
    } else {
      final search = query.toLowerCase();
      filteredNews.assignAll(
        newsList.where((item) {
          final title = item['title'].toString().toLowerCase();
          final snippet = item['contentSnippet'].toString().toLowerCase();
          return title.contains(search) || snippet.contains(search);
        }).toList(),
      );
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchNews(category);
  }
}
