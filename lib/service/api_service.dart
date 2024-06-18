import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:nasa_api_app/model/asteroid.dart';

final random = Random();
List<Asteroid> testData = List.generate(10, (index) {
  return Asteroid(
    name: '${index + 1}',
    isHazardous: random.nextBool(),
  );
});

class ApiService {
  Future<List<Asteroid>> fetchAsteroids() async {
    const apiUrl =
        'https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=DEMO_KEY';

    final response = await http.get(Uri.parse(apiUrl));
    
    print('response.statusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> nearObjects = data['near_earth_objects'];

      return nearObjects.map((json) => Asteroid.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load asteroids');
    }
  }
}
