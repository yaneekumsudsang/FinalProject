import 'package:http/http.dart' as http;
import 'dart:convert';

class PBService {
  static const String baseUrl = 'http://127.0.0.1:8090';
  static const String collection = 'menus';

  // ✅ ดึงข้อมูลทั้งหมดจาก PocketBase
  static Future<List<dynamic>> fetchMenus() async {
    final url = Uri.parse('$baseUrl/api/collections/$collection/records');

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print('📦 โหลดข้อมูลสำเร็จ: ${body['items'].length} รายการ');
        return body['items'];
      } else {
        print('❌ โหลดข้อมูลล้มเหลว (${res.statusCode})');
        return [];
      }
    } catch (e) {
      print('⚠️ เกิดข้อผิดพลาดในการโหลดข้อมูล: $e');
      return [];
    }
  }

  // ✅ เพิ่มเมนูใหม่
  static Future<bool> createMenu(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/api/collections/$collection/records');
    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Name': data['name'],
          'Price': data['price'],
          'Category': data['category'],
          'Available': data['available'],
          'ImageUrl': data['imageUrl'] ?? '',
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('⚠️ สร้างเมนูล้มเหลว: $e');
      return false;
    }
  }

  // ✅ อัปเดตเมนู
  static Future<bool> updateMenu(String id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/api/collections/$collection/records/$id');
    try {
      final res = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Name': data['name'],
          'Price': data['price'],
          'Category': data['category'],
          'Available': data['available'],
        }),
      );
      return res.statusCode == 200;
    } catch (e) {
      print('⚠️ อัปเดตเมนูล้มเหลว: $e');
      return false;
    }
  }

  // ✅ ลบเมนู
  static Future<bool> deleteMenu(String id) async {
    final url = Uri.parse('$baseUrl/api/collections/$collection/records/$id');
    try {
      final res = await http.delete(url);
      return res.statusCode == 204;
    } catch (e) {
      print('⚠️ ลบเมนูล้มเหลว: $e');
      return false;
    }
  }

  // ✅ นับจำนวนเมนูทั้งหมดและแยกตามสถานะ (ฟังก์ชันที่หายไป!)
  static Future<Map<String, int>> getMenuStats() async {
    try {
      final allMenus = await fetchMenus();
      final available = allMenus.where((m) => m['Available'] == true).length;
      final unavailable = allMenus.length - available;
      
      return {
        'total': allMenus.length,
        'available': available,
        'unavailable': unavailable,
      };
    } catch (e) {
      print('⚠️ ดึงสถิติล้มเหลว: $e');
      return {'total': 0, 'available': 0, 'unavailable': 0};
    }
  }
}