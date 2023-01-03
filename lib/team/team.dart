import 'package:flutter/material.dart';
import 'package:tangteevs/utils/color.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightOrange,
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'TERMS OF USE',
          style: TextStyle(
              fontSize: 38,
              color: purple,
              fontFamily: 'MyCustomFont',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        // alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                height: 500,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                ),
                child: const Text(
                  '\n บริษัท ตั้งตี้ จำกัด (“บริษัท”) ขอแนะนำให้ท่านทำความเข้าใจนโยบายส่วนบุคคล (privacy policy) นี้ เนื่องจาก นโยบายนี้อธิบายถึงวิธีการที่บริษัทปฏิบัติต่อข้อมูลส่วนบุคคลของท่าน เช่น การเก็บรวบรวม การจัดเก็บรักษา การใช้ การเปิดเผย รวมถึงสิทธิต่างๆ ของท่าน เป็นต้น  \n เพื่อให้ท่านได้รับทราบถึงนโยบายในการคุ้มครองข้อมูลส่วนบุคคลของบริษัท\n บริษัทตระหนักถึงความสำคัญของการปกป้องข้อมูลส่วนบุคคลของลูกค้า พนักงาน รวมตลอดถึงคู่ค้าของบริษัท ด้วยเหตุนี้บริษัทจึงได้จัดให้มีมาตรการในการเก็บรักษา และป้องกันตามมาตราฐานของกฎหมาย ข้อกำหนด และระเบียบเกี่ยวกับการคุ้มครองข้อมูลส่วนบุคคล อย่างเคร่งครัด ดังต่อไปนี้ ',
                  style: TextStyle(fontSize: 16, fontFamily: 'MyCustomFont'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
