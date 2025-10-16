import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../services/pb_service.dart';

class MenuEditView extends StatefulWidget {
  final Menu menu;
  const MenuEditView({super.key, required this.menu});

  @override
  State<MenuEditView> createState() => _MenuEditViewState();
}

class _MenuEditViewState extends State<MenuEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late String category;
  late bool available;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.menu.name);
    priceCtrl = TextEditingController(text: widget.menu.price.toString());
    category = widget.menu.category;
    available = widget.menu.available;
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);
    try {
      await PBService.updateMenu(widget.menu.id, {
        'name': nameCtrl.text.trim(),
        'price': double.tryParse(priceCtrl.text) ?? 0,
        'category': category,
        'available': available,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('❌ แก้ไขเมนูไม่สำเร็จ: $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('แก้ไขเมนูอาหาร', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9966),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit_note, 
                        color: Colors.white, size: 40),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'แก้ไขข้อมูลเมนูอาหารของคุณ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ชื่อเมนู
                      TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'ชื่อเมนู',
                          prefixIcon: const Icon(Icons.fastfood, 
                            color: Colors.deepOrange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.deepOrange, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'กรุณากรอกชื่อเมนู' : null,
                      ),
                      const SizedBox(height: 20),

                      // ราคา
                      TextFormField(
                        controller: priceCtrl,
                        decoration: InputDecoration(
                          labelText: 'ราคา (บาท)',
                          prefixIcon: const Icon(Icons.attach_money, 
                            color: Colors.deepOrange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.deepOrange, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'กรุณากรอกราคา' : null,
                      ),
                      const SizedBox(height: 20),

                      // หมวดหมู่
                      DropdownButtonFormField<String>(
                        value: category,
                        items: const [
                          DropdownMenuItem(
                            value: 'rice',
                            child: Row(
                              children: [
                                Icon(Icons.rice_bowl, size: 20, color: Colors.deepOrange),
                                SizedBox(width: 10),
                                Text('ข้าว'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'noodle',
                            child: Row(
                              children: [
                                Icon(Icons.ramen_dining, size: 20, color: Colors.deepOrange),
                                SizedBox(width: 10),
                                Text('ก๋วยเตี๋ยว'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'drink',
                            child: Row(
                              children: [
                                Icon(Icons.local_cafe, size: 20, color: Colors.deepOrange),
                                SizedBox(width: 10),
                                Text('เครื่องดื่ม'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => category = v!),
                        decoration: InputDecoration(
                          labelText: 'หมวดหมู่',
                          prefixIcon: const Icon(Icons.category, 
                            color: Colors.deepOrange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.deepOrange, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.deepOrange.shade50,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // สถานะขาย
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.deepOrange.shade200),
                        ),
                        child: SwitchListTile(
                          title: const Text('สถานะการขาย',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            available ? '✅ เปิดขาย' : '❌ ปิดขาย',
                            style: TextStyle(
                              color: available ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: available,
                          onChanged: (v) => setState(() => available = v),
                          activeColor: Colors.green,
                          secondary: Icon(
                            available ? Icons.check_circle : Icons.cancel,
                            color: available ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : save,
                    icon: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            ),
                          )
                        : const Icon(Icons.save_rounded, size: 24),
                    label: Text(
                      isSaving ? 'กำลังบันทึก...' : 'บันทึกการแก้ไข',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}