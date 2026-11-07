import 'api_service.dart';

class ApiTest {
  static Future<void> testConnection() async {
    try {
      final resources = await ApiService.getResources();

      print('======================================');
      print('DJANGO CONNECTION SUCCESS');
      print('Resources: $resources');
      print('======================================');
    } catch (e) {
      print('======================================');
      print('DJANGO CONNECTION FAILED');
      print(e);
      print('======================================');
    }
  }
}