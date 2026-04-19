import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:exp02/components/bottom_sheet.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';

import 'my_income_list.dart';

class MyIncomePage extends StatefulWidget {
  const MyIncomePage({super.key});

  @override
  State<MyIncomePage> createState() => _MyIncomePageState();
}

class _MyIncomePageState extends State<MyIncomePage> {
  final PageController _controller = PageController(initialPage: 0);
  @override

  @override
  void dispose() {
    _controller.dispose(); // 記得銷毀控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _tags = context.appSettingsAction.incomeTags;
    final total = context.expenseData.incomeData.fold(0.0, (prv, x) => (prv += x.amount));

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 10, left: 0, right: 0),
      child: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    Align(
                      alignment: AlignmentGeometry.center,
                      child: Text(
                        "收入統計",
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                    ),

                    Align(
                      alignment: AlignmentGeometry.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          _controller.animateToPage(
                            1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: context.myColor.item,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 14,),
                        ),
                      )
                    )
                  ],
                ),

                SizedBox(height: 20,),

                Container(
                  width: 360,
                  height: 80,
                  decoration: BoxDecoration(
                    color: context.myColor.item,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 6,
                        left: 4,
                        child: Text(
                          "總收入",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      Positioned(
                        left: 4,
                        top: 35,
                        child: Text("從開始使用到現在的總收入 ^^", style: TextStyle(color: Colors.black54, fontSize: 12),),
                      ),

                      Positioned(
                        right: 5,
                        top: 15,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 700),
                          key: ValueKey<int>(context.expenseData.incomeData.length),
                          curve: Curves.easeOutExpo, // 動畫開始快 結尾慢
                          tween: Tween<double>(
                            begin: 0, // 初始值
                            end: total, // 目標值
                          ),
                          builder: (context, value, child) {
                            return Text("\$${value.toStringAsFixed(1)}", style: TextStyle(color: Colors.black87, fontSize: 24),);
                          },
                        )
                      ),
                    ],
                  )
                ),

                SizedBox(height: 30,),

                Text("詳細資訊", style: TextStyle(fontSize: 14),),
                SizedBox(height: 14,),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: AnimationLimiter(
                      // key: ValueKey(isWeekShow),
                      child: ListView.builder(
                        // key: ValueKey("list_$isWeekShow"),
                        itemCount: _tags.length,
                        itemBuilder: (context, index) {
                          String tagName = _tags[index].name;

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 600),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: MyIncomeListPage(tagName: tagName),
                              )
                            )
                          );
                        },
                      ),
                    )
                  )
                )
              ],
            ),
          ),

          MyAddItemPage(
            type: "income",
            onReturn: () {
              _controller.animateToPage(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            },
          )
        ],
      ),
    );
  }
}
