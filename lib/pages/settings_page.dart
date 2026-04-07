import 'package:exp02/components/tag/tags_page.dart';
import 'package:exp02/components/type_page.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MySettingPage extends StatefulWidget {
  const MySettingPage({super.key});

  @override
  State<MySettingPage> createState() => _MySettingPageState();
}

class _MySettingPageState extends State<MySettingPage> {
  final FocusNode _focusNodeGoal1 = FocusNode();
  final FocusNode _focusNodeGoal2 = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 初始賦值
    _controller.text = context.appSettingsAction.target.toInt().toString();
    _controller2.text = context.appSettingsAction.fixedIncome.toInt().toString();

    // 監聽目標金額 (Goal1)
    _focusNodeGoal1.addListener(() {
      if (!_focusNodeGoal1.hasFocus) { // 判斷自己失去焦點
        double val = double.tryParse(_controller.text) ?? 0.0;
        context.appSettingsAction.setTarget(val); // 存入目標金額
        print("目標金額: $val 已儲存");
      }
    });

    // 監聽固定收入 (Goal2)
    _focusNodeGoal2.addListener(() {
      if (!_focusNodeGoal2.hasFocus) { // 判斷自己失去焦點
        double val = double.tryParse(_controller2.text) ?? 0.0;
        context.appSettingsAction.setFixedIncome(val); // 存入固定收入
        print("每週固定收入: $val 已儲存");
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _focusNodeGoal1.dispose();
    _focusNodeGoal2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.myColor.grey,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20, top: 70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: context.myColor.item,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),

                SizedBox(width: 10,),

                Text("設定", style: TextStyle(color: Colors.black54, fontSize: 14),),
              ],
            ),

            SizedBox(height: 20,),

            Container(
              height: 45,
              width: 370,
              decoration: BoxDecoration(
                color: context.myColor.item,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.only(left: 17, right: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("目標金額", style: TextStyle(color: Colors.black87, fontSize: 16),),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.centerRight,
                        child: TextField(
                          controller: _controller,
                          textAlign: TextAlign.end,
                          cursorColor: Colors.grey,
                          style: TextStyle(color: Colors.black54,),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: "尚未設置 ",
                            hintStyle: TextStyle(color: context.myColor.hint, fontSize: 14,),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          focusNode: _focusNodeGoal1,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 6,),
            Container(
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "看你每週想存到多少錢^^",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
      
            SizedBox(height: 30,),
      
            Container(
              height: 151,
              width: 370,
              decoration: BoxDecoration(
                color: context.myColor.item,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.only(left: 17, right: 17),
              child: Column(
                children: [
                  SizedBox(height: 11,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("每週固定收入", style: TextStyle(color: Colors.black87, fontSize: 16),),
                      Container(
                        width: 100,
                        height: 30,
                        alignment: Alignment.centerRight,
                        child: TextField(
                          controller: _controller2,
                          textAlign: TextAlign.end,
                          cursorColor: Colors.grey,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(color: Colors.black54,),
                          decoration: InputDecoration(
                            hintText: "尚未設置 ",
                            hintStyle: TextStyle(color: context.myColor.hint, fontSize: 14,),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus(); // 收起鍵盤
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          focusNode: _focusNodeGoal2,
                        ),
                      ),
                    ],
                  ),
      
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: 360,
                      height: 0.4,
                      color: context.myColor.hint,
                    ),
                  ),
      
                  SizedBox(height: 12,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => MyTagManagePage())
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("標籤管理", style: TextStyle(color: Colors.black87, fontSize: 16),),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: context.myColor.hint,
                          ),
                        ],
                      ),
                    ),
                  ),
      
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: 360,
                      height: 0.4,
                      color: context.myColor.hint,
                    ),
                  ),
      
                  SizedBox(height: 12,),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => MyTypePage())
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("預設輸入項目名稱", style: TextStyle(color: Colors.black87, fontSize: 16),),
                          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: context.myColor.hint,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
