# 📚 API Reference

คู่มือการใช้งาน PBService และ PocketBase API

---

## 🗄️ PBService Class

### Configuration

```dart
class PBService {
  static const String baseUrl = 'http://127.0.0.1:8090';
  static const String collection = 'menus';
}
```

---

## 📖 Methods

### 1. fetchMenus()

ดึงข้อมูลเมนูทั้งหมดจาก PocketBase

**Signature**:
```dart
static Future<List<dynamic>> fetchMenus()
```

**Returns**: `Future<List<dynamic>>`

**Example**:
```dart
final menus = await PBService.fetchMenus();
print('พบเมนู ${menus.length} รายการ');
```

**Response Format**:
```json
[
  {
    "id": "abc123",
    "Name": "ข้าวผัดกะเพรา",
    "Price": 50,
    "Category": "rice",
    "Available": true,
    "ImageUrl": "https://picsum.photos/...",
    "created": "2024-10-15 10:00:00",
    "updated": "2024-10-15 10:00:00"
  }
]
```

---

### 2. createMenu()

เพิ่มเมนูใหม่

**Signature**:
```dart
static Future<bool> createMenu(Map<String, dynamic> data)
```

**Parameters**:
```dart
{
  'name': String,        // ชื่อเมนู (required)
  'price': double,       // ราคา (required)
  'category': String,    // หมวดหมู่: rice, noodle, drink (required)
  'available': bool,     // สถานะ (required)
  'imageUrl': String?,   // URL รูปภาพ (optional)
}
```

**Returns**: `Future<bool>`
- `true` - เพิ่มสำเร็จ
- `false` - เพิ่มไม่สำเร็จ

**Example**:
```dart
final success = await PBService.createMenu({
  'name': 'ข้าวผัดกุ้ง',
  'price': 60.0,
  'category': 'rice',
  'available': true,
  'imageUrl': 'https://example.com/image.jpg',
});

if (success) {
  print('✅ เพิ่มเมนูสำเร็จ');
} else {
  print('❌ เพิ่มเมนูไม่สำเร็จ');
}
```

---

### 3. updateMenu()

อัปเดตข้อมูลเมนู

**Signature**:
```dart
static Future<bool> updateMenu(String id, Map<String, dynamic> data)
```

**Parameters**:
- `id`: String - Menu ID ที่ต้องการแก้ไข
- `data`: Map<String, dynamic> - ข้อมูลที่ต้องการอัปเดต

**Data Format**:
```dart
{
  'name': String,
  'price': double,
  'category': String,
  'available': bool,
}
```

**Returns**: `Future<bool>`

**Example**:
```dart
final success = await PBService.updateMenu('abc123', {
  'name': 'ข้าวผัดกะเพราหมูกรอบ',
  'price': 55.0,
  'category': 'rice',
  'available': true,
});
```

---

### 4. deleteMenu()

ลบเมนู

**Signature**:
```dart
static Future<bool> deleteMenu(String id)
```

**Parameters**:
- `id`: String - Menu ID ที่ต้องการลบ

**Returns**: `Future<bool>`

**Example**:
```dart
final success = await PBService.deleteMenu('abc123');

if (success) {
  print('✅ ลบเมนูสำเร็จ');
}
```

---

### 5. getMenuStats()

ดึงสถิติจำนวนเมนู

**Signature**:
```dart
static Future<Map<String, int>> getMenuStats()
```

**Returns**: `Future<Map<String, int>>`

**Response Format**:
```dart
{
  'total': 100,       // เมนูทั้งหมด
  'available': 85,    // เมนูที่ขายอยู่
  'unavailable': 15,  // เมนูที่หยุดขาย
}
```

**Example**:
```dart
final stats = await PBService.getMenuStats();
print('ทั้งหมด: ${stats['total']}');
print('ขายอยู่: ${stats['available']}');
print('หยุดขาย: ${stats['unavailable']}');
```

---

## 🎯 Menu Model

### Properties

```dart
class Menu {
  final String id;           // Record ID จาก PocketBase
  final String name;         // ชื่อเมนู
  final double price;        // ราคา (บาท)
  final String category;     // หมวดหมู่ (rice, noodle, drink)
  final bool available;      // สถานะพร้อมขาย
  final String imageUrl;     // URL รูปภาพ
}
```

### Methods

#### fromJson()

แปลง JSON เป็น Menu object

```dart
factory Menu.fromJson(Map<String, dynamic> json)
```

**Example**:
```dart
final json = {
  'id': 'abc123',
  'Name': 'ข้าวผัดกะเพรา',
  'Price': 50,
  'Category': 'rice',
  'Available': true,
  'ImageUrl': 'https://example.com/image.jpg',
};

final menu = Menu.fromJson(json);
```

#### getImageUrl()

ดึง URL รูปภาพที่ใช้งานได้

```dart
String getImageUrl()
```

**Returns**: String
- ถ้าเป็น external URL (http/https) → คืนค่าตามเดิม
- ถ้าเป็นไฟล์ใน PocketBase → สร้าง URL ที่สมบูรณ์

**Example**:
```dart
final menu = Menu.fromJson(jsonData);
final imageUrl = menu.