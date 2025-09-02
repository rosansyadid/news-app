import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> newsDetail;
  const DetailScreen({super.key, required this.newsDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Detail')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: Image.network(newsDetail['image']['large']),
          ),
          SizedBox(height: 14,),
          Text(
            newsDetail['title'],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(newsDetail['contentSnippet'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),)
        ],
      ),
    );
  }
}
