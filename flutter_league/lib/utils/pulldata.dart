import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, Map<String, double>>> pullData() async {
  final response = await http.get(Uri.parse(
      'http://cdn.merakianalytics.com/riot/lol/resources/latest/en-US/championrates.json'));

  if (response.statusCode == 200) {
    final j = jsonDecode(response.body);
    final data = <String, Map<String, double>>{};

    j["data"].forEach((championId, positions) {
      final championIdInt = int.parse(championId);
      final playRates = <String, double>{};

      positions.forEach((position, rates) {
        playRates[position.toUpperCase()] = rates["playRate"] + 0.0;
      });

      for (final position in ["TOP", "JUNGLE", "MIDDLE", "BOTTOM", "UTILITY"]) {
        if (!playRates.containsKey(position)) {
          playRates[position] = 0.0;
        }
      }

      data[championId] = playRates;
    });

    return data;
  } else {
    throw Exception('Failed to fetch data');
  }
}
