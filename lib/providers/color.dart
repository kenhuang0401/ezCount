import 'package:flutter/material.dart';

class MyColor extends ChangeNotifier{
  final Color item = Color(0xFFFAFAFA);
  final Color grey = Color(0xFFEBEBEB);
  final Color cal_grey = Color(0xFFF1F1F1);
  final Color any_item = Color(0xFFF4F4F4);
  final Color item_grey = Color(0xFFEDEDED);
  final Color barGrey = Color(0xFFDCDCDC);
  final Color hint = Color(0xFFB7B7B7);
  final Color hint2 = Color(0xFF9F9F9F);
  final Color text = Color(0xFF909090);
  final Color barGrey2 = Color(0xFF616161);
  final Color red = Color(0xFFE57373);
  final Color green = Color(0xFF66bb6a);
  final Color blue = Color(0xFF64b5f6);

  final List<Color> cal_red = [
    Color(0xFFffcdd2),
    Color(0xFFef9a9a),
    Color(0xFFe57373),
    Color(0xFFef5350)
  ];
  final List<Color> cal_red_grey_bg = [
    Color(0xFF8C3E42), // 色階 1 (最輕): 帶灰調的乾枯玫瑰 (在灰色上很優雅)
    Color(0xFFB74146), // 色階 2: 中度磚紅
    Color(0xFFD84349), // 色階 3: 強烈珊瑚紅
    Color(0xFFFF5252), // 色階 4 (最重): 明亮霓虹紅 (保證最後一個色階絕對跳出來)
  ];
  final List<Color> cal_green = [
    Color(0xFFc8e6c9),
    Color(0xFFa5d6a7),
    Color(0xFF81c784),
    Color(0xFF66bb6a)
  ];
}