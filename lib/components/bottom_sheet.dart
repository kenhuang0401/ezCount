/// 新增單筆收入／支出：名稱、金額、標籤，以 BottomSheet 呈現，送出後寫入 DB 並關閉
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';

class MyAddItemPage extends StatefulWidget {
  /// true=收入，false=支出（影響標籤選項與 type 欄位）
  final String type;
  final VoidCallback onReturn;
  TransactionItem? item = null;
  DateTime? add_time = null;

  MyAddItemPage({super.key, required this.type, required this.onReturn, this.item, this.add_time});

  @override
  State<MyAddItemPage> createState() => _MyAddItemPageState();
}

class _MyAddItemPageState extends State<MyAddItemPage> {
  final TextEditingController name_controller = TextEditingController();
  final TextEditingController amount_controller = TextEditingController();
  late String tags = (widget.type == "income")
    ? context.appSettingsAction.incomeTags[0]
    : context.appSettingsAction.expenseTags[0];

  /// 標籤下拉選單（依 isIncome 顯示收入或支出標籤）
  Widget selectMenu(String mode) {
    if(mode == "modify") mode = widget.item!.type;

    return PopupMenuButton(
      itemBuilder: (context) {
        if(mode == "income") {
          return context.appSettingsAction.incomeTags.map((x) {
            return PopupMenuItem(
              value: x,
              child: Text(x),
            );
          }).toList();
        }
        else if(mode == "expense") {
          return context.appSettingsAction.expenseTags.map((x) {
            return PopupMenuItem(
              value: x,
              child: Text(x),
            );
          }).toList();
        }
        else {
          return context.appSettingsAction.typeAheadItems.map((x) {
            return PopupMenuItem(
              value: x,
              child: Text(x),
            );
          }).toList();
        }
      },

      color: Colors.white,
      padding: EdgeInsets.zero,
      offset: const Offset(170, 50),
      icon: Icon(Icons.arrow_drop_down_outlined, color: context.myColor.hint,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onSelected: (value) {
        if(mode == "typeAhead") {
          setState(() {
            name_controller.text = value.toString();
          });
        }
        else {
          setState(() {
            tags = value.toString();
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.item != null) {
      name_controller.text = widget.item!.name.toString();
      amount_controller.text = widget.item!.amount.toString();
      tags = widget.item!.tags;
    }
  }

  @override
  void dispose() {
    name_controller.dispose();
    amount_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var expense_data = Provider.of<ExpenseProvider>(context);
    String type = "新增支出";
    if(widget.type == "income") type = "新增收入";
    else if(widget.type == "modify") type = "修改資料";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (widget.type == "income") ? widget.onReturn : () { Navigator.pop(context); },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 16,),
                  ),
                ),

                Text("${type}",style: TextStyle(fontSize: 16)),

                GestureDetector(
                  onTap: () async {
                    if (name_controller.text.isEmpty || amount_controller.text.isEmpty) {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("尚未輸入項目名稱或價格"),
                          backgroundColor: context.myColor.red,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(
                            bottom: 10,
                            left: 10,
                            right: 10,
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    DateTime time = DateTime.now();
                    if(widget.type == "modify") time = widget.item!.date;
                    else if(widget.add_time != null) time = DateTime(widget.add_time!.year, widget.add_time!.month, widget.add_time!.day);

                    final item = TransactionItem(
                      name: name_controller.text,
                      amount: double.parse(amount_controller.text),
                      type: (widget.type == "modify") ? widget.item!.type : widget.type,
                      tags: tags,
                      date: time,
                    );

                    if (widget.type == "income") {
                      await context.expenseDataAction.addIncome(item);
                    }
                    else if(widget.type == "expense") {
                      await context.expenseDataAction.add(item);
                    }
                    else if(widget.type == "modify") {
                      await context.expenseDataAction.modify(widget.item!, item);
                    }

                    FocusScope.of(context).unfocus();

                    if (widget.type == "income") widget.onReturn();
                    else if (context.mounted) Navigator.pop(context); // 關閉 BottomSheet
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: context.myColor.item,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Icon(Icons.check, color: Colors.black, size: 20,),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16,),

            // 名稱與金額輸入區
            Container(
              height: 100,
              width: 370,
              decoration: BoxDecoration(
                color: context.myColor.item,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.only(left: 17, right: 10, top: 3),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: name_controller,
                            cursorColor: Colors.black54,
                            decoration: InputDecoration(
                              hintText: "名稱",
                              hintStyle: TextStyle(color: context.myColor.hint, fontSize: 16),
                              border: InputBorder.none
                            ),
                          ),
                        ),
                      ),

                      if(widget.type != "income")
                        Container(
                          width: 26,
                          height: 26,
                          child: selectMenu("typeAhead")
                        ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 360,
                      height: 1,
                      color: context.myColor.hint,
                    ),
                  ),

                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: amount_controller,
                      cursorColor: Colors.black54,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          hintText: "價格",
                          hintStyle: TextStyle(color: context.myColor.hint, fontSize: 16),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16,),

            // 標籤選擇列
            Container(
              height: 45,
              width: 370,
              decoration: BoxDecoration(
                color: context.myColor.item,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.only(left: 17, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("標籤", style: TextStyle(color: Colors.black87, fontSize: 16),),
                  Row(
                    children: [
                      Text(tags, style: TextStyle(color: context.myColor.hint),),
                      Container(
                        width: 26,
                        height: 26,
                        child: selectMenu(widget.type)
                      ),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 16,),

            // 時間顯示列（目前固定為當下時間，不可編輯）
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
                  Text("時間", style: TextStyle(color: Colors.black87, fontSize: 16),),
                  Text(((widget.add_time != null) ? widget.add_time : DateTime.now()).toString().substring(0,16), style: TextStyle(color: Colors.black87, fontSize: 16),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
