import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nasa_api_app/presentation/checked_asteroids_screen.dart';
import 'package:nasa_api_app/presentation/commonWidget/image_widget.dart';
import 'package:nasa_api_app/service/api_service.dart';
import 'package:nasa_api_app/model/asteroid.dart';

class AsteroidListScreen extends StatefulWidget {
  final String title;
  const AsteroidListScreen({super.key, required this.title});

  @override
  State<AsteroidListScreen> createState() => _AsteroidListScreenState();
}

class _AsteroidListScreenState extends State<AsteroidListScreen> {
  late Future<List<Asteroid>> futureAsteroids;
  List<Asteroid> asteroids = [];

  @override
  void initState() {
    super.initState();
    futureAsteroids = ApiService().fetchAsteroids();
    futureAsteroids.then((data) {
      setState(() {
        asteroids = data;
      });
    });
  }

  void toggleCheck(int index) {
    setState(() {
      asteroids[index] =
          asteroids[index].copyWith(checked: !asteroids[index].checked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const NetworkImageWidget(
            'https://d.newsweek.com/en/full/1043290/7-26-asteroids.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Asteroid List',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              TextButton.icon(
                label: const Text(
                  'Show Checked',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.check_box, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckedAsteroidsScreen(
                          checkedAsteroids: asteroids
                              .where((asteroid) => asteroid.checked)
                              .toList()),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: LayoutBuilder(builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: min(constraints.maxWidth, 600),
                  child: FutureBuilder<List<Asteroid>>(
                    future: futureAsteroids,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final asteroid = snapshot.data![index];
                            return Card(
                              color: Colors.black54,
                              child: ListTile(
                                title: Text(asteroid.name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                subtitle: Text(
                                    'Hazardous: ${asteroid.isHazardous ? 'Yes' : 'No'}',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                trailing: Checkbox(
                                  activeColor: Colors.white,
                                  // hoverColor: Colors.white,
                                  checkColor: Colors.black,
                                  value: asteroid.checked,
                                  onChanged: (bool? value) {
                                    toggleCheck(index);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
