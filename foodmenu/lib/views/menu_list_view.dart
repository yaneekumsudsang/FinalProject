import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../services/pb_service.dart';
import 'menu_edit_view.dart';
import 'menu_add_view.dart';

class MenuListView extends StatefulWidget {
  const MenuListView({super.key});

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  List<Menu> menus = [];
  String categoryFilter = '';

  Future<void> loadMenus() async {
    final data = await PBService.fetchMenus();
    setState(() {
      menus = data.map((e) => Menu.fromJson(e)).toList();
    });
  }

  // --- ฟังก์ชันสำหรับลบเมนู ---
  Future<void> _deleteMenu(Menu menu) async {
    // แสดง Dialog เพื่อยืนยันการลบ
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบเมนู "${menu.name}" ใช่หรือไม่?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('ลบ'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    // ถ้าผู้ใช้ยืนยันการลบ
    if (confirmDelete == true) {
      try {
        // *** หมายเหตุ: คุณต้องสร้างฟังก์ชัน deleteMenu ใน PBService ของคุณ ***
        // await PBService.deleteMenu(menu.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ลบเมนู "${menu.name}" สำเร็จแล้ว'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
        // โหลดข้อมูลใหม่
        await loadMenus();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ เกิดข้อผิดพลาดในการลบ: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  List<Menu> get filteredMenus {
    if (categoryFilter.isEmpty) return menus;
    return menus.where((m) => m.category == categoryFilter).toList();
  }

  String getCategoryName(String category) {
    switch (category) {
      case 'rice':
        return 'ข้าว';
      case 'noodle':
        return 'ก๋วยเตี๋ยว';
      case 'drink':
        return 'เครื่องดื่ม';
      default:
        return category;
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'rice':
        return Icons.rice_bowl;
      case 'noodle':
        return Icons.ramen_dining;
      case 'drink':
        return Icons.local_cafe;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredMenus;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'รายการเมนูอาหาร',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Section - ดีไซน์ใหม่
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9966),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'กรองตามหมวดหมู่',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('ทั้งหมด', '', Icons.restaurant_menu),
                        const SizedBox(width: 10),
                        _buildFilterChip('ข้าว', 'rice', Icons.rice_bowl),
                        const SizedBox(width: 10),
                        _buildFilterChip('ก๋วยเตี๋ยว', 'noodle', Icons.ramen_dining),
                        const SizedBox(width: 10),
                        _buildFilterChip('เครื่องดื่ม', 'drink', Icons.local_cafe),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Count with Animation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.deepOrange.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.grid_view_rounded,
                            size: 16,
                            color: Colors.deepOrange.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${filtered.length} รายการ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepOrange.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (categoryFilter.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        categoryFilter = '';
                      });
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('ล้างตัวกรอง'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Grid View - 6 คอลัมน์
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadMenus,
              color: Colors.deepOrange,
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final m = filtered[index];
                        return _buildMenuCard(m);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'เพิ่มเมนูใหม่',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        elevation: 6,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MenuAddView()),
          );
          if (result == true) {
            loadMenus();
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.orange.shade300,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'ไม่พบเมนูอาหาร',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ลองเปลี่ยนตัวกรองหรือเพิ่มเมนูใหม่',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = categoryFilter == value;
    return Material(
      elevation: isSelected ? 4 : 0,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: () {
          setState(() {
            categoryFilter = value;
          });
        },
        borderRadius: BorderRadius.circular(25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepOrange : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? Colors.deepOrange : Colors.white,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.deepOrange,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.deepOrange,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(Menu m) {
    final imageUrl = m.getImageUrl();

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MenuEditView(menu: m)),
          );
          loadMenus();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🖼️ รูปอาหาร
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade100,
                              Colors.orange.shade50,
                            ],
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.deepOrange,
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade100,
                            Colors.orange.shade50,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.fastfood_rounded,
                        size: 40,
                        color: Colors.orange,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade100,
                          Colors.orange.shade50,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.fastfood_rounded,
                      size: 40,
                      color: Colors.orange,
                    ),
                  ),

            // 🔳 เงาไล่ระดับด้านล่าง
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // 🏷️ ชื่อเมนูและราคา
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ไอคอนหมวดหมู่
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getCategoryIcon(m.category),
                          size: 12,
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          getCategoryName(m.category),
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // ชื่อเมนู
                  Text(
                    m.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // ราคา
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '฿${m.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔘 สถานะหมด
            if (!m.available)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.block_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'หมดชั่วคราว',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // --- ✨ ปุ่มแก้ไขและลบที่เพิ่มเข้ามาใหม่ ---
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ปุ่มแก้ไข
                    IconButton(
                      icon: const Icon(Icons.edit, size: 16),
                      color: Colors.white,
                      tooltip: 'แก้ไข',
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MenuEditView(menu: m)),
                        );
                        loadMenus();
                      },
                    ),
                    // ปุ่มลบ
                    IconButton(
                      icon: const Icon(Icons.delete, size: 16),
                      color: Colors.red.shade300,
                      tooltip: 'ลบ',
                      onPressed: () => _deleteMenu(m),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}