import 'package:exp02/components/income/income_page.dart';
import 'package:exp02/components/list/my_week_list.dart';
import 'package:exp02/pages/settings_page.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../components/bottom_sheet.dart';
import '../components/list/my_list.dart';
import '../components/list/my_list_group.dart';

class MyExpensePage extends StatefulWidget {
  const MyExpensePage({super.key});

  @override
  State<MyExpensePage> createState() => _MyExpensePageState();
}

class _MyExpensePageState extends State<MyExpensePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isWeekShow = false;
  bool isSort = false;

  @override
  void initState() {
    super.initState();
    getData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getData() async {
    await Future.microtask(() => context.expenseDataAction.setAllMonthData());
    await Future.microtask(() => context.appSettingsAction.init());
  }

  @override
  Widget build(BuildContext context) {
    final tags = context.expenseData.nowData?.getAllTags ?? const <String>[];
    final tagMap = context.expenseData.weekTags;
    final sortedTags = tagMap.keys.toList();
    sortedTags.sort((a, b) => tagMap[b]!.compareTo(tagMap[a]!));


    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 74),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 頂部標題列（左：返回＋「記帳」、右：設定圖示）
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if(_controller.isCompleted) {
                          _controller.reverse();
                          setState(() { isWeekShow = false; });
                        }
                        else {
                          _controller.forward();
                          setState(() { isWeekShow = true; });
                        }
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: context.myColor.item,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 1, end: 1.3).animate(_animation),
                          child: RotationTransition(
                            turns: _animation,
                            child: Icon(Icons.cached, color: Colors.black, size: 16,),
                          ),
                        )
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Text(
                    (isWeekShow) ? "本週統計" : "本日統計",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MySettingPage()),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: context.myColor.item,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Icon(Icons.settings, color: Colors.black, size: 16,),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10,),

          // 當日剩餘金額卡片（收入－支出）
          Container(
            width: 360,
            height: 191,
            decoration: BoxDecoration(
              color: context.myColor.item,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("剩餘金額", style: TextStyle(color: context.myColor.text, fontSize: 12),),
                /*
                // 需要先 import 'package:intl/intl.dart';
                final formatter = NumberFormat("#,###");

                // 在 builder 內使用
                Text("\$${formatter.format(value.toInt())}", ...)
                */
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 700),
                  key: ValueKey("${isWeekShow}_${context.appSettings.fixedIncome}_${context.expenseData.totalCost}"),
                  curve: Curves.easeOutExpo, // 動畫開始快 結尾慢
                  tween: Tween<double>(
                    begin: 0, // 初始值
                    end: context.expenseData.totalCost, // 目標值
                  ),
                  builder: (context, value, child) {
                    return Text(
                      "\$${(context.appSettings.fixedIncome - value).toStringAsFixed(1)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          SizedBox(height: 14,),

          // 新增收入／支出按鈕區
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 168,
                height: 87,
                decoration: BoxDecoration(
                  color: context.myColor.item,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.only(left: 18),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (isWeekShow) ? "最高單筆支出" : "今日支出",
                          style: TextStyle(
                            color: context.myColor.text,
                            fontSize: 13
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TweenAnimationBuilder<double>(
                              key: ValueKey<bool>(isWeekShow),
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeOutExpo,
                              tween: Tween<double>(
                                begin: 0,
                                end: context.expenseData.nowData?.totalExpense ?? 0.0,
                              ),
                              builder: (context, value, child) {
                                return Text(
                                  "\$${value.toStringAsFixed(1)}",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: 150,
                height: 87,
                decoration: BoxDecoration(
                  color: context.myColor.item,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child,);
                    },
                    child: (isWeekShow)
                      ? Row(
                          key: const ValueKey("week_icons"),
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: context.myColor.item_grey,
                                    borderRadius: BorderRadius.circular(1000),
                                  ),
                                  child: Icon(Icons.arrow_upward, color: Colors.black26, size: 20,),
                                ),
                                SizedBox(height: 2,),
                                Text("收入", style: TextStyle(fontSize: 12, color: Colors.black26,)),
                              ],
                            ),

                            SizedBox(width: 20,),

                            Column(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: context.myColor.item_grey,
                                    borderRadius: BorderRadius.circular(1000),
                                  ),
                                  child: Icon(Icons.arrow_downward, color: Colors.black26, size: 20,),
                                ),
                                SizedBox(height: 2,),
                                Text("支出", style: TextStyle(fontSize: 12, color: Colors.black26,)),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          key: const ValueKey("day_icons"),
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 新增收入：開啟 BottomSheet 輸入
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40.0),
                                      topRight: Radius.circular(40.0),
                                    )
                                  ),
                                  backgroundColor: context.myColor.grey,
                                  scrollControlDisabledMaxHeightRatio: 0.8,
                                  builder: (context) {
                                    return MyIncomePage();
                                  }
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: context.myColor.item_grey,
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    child: Icon(Icons.arrow_upward, color: Colors.black, size: 20,),
                                  ),
                                  SizedBox(height: 2,),
                                  Text("收入", style: TextStyle(fontSize: 12, color: context.myColor.text,)),
                                ],
                              ),
                            ),

                            SizedBox(width: 20,),

                            // 新增支出：開啟 BottomSheet 輸入
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40.0),
                                        topRight: Radius.circular(40.0),
                                      )
                                    ),
                                    backgroundColor: context.myColor.grey,
                                    scrollControlDisabledMaxHeightRatio: 0.8,
                                    builder: (context) {
                                      return MyAddItemPage(type: "expense", onReturn: () {},);
                                    }
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: context.myColor.item_grey,
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    child: Icon(Icons.arrow_downward, color: Colors.black, size: 20,),
                                  ),
                                  SizedBox(height: 2,),
                                  Text("支出", style: TextStyle(fontSize: 12, color: context.myColor.text,)),
                                ],
                              ),
                            ),
                          ],
                        ),
                  )
                ),
              ),
            ],
          ),

          SizedBox(height: 30,),

          // 「詳細資訊」標題與「分類」切換鈕
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("詳細資訊", style: TextStyle(fontSize: 14),),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child,);
                },
                child: (isWeekShow)
                ? Container(
                    width: 55,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Center(child: Text("分類", style: TextStyle(fontSize: 11, color: Colors.black26),)),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        isSort = !isSort;
                      });
                    },
                    child: Container(
                      width: 55,
                      height: 25,
                      decoration: BoxDecoration(
                        color: isSort ? Color(0xBBCACACA) : context.myColor.item,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: Center(child: Text("分類", style: TextStyle(fontSize: 11),)),
                    ),
                  ),
              ),

            ],
          ),

          SizedBox(height: 14,),

          // 當日明細列表（依 isSort 顯示單一列表或依 tag 分組）
          if(isWeekShow)
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: AnimationLimiter(
                  key: ValueKey(isWeekShow),
                  child: ListView.builder(
                    key: ValueKey("list_$isWeekShow"),
                    itemCount: sortedTags.length,
                    itemBuilder: (context, index) {
                      String tagName = sortedTags[index];
                      double total = tagMap[tagName]!;

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 600),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: MyWeekListPage(tagName: tagName, total: total),
                          )
                        )
                      );
                    },
                  ),
                )
              )
            )
          else
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: (context.expenseData.nowData == null)
                  ? Container()
                  : AnimationLimiter(
                      key: ValueKey(isSort),
                      child: ListView.builder(
                        key: ValueKey("list_$isSort"),
                        itemCount: (!isSort) ? (context.expenseData.nowData?.items.length ?? 0) : tags.length, // null則資料數為0
                        itemBuilder: (context, index) {
                          final item = (!isSort) ? context.expenseData.nowData!.items[index] : null;
                          final tagName = isSort ? tags[index] : null;

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: (!isSort)
                                  ? MyListItemPage(item: item!)
                                  : MyListGroupPage(tagName: tagName!, today: context.expenseData.nowData!)
                              )
                            )
                          );
                        }
                      ),
                  )
                )
            )
        ],
      ),
    );
  }
}

