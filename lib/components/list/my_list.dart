/// 單筆收支列表項：顯示名稱、金額、收入/支出圖示，左滑可刪除（Dismissible）
import 'package:exp02/components/bottom_sheet.dart';
import 'package:exp02/models/transaction.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyListItemPage extends StatefulWidget {
  final TransactionItem item;
  const MyListItemPage({super.key, required this.item});

  @override
  State<MyListItemPage> createState() => _MyListItemPageState();
}

class _MyListItemPageState extends State<MyListItemPage> {
  bool isPressed = false;

  String get formattedTime {
    final d = widget.item.date;
    // 補零邏輯
    String m = d.month.toString().padLeft(2, '0');
    String day = d.day.toString().padLeft(2, '0');
    String h = d.hour.toString().padLeft(2, '0');
    String min = d.minute.toString().padLeft(2, '0');
    return "$m/$day $h:$min";
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: Key(widget.item.id?.toString() ?? '${widget.item.name}_${widget.item.date.millisecondsSinceEpoch}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          if(widget.item.type == "expense") context.expenseDataAction.remove(widget.item);
          else context.expenseDataAction.removeIncome(widget.item);
        },
        child: GestureDetector(
          onTapUp: (d) => setState(() => isPressed = false),
          onTapDown: (d) => setState(() => isPressed = true),
          onTapCancel: () => setState(() => isPressed = false),
          onDoubleTap: () {
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
                return MyAddItemPage(type: "modify", onReturn: () {}, item: widget.item,);
              }
            );
          },
          child: AnimatedContainer(
            height: 50,
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: isPressed ? context.myColor.item.withOpacity(0.7) : context.myColor.item,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              visualDensity: VisualDensity(vertical: -4),
              leading: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: context.myColor.grey,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Icon((widget.item.type == "income" ? Icons.arrow_upward : Icons.arrow_downward), size: 16,),
              ),
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Row(
                  key: ValueKey<bool>(isPressed), // 關鍵：讓切換生效
                  children: [
                    Text(
                      widget.item.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    if (isPressed) ...[
                      const SizedBox(width: 8),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.myColor.hint, // 使用較淡的顏色
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing: Text(
                (widget.item.type == "expense") ? '-NT\$${widget.item.amount}' : '+NT\$${widget.item.amount}',
                style: TextStyle(
                    fontSize: 14,
                    color: context.myColor.text
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
