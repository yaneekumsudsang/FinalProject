## ขั้นตอนการติดตั้งและรันโปรเจกต์

### 1. clone Github repo

```bash
https://github.com/yaneekumsudsang/FinalProject.git
```
```bash
cd foodmenu
```

### 2. ติดตั้ง Dependencies ของ Flutter

```bash
flutter pub get
```

### 3. ติดตั้ง dependencies สำหรับ seed script
```bash
npm install node-fetch form-data @faker-js/faker

```

### 4. รัน PocketBase

```bash
pocketbase serve
```

### 5. สร้าง Collection ชื่อ menus
###### 🗂️ โครงสร้าง Collection: `menus`
| **Field** | **Type** |
|:----------:|:--------:|
| Name | text |
| Price | number |
| Category | text |
| Available | bool |
| ImageUrl | url |

### 6. ตั้งค่า Permissions ให้ทุก rule (List, View) เป็น

```bash
true
```
เพื่ออนุญาตให้แอป Flutter ดึงข้อมูลได้โดยไม่ต้องล็อกอิน

### 7. เพิ่มข้อมูลจำลองเข้า PocketBase
###### เพิ่มข้อมูลจำลองเข้า PocketBase

```bash
cd tools
```
```bash
npm install
```
```bash
node seed_menus.mjs
```
###### สคริปต์นี้จะสุ่มเมนูอาหาร 100 รายการ สคริปต์นี้จะสุ่มเมนูอาหาร 100 รายการ

### 8. รันแอป Flutter
```bash
cd ..
```
```bash
flutter run -d chrome
```

#### ผู้พัฒนา
##### Yanee Kumsudsang
###### Data Science and Software Innovation – Ubon Ratchathani University
###### email: yanee.ku.65@ubu.ac.th