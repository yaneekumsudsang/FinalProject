import 'dart:io';

class Menu {
  final String id;
  final String name;
  final double price;
  final String category;
  final bool available;
  final String imageUrl;

  Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.available,
    required this.imageUrl,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] ?? '',
      name: json['Name'] ?? '',
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      category: json['Category'] ?? '',
      available: json['Available'] == true,
      imageUrl: json['ImageUrl'] ?? '',
    );
  }

  // ✅ ฟังก์ชันสำหรับดึง URL รูปภาพ
  String getImageUrl() {
    if (imageUrl.isEmpty) return '';
    
    // ถ้าเป็น URL ภายนอก (Lorem Picsum) ให้ใช้ได้เลย
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    
    // ถ้าเป็นไฟล์ที่อัพโหลดใน PocketBase
    // Format: http://127.0.0.1:8090/api/files/COLLECTION_ID/RECORD_ID/FILENAME
    return 'http://127.0.0.1:8090/api/files/menus/$id/$imageUrl';
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Price': price,
      'Category': category,
      'Available': available,
      'ImageUrl': imageUrl,
    };
  }
}