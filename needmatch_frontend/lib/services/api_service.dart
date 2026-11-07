import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;

  // ============================================================
  // COMMON HEADERS
  // ============================================================

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // ============================================================
  // REGISTER
  // ============================================================

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String location = '',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'location': location,
      }),
    );

    return _handleResponse(response);
  }

  // ============================================================
  // LOGIN
  // ============================================================

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = _handleResponse(response);

    if (data['user'] != null) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'current_user',
        jsonEncode(data['user']),
      );

      await prefs.setInt(
        'user_id',
        data['user']['id'],
      );
    }

    return data;
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('current_user');
    await prefs.remove('user_id');
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userString = prefs.getString('current_user');

    if (userString == null) {
      return null;
    }

    return jsonDecode(userString) as Map<String, dynamic>;
  }

  static Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt('user_id');
  }

  static Future<Map<String, dynamic>> getUser(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id/'),
      headers: headers,
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateUser({
    required int id,
    String? name,
    String? email,
    String? phone,
    String? location,
  }) async {
    final payload = <String, dynamic>{};

    if (name != null) payload['name'] = name;
    if (email != null) payload['email'] = email;
    if (phone != null) payload['phone'] = phone;
    if (location != null) payload['location'] = location;

    final response = await http.put(
      Uri.parse('$baseUrl/users/$id/'),
      headers: headers,
      body: jsonEncode(payload),
    );

    final data = _handleResponse(response);

    if (data is Map<String, dynamic>) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'current_user',
        jsonEncode(data),
      );
      if (data['id'] != null) {
        await prefs.setInt('user_id', data['id'] as int);
      }
    }

    return data;
  }

  // ============================================================
  // RESOURCES - GET
  // ============================================================

  static Future<List<dynamic>> getResources() async {
    final response = await http.get(
      Uri.parse('$baseUrl/resources/'),
      headers: headers,
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

  // ============================================================
  // RESOURCE - GET ONE
  // ============================================================

  static Future<Map<String, dynamic>> getResource(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/resources/$id/'),
      headers: headers,
    );

    return _handleResponse(response);
  }

  // ============================================================
  // RESOURCE - CREATE
  // ============================================================

  static Future<Map<String, dynamic>> createResource({
    required int userId,
    required String title,
    required String category,
    required int quantity,
    required String location,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/resources/'),
      headers: headers,
      body: jsonEncode({
        'user': userId,
        'title': title,
        'category': category,
        'quantity': quantity,
        'location': location,
        'description': description,
      }),
    );

    return _handleResponse(response);
  }

  // ============================================================
  // RESOURCE - UPDATE
  // ============================================================

  static Future<Map<String, dynamic>> updateResource({
    required int id,
    required int userId,
    required String title,
    required String category,
    required int quantity,
    required String location,
    required String description,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/resources/$id/'),
      headers: headers,
      body: jsonEncode({
        'user': userId,
        'title': title,
        'category': category,
        'quantity': quantity,
        'location': location,
        'description': description,
      }),
    );

    return _handleResponse(response);
  }

  // ============================================================
  // RESOURCE - DELETE
  // ============================================================

  static Future<void> deleteResource(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/resources/$id/'),
      headers: headers,
    );

    if (response.statusCode != 204 &&
        response.statusCode != 200) {
      throw Exception(
        'Failed to delete resource: ${response.body}',
      );
    }
  }

  // ============================================================
  // REQUESTS - GET
  // ============================================================

  static Future<List<dynamic>> getRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl/requests/'),
      headers: headers,
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

  // ============================================================
  // REQUEST - GET ONE
  // ============================================================

  static Future<Map<String, dynamic>> getRequest(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/requests/$id/'),
      headers: headers,
    );

    return _handleResponse(response);
  }

  // ============================================================
  // REQUEST - CREATE
  // ============================================================

  static Future<Map<String, dynamic>> createRequest({
    required int userId,
    required String title,
    required String category,
    required int quantity,
    required String location,
    required String urgency,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/requests/'),
      headers: headers,
      body: jsonEncode({
        'user': userId,
        'title': title,
        'category': category,
        'quantity': quantity,
        'location': location,
        'urgency': urgency.toUpperCase(),
        'description': description,
      }),
    );

    return _handleResponse(response);
  }

  // ============================================================
  // REQUEST - UPDATE
  // ============================================================

  static Future<Map<String, dynamic>> updateRequest({
    required int id,
    required int userId,
    required String title,
    required String category,
    required int quantity,
    required String location,
    required String urgency,
    required String description,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/requests/$id/'),
      headers: headers,
      body: jsonEncode({
        'user': userId,
        'title': title,
        'category': category,
        'quantity': quantity,
        'location': location,
        'urgency': urgency.toUpperCase(),
        'description': description,
      }),
    );

    return _handleResponse(response);
  }

  // ============================================================
  // REQUEST - DELETE
  // ============================================================

  static Future<void> deleteRequest(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/requests/$id/'),
      headers: headers,
    );

    if (response.statusCode != 204 &&
        response.statusCode != 200) {
      throw Exception(
        'Failed to delete request: ${response.body}',
      );
    }
  }

  // ============================================================
  // MATCHES
  // ============================================================

  static Future<List<dynamic>> getMatches() async {
    final response = await http.get(
      Uri.parse('$baseUrl/matches/'),
      headers: headers,
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

  // ============================================================
  // GENERATE MATCHES
  // ============================================================

  static Future<Map<String, dynamic>> generateMatches(
    int resourceId,
  ) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/resources/$resourceId/generate-matches/',
      ),
      headers: headers,
      body: jsonEncode({}),
    );

    return _handleResponse(response);
  }

  // ============================================================
  // MATCH DETAILS
  // ============================================================

  static Future<Map<String, dynamic>> getMatch(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/matches/$id/'),
      headers: headers,
    );

    return _handleResponse(response);
  }

  // ============================================================
  // ACCEPT MATCH
  // ============================================================

  static Future<Map<String, dynamic>> acceptMatch(
    int id,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/matches/$id/accept/'),
      headers: headers,
      body: jsonEncode({}),
    );

    return _handleResponse(response);
  }

  // ============================================================
  // FULFILLMENTS
  // ============================================================

  static Future<List<dynamic>> getFulfillments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/fulfillments/'),
      headers: headers,
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

  // ============================================================
  // FULFILLMENT DETAILS
  // ============================================================

  static Future<Map<String, dynamic>> getFulfillment(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/fulfillments/$id/'),
      headers: headers,
    );

    return _handleResponse(response);
  }

  // ============================================================
  // UPDATE FULFILLMENT
  // ============================================================

  static Future<Map<String, dynamic>> updateFulfillment({
    required int id,
    required String status,
    String? notes,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/fulfillments/$id/'),
      headers: headers,
      body: jsonEncode({
        'status': status,
        if (notes != null) 'notes': notes,
      }),
    );

    return _handleResponse(response);
  }

  // ============================================================
  // RESPONSE HANDLER
  // ============================================================

  static dynamic _handleResponse(
    http.Response response,
  ) {
    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = {
        'message': response.body,
      };
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    String message = 'Something went wrong.';

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        message = data['message'].toString();
      } else {
        message = data.toString();
      }
    }

    throw Exception(message);
  }
}