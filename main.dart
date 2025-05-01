import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoes Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HeroAnimationList(),
    );
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    required this.onTap,
    required this.width,
  });

  final String photo;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: photo,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              photo,
              width: width,
              height: width,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class HeroAnimationList extends StatelessWidget {
  const HeroAnimationList({super.key});

  final List<String> images = const [
    'images/1.jpeg',
    'images/5.jpeg',
    'images/6.jpeg',
    'images/7.jpeg',
    'images/8.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0; // Slows animation for better visibility

    return Scaffold(
      appBar: AppBar(title: const Text('car pictures list')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final photo = images[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PhotoHero(
              photo: photo,
              width: 120, // Small size on home
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('Detail View')),
                        body: Center(
                          child: PhotoHero(
                            photo: photo,
                            width: 300, // Large size on detail screen
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
