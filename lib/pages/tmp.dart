import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../components/list/my_list_group.dart';
import '../models/transaction.dart';

class MyCalendarPageTmp extends StatefulWidget {
  const MyCalendarPageTmp({super.key});

  @override
  State<MyCalendarPageTmp> createState() => _MyCalendarPageTmpState();
}

class _MyCalendarPageTmpState extends State<MyCalendarPageTmp> {
  List<String> weekName = ["M", "T", "W", "T", "F", "S", "S"];
  List<String> monthName = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月", ];
  DateTime now = DateTime.now();

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
  }

  /// 依當前 [now] 更新 month_day1、last_month_day
  void updateDate() {
    month_day1 = DateTime(now.year, now.month, 1).weekday - 1;
    last_month_day = DateTime(now.year, now.month, 0).day;
  }

  (Color, Color) setItemColor(type, count) {
    Color back = context.myColor.item;
    Color number = Colors.black87;
    int i=0;

    for(var num in standard[type]) {
      if(count.abs() >= num) {
        back = (type == 0) ? context.myColor.cal_red[i] : context.myColor.cal_green[i];
        if(i>=1) number = Colors.white;
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

    return Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20, top: 90),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 45,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Text(now.day.toString(), style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(monthName[now.month - 1], style: TextStyle(color: context.myColor.hint2, fontSize: 18),),
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
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        decoration: BoxDecoration(
                            color: context.myColor.barGrey,
                            borderRadius: BorderRadius.circular(4)
                        ),
                      ),

                      Container(
                        width: (now.month != now_standard.month) ? 305 : (305/DateTime(now_standard.year, now_standard.month + 1, 0).day) * now_standard.day,
                        height: 6,
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        decoration: BoxDecoration(
                            color: context.myColor.red,
                            borderRadius: BorderRadius.circular(4)
                        ),
                      ),

                      Positioned(
                        top: 20,
                        left: 101.6,
                        child: Container(
                            width: 4,
                            height: 6,
                            color: context.myColor.barGrey
                        ),
                      ),

                      Positioned(
                        top: 20,
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

                  // 日曆部分
                  GridView.builder(
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
                            tmp = setItemColor(((count > 0) ? 1 : 0), count);
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
                ],
              ),
            ),

            SizedBox(height: 40,),

            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text("詳細資訊", style: TextStyle(fontSize: 14),),
            ),

            SizedBox(height: 12,),

            Expanded(
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: (context.expenseData.monthData[DateTime(now.year, now.month)]?[now.day-1] == null)
                        ? Container()
                        : AnimationLimiter(
                      // key: ValueKey(isSort),
                      child: (context.expenseData.monthData[DateTime(now.year, now.month)]?[now.day-1].items.length == 0)
                          ? Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 60),
                        child: Text("暫無資料", style: TextStyle(color: Colors.grey, fontSize: 12,)),
                      )
                          : ListView.builder(
                        // key: ValueKey("list_$isSort"),
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
            )
          ],
        )
    );
  }
}
