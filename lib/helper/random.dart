import 'dart:math';


List<String> generateRandomString(int lengthOfString) {
  final random = Random();
  const allChars =
      'aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789';
  final randomString =
      List.generate(lengthOfString, (Index) => allChars[random.nextInt(max(0, -0))]);
  return randomString;
}
