import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Use'),
        centerTitle: true,
      ),
      body: Container(
        // alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8),
              Text(
                'บริษัท ตั้งตี้ จำกัด (“บริษัท”) ขอแนะนำให้ท่านทำความเข้าใจนโยบายส่วนบุคคล (privacy policy) นี้ เนื่องจาก นโยบายนี้อธิบายถึงวิธีการที่บริษัทปฏิบัติต่อข้อมูลส่วนบุคคลของท่าน เช่น การเก็บรวบรวม การจัดเก็บรักษา การใช้ การเปิดเผย รวมถึงสิทธิต่างๆ ของท่าน เป็นต้น เพื่อให้ท่านได้รับทราบถึงนโยบายในการคุ้มครองข้อมูลส่วนบุคคลของบริษัท บริษัทตระหนักถึงความสำคัญของการปกป้องข้อมูลส่วนบุคคลของลูกค้า พนักงาน รวมตลอดถึงคู่ค้าของบริษัท ด้วยเหตุนี้บริษัทจึงได้จัดให้มีมาตรการในการเก็บรักษา และป้องกันตามมาตราฐานของกฎหมาย ข้อกำหนด และระเบียบเกี่ยวกับการคุ้มครองข้อมูลส่วนบุคคล อย่างเคร่งครัด ดังต่อไปนี้ ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
