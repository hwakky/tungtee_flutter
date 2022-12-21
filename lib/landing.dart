import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tangteevs/widgets/custom_textfield.dart';
import 'team/team.dart';
import 'team/privacy.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 360,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/landing.png"), fit: BoxFit.fill)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/logo with name.png"),
          const Text.rich(TextSpan(
            text: "ไม่มีเพื่อนไปทำกิจกรรมอย่างงั้นหรอ?",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'MyCustomFont',
                fontWeight: FontWeight.bold),
          )),
          const Text.rich(TextSpan(
            text: "มาสิ เดี๋ยวพวกเราช่วยหาเพื่อนที่ชอบทำกิจกรรมเดียวกันให้",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'MyCustomFont',
                fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            height: 49,
            width: 600,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  minimumSize: const Size(307, 49),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: const Text(
                "login",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: mobileBackgroundColor,
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.purple,
                ),
                minimumSize: const Size(307, 49),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            child: const Text(
              "Create Account",
              style: TextStyle(color: Colors.purple, fontSize: 24),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/register');
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Text.rich(TextSpan(
            text: "การลงชื่อเข้าใช้แสดงว่าคุณยอมรับ",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'MyCustomFont',
            ),
          )),
          Text.rich(TextSpan(
            style: const TextStyle(
                color: Colors.black, fontSize: 12, fontFamily: 'MyCustomFont'),
            children: <TextSpan>[
              TextSpan(
                  text: " เงื่อนไขการใช้งาน",
                  style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      nextScreen(context, TermsPage());
                    }),
              TextSpan(
                  text: " และ ",
                  style: const TextStyle(
                      color: Colors.black, decoration: TextDecoration.none),
                  recognizer: TapGestureRecognizer()),
              TextSpan(
                  text: "นโยบายความเป็นส่วนตัวของเรา",
                  style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      nextScreen(context, PrivacyPage());
                    }),
            ],
          )),
        ],
      ),
    );
  }
}
