import 'dart:math';

import 'package:exp02/components/bottom_sheet.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:path/path.dart';

import '../components/list/my_list_group.dart';
import '../models/transaction.dart';

class MyCalendarPage extends StatefulWidget {
  const MyCalendarPage({super.key});

  @override
  State<MyCalendarPage> createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> with SingleTickerProviderStateMixin {
  final List<String> monthName = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月", ];
  final List<String> weekName = ["M", "T", "W", "T", "F", "S", "S"];
  late AnimationController _controller;
  late Animation<double> _animation;
  DateTime now = DateTime.now();

  final double height = 220.0;
  final List<double> topC = [0.0, 0.0, 40.0, 90.0, 130.0, 180.0];
  final List<double> bottomC = [0.0, 180.0, 130.0, 90.0, 40.0, 00.0];
  bool _isClipped = false;
  int nowRowIndex = -1;


  /// 當月 1 號是星期幾（0=周一 … 6=周日），用於月曆前導空格
  late int month_day1;
  /// 上個月天數，用於月曆前導格顯示上月日期
  late int last_month_day;
  /// 系統當前日期，用於「今天」與月份切換上限
  final DateTime now_standard = DateTime.now();
  /// 日曆格色階門檻： [0]=支出色階, [1]=收入色階，每格四個門檻
  final List<List<double>> standard = [
    [50.0, 100.0, 150.0, 200.0],
    [100.0, 200.0, 300.0, 400.0]
  ];

  @override
  void initState() {
    super.initState();
    updateDate();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn
    );
  }

  void updateDate() {
    month_day1 = DateTime(now.year, now.month, 1).weekday - 1;
    last_month_day = DateTime(now.year, now.month, 0).day;
  }

  (Color, Color) setItemColor(type, count, myColor, bool isNow) {
    Color back = (isNow) ? Colors.black38 : myColor.item;
    Color number = (isNow) ? Colors.white : Colors.black87;
    int i=0;

    for(var num in standard[type]) {
      if(count.abs() >= num) {
        if(type == 0) {
          back = myColor.cal_red[i];
        }
        else myColor.cal_green[i];

        if(i>=1) number = Colors.white;
        else number = Colors.black87;
      }
      i++;
    }

    return (back, number);
  }

  @override
  Widget build(BuildContext context) {
    final tags = context.expenseData.monthData[DateTime(now.year, now.month)]?[now.day-1].getAllTags;
    final currentMonthDays = context.expenseData.monthData.isEmpty
        ? const <Day>[]
        : context.expenseData.monthData[DateTime(now.year, now.month)] ?? [];
    var tmp = context.myColor;

    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20, top: 50),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 0),
            child: Text(/*now.day.toString()*/"", style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  // 元件擺放方式
                  layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                    return Stack( // 固定靠左
                      alignment: Alignment.centerLeft,
                      children: [
                        ...previousChildren, // 新舊物件都丟到 stack
                        if (currentChild != null) currentChild, // 新元件存在，則丟到圖層最上面
                      ],
                    );
                  },
                  transitionBuilder: (child, animation) { // 設定變化過程動畫 -> 放大+模糊
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                        child: AnimatedBuilder(
                          animation: animation,
                          builder: (context, animChild) {
                            return ImageFiltered( // 透明的過渡
                              imageFilter: ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply
                              ),
                              child: child,
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: (!_isClipped)
                  ? Text(
                      "${now.month}月${now.day}日",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (_isClipped) {
                          _controller.reverse();
                          setState(() { _isClipped = false; });

                          _controller.reverse().then((_) {
                            if (mounted) {
                              setState(() {
                                nowRowIndex = -1;
                              });
                            }
                          });
                          _isClipped = false;
                        }
                      },
                      child: Container(
                        width: 75,
                        height: 30,
                        alignment: AlignmentGeometry.centerRight,
                        padding: const EdgeInsets.only(left: 8, right: 12),
                        decoration: BoxDecoration(
                          color: context.myColor.item,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.arrow_back_ios_new_outlined, size: 14,),
                            Text(
                              "${now.month}月",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                    ),
                  )
                )
              ),


              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final canGoPrev = (now.year > context.expenseData.firstDate.year) || (now.year == context.expenseData.firstDate.year && now.month > context.expenseData.firstDate.month);
                      if (canGoPrev) {
                        setState(() {
                          now = DateTime(now.year, now.month-1);
                          if(now.month == DateTime.now().month) now = DateTime(now.year, now.month, DateTime.now().day);
                          updateDate();
                        });
                      }
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: (now.month == context.expenseData.firstDate.month) ? context.myColor.cal_grey : context.myColor.item,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: (now.month == context.expenseData.firstDate.month) ? Colors.black38 : Colors.black,
                        size: 12,
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),

                  GestureDetector(
                    onTap: () {
                      final canGoNext = (now.year < now_standard.year) || (now.year == now_standard.year && now.month < now_standard.month);
                      if (canGoNext) {
                        setState(() {
                          now = DateTime(now.year, now.month+1);
                          if(now.month == DateTime.now().month) now = DateTime(now.year, now.month, DateTime.now().day);
                          updateDate();
                        });
                      }
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: (now.month == now_standard.month) ? context.myColor.cal_grey : context.myColor.item,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: (now.month == now_standard.month) ? Colors.black38 : Colors.black,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),

          Stack(
            children: [
              Container(
                width: 305,
                height: 6,
                margin: const EdgeInsets.only(top: 15, bottom: 10),
                decoration: BoxDecoration(
                    color: context.myColor.barGrey,
                    borderRadius: BorderRadius.circular(4)
                ),
              ),

              Container(
                width: (now.month != now_standard.month) ? 305 : (305/DateTime(now_standard.year, now_standard.month + 1, 0).day) * now_standard.day,
                height: 6,
                margin: const EdgeInsets.only(top: 15, bottom: 10),
                decoration: BoxDecoration(
                    color: context.myColor.red,
                    borderRadius: BorderRadius.circular(4)
                ),
              ),

              Positioned(
                top: 15,
                left: 101.6,
                child: Container(
                  width: 4,
                  height: 6,
                  color: context.myColor.barGrey
                ),
              ),

              Positioned(
                top: 15,
                left: 203.2,
                child: Container(
                    width: 4,
                    height: 6,
                    color: context.myColor.barGrey
                ),
              ),
            ],
          ),

          SizedBox(
            height: 40,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    weekName[index], // 星期標題列
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                );
              },
            ),
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              int idx = (nowRowIndex == -1) ? 0 : (nowRowIndex + 1).clamp(0, topC.length - 1);
              double topClip = topC[idx] * _animation.value;
              double bottomClip = bottomC[idx] * _animation.value;

              // 計算剩餘可見高度
              double currentHeight = height - (topClip + bottomClip);

              return ClipRect(
                child: SizedBox(
                  height: max(0, currentHeight),
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none, // 允許內容超出 Stack
                    children: [
                      Positioned(
                        // 關鍵：用負數 top 把內容往上拉，這會同步移動點擊區域
                        top: -topClip,
                        left: 0,
                        right: 0,
                        height: height, // 維持原始總高度
                        child: child!,
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: DateTime(now.year, now.month+1, 0).day + month_day1,
                    itemBuilder: (context, index) {
                      double count = 0.0;
                      (Color, Color) tmp = (context.myColor.item, Colors.black87);

                      if(currentMonthDays.isNotEmpty && index >= month_day1) {
                        DateTime time = DateTime(now.year, now.month, index+1-month_day1);
                        final dayIndex = time.day - 1;
                        final day = (dayIndex >= 0 && dayIndex < currentMonthDays.length)
                            ? currentMonthDays[dayIndex]
                            : null;

                        if (day != null) {
                          final a = day.totalIncome;
                          final b = day.totalExpense;
                          count = a - b;
                          tmp = setItemColor(((count > 0) ? 1 : 0), count, context.myColor, (now.day == (index+1-month_day1)));
                        }
                      }

                      return (index < month_day1) ?
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: context.myColor.cal_grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            (last_month_day + (index+1-month_day1)).toString(),
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ) :
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              now = DateTime(now.year, now.month, (index+1-month_day1));
                              if(nowRowIndex == index ~/ 7) return;

                              nowRowIndex = index ~/ 7; // 整除
                              _controller.forward();
                              _isClipped = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: tmp.$1,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              (index+1-month_day1).toString(),
                              style: TextStyle(
                                  color: tmp.$2,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        );
                    }
                ),
              ),
            ),
          ),

          // 下方元件
          SizedBox(height: 30,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("詳細資訊", style: TextStyle(fontSize: 14),),
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
                        return MyAddItemPage(type: "expense", onReturn: () {}, add_time: now,);
                      }
                  );
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: context.myColor.item,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  alignment: AlignmentGeometry.center,
                  child: Icon(Icons.add, size: 15,),
                ),
              )
            ]
          ),

          SizedBox(height: 12,),

          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: (context.expenseData.monthData[DateTime(now.year, now.month)]?[now.day-1] == null)
                ? Container()
                : AnimationLimiter(
                    key: ValueKey("list_01_${now.toIso8601String()}"),
                    child: (context.expenseData.monthData[DateTime(now.year, now.month)]?[now.day-1].items.length == 0)
                      ? Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(top: 60),
                          child: Text("暫無資料", style: TextStyle(color: Colors.grey, fontSize: 12,)),
                        )
                      : ListView.builder(
                          key: ValueKey("list_02_${now.toIso8601String()}"),
                          physics: const ClampingScrollPhysics(),
                          itemCount: tags!.length, // null則資料數為0
                          itemBuilder: (context, index) {
                            final nowDay = context.expenseData.monthData[DateTime(now.year, now.month)]?[now.day-1];
                            final tagName = tags[index];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: MyListGroupPage(tagName: tagName, today: nowDay!)
                                )
                              )
                            );
                          }
                        ),
                )
            )
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PreciseClipper extends CustomClipper<Rect> {
  final double progress;
  final double topClip;
  final double bottomClip;

  PreciseClipper(this.progress, this.topClip, this.bottomClip);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0,
      topClip * progress, // 上方裁切起點
      size.width,
      size.height - (bottomClip * progress), // 下方裁切終點
    );
  }

  @override
  bool shouldReclip(PreciseClipper oldClipper) => true;
}
