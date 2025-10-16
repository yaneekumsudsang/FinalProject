import PocketBase from 'pocketbase';
import { faker } from '@faker-js/faker';

const pb = new PocketBase('http://127.0.0.1:8090');

const ADMIN_EMAIL = 'yanee.ku.65@ubu.ac.th';
const ADMIN_PASS = 'ya1234567890';

// 🎲 ข้อมูลเมนูไทยแท้ๆ
const THAI_MENUS = {
  rice: [
    'ข้าวผัดกะเพรา', 'ข้าวมันไก่', 'ข้าวผัดหมู', 'ข้าวผัดปู',
    'ข้าวหน้าเป็ด', 'ข้าวหมูกรอบ', 'ข้าวราดผัดพริกแกง', 'ข้าวไข่เจียว',
    'ข้าวผัดกุ้ง', 'ข้าวต้มหมู', 'ข้าวขาหมู', 'ข้าวหมูแดง',
    'ข้าวผัดอเมริกัน', 'ข้าวผัดน้ำพริก', 'ข้าวคลุกกะปิ'
  ],
  noodle: [
    'ก๋วยเตี๋ยวเรือ', 'บะหมี่เกี๊ยว', 'เย็นตาโฟ', 'ผัดซีอิ๊ว',
    'ราดหน้า', 'ก๋วยจั๊บ', 'เส้นหมี่หมูแดง', 'ผัดไทย', 'วุ้นเส้นผัดขี้เมา',
    'ก๋วยเตี๋ยวต้มยำ', 'บะหมี่หมูแดง', 'ก๋วยเตี๋ยวไก่ตุ๋น', 'ขนมจีนน้ำยา'
  ],
  drink: [
    'ชาเย็น', 'ชาเขียว', 'กาแฟเย็น', 'โอเลี้ยง',
    'โกโก้เย็น', 'น้ำแตงโม', 'น้ำส้มคั้น', 'น้ำมะพร้าว', 'นมสดเย็น',
    'น้ำมะนาว', 'ชามะนาว', 'น้ำผลไม้รวม', 'กาแฟโบราณ', 'น้ำกระเจี๊ยบ'
  ]
};

// 🎨 สร้างข้อมูลเมนูแบบสุ่ม
function generateMenuData() {
  const categories = ['rice', 'noodle', 'drink'];
  const category = faker.helpers.arrayElement(categories);
  
  // สุ่มชื่อเมนูจากหมวดหมู่
  const baseName = faker.helpers.arrayElement(THAI_MENUS[category]);
  
  // เพิ่มความหลากหลาย
  const variants = ['พิเศษ', 'ธรรมดา', 'จัมโบ้', 'เล็ก', 'กลาง', 'ใหญ่', ''];
  const variant = faker.helpers.arrayElement(variants);
  const name = variant ? `${baseName}${variant}` : baseName;
  
  // กำหนดช่วงราคาตามประเภท
  let priceRange;
  if (category === 'drink') {
    priceRange = { min: 20, max: 65 };
  } else if (category === 'noodle') {
    priceRange = { min: 35, max: 85 };
  } else {
    priceRange = { min: 40, max: 150 };
  }
  
  const price = faker.number.int(priceRange);
  const available = faker.datatype.boolean(0.85); // 85% มีพร้อมขาย
  
  // สร้าง URL รูปภาพจาก Lorem Picsum
  const imageUrl = `https://picsum.photos/seed/${faker.string.alphanumeric(10)}/800/600`;
  
  return { name, price, category, available, imageUrl };
}

//  ฟังก์ชันหลัก
async function main() {
  console.log('กำลังเชื่อมต่อ PocketBase...\n');
  
  try {
    await pb.admins.authWithPassword(ADMIN_EMAIL, ADMIN_PASS);
    console.log('เข้าสู่ระบบสำเร็จ!\n');
  } catch (err) {
    console.error(' เข้าสู่ระบบล้มเหลว:', err.message);
    console.error('กรุณาตรวจสอบ email และ password ของ Admin\n');
    return;
  }

  const totalMenus = 100;
  let successCount = 0;
  let errorCount = 0;

  console.log(`เริ่มสร้างเมนูจำนวน ${totalMenus} รายการ...\n`);
  console.log('─'.repeat(60));

  for (let i = 0; i < totalMenus; i++) {
    const menuData = generateMenuData();
    
    try {
      // ✅ ส่งข้อมูลไปยัง PocketBase (ชื่อฟิลด์ต้องตรงกับที่กำหนดใน PocketBase)
      await pb.collection('menus').create({
        Name: menuData.name,
        Price: menuData.price,
        Category: menuData.category,
        Available: menuData.available,
        ImageUrl: menuData.imageUrl,
      });
      
      successCount++;
      
      // แสดงความคืบหน้า
      const statusIcon = menuData.available ? '✅' : '⏸️';
      const categoryEmoji = 
        menuData.category === 'rice' ? '🍚' : 
        menuData.category === 'noodle' ? '🍜' : '🥤';
      
      console.log(
        `${statusIcon} [${successCount.toString().padStart(3)}/${totalMenus}] ` +
        `${categoryEmoji} ${menuData.name.padEnd(25)} | ` +
        `฿${menuData.price.toString().padStart(3)}`
      );
      
      // หน่วงเวลาเล็กน้อยเพื่อไม่ให้โหลด PocketBase มากเกินไป
      await new Promise(resolve => setTimeout(resolve, 50));
      
    } catch (err) {
      errorCount++;
      console.error(`❌ [ERROR] ${menuData.name}: ${err.message}`);
    }
  }

  console.log('─'.repeat(60));
  console.log(`\n🎉 เสร็จสิ้น!`);
  console.log(`   ✅ สำเร็จ: ${successCount} รายการ`);
  if (errorCount > 0) {
    console.log(`   ❌ ล้มเหลว: ${errorCount} รายการ`);
  }
  console.log('\n💡 คุณสามารถเข้าไปดูข้อมูลได้ที่: http://127.0.0.1:8090/_/');
}

// 🏃 รันโปรแกรม
main().catch(err => {
  console.error('\n💥 เกิดข้อผิดพลาดร้ายแรง:', err);
  process.exit(1);
});