import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    futureAsteroids = ApiService().fetchAsteroids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asteroid List'),
      ),
      body: FutureBuilder<List<Asteroid>>(
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
                return ListTile(
                  title: Text(asteroid.name),
                  subtitle:
                      Text('Hazardous: ${asteroid.isHazardous ? 'Yes' : 'No'}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
