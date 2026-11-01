import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/giveaway.dart';

class GiveawayApi {
  static const _url = 'https://www.gamerpower.com/api/giveaways';

  Future<List<Giveaway>> fetchGiveaways() async {
    final res = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 20));

    if (res.statusCode != 200) {
      throw Exception('Server responded with ${res.statusCode}');
    }
    final decoded = jsonDecode(res.body);
    if (decoded is! List) {
      throw Exception('Unexpected response from server');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(Giveaway.fromJson)
        .toList();
  }
}
