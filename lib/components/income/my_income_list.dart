import 'package:exp02/components/list/my_list.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';
import '../../../models/transaction.dart';

class MyIncomeListPage extends StatefulWidget {
  final String tagName;
  const MyIncomeListPage({super.key, required this.tagName});

  @override
  State<MyIncomeListPage> createState() => _MyIncomeListPageState();
}

class _MyIncomeListPageState extends State<MyIncomeListPage> {
  @override
  Widget build(BuildContext context) {
    List<TransactionItem> groupItem = [];
    double total = 0.0;

    var items = context.expenseData.incomeData;
    for(var item in items) {
      if(item.tags == widget.tagName) {
        groupItem.add(item);
        total += item.amount;
      }
    }


    if(groupItem.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.tagName, style: TextStyle(color: context.myColor.text, fontSize: 14),),
                Text("\$${total}", style: TextStyle(color: Color(0xFF505050), fontSize: 14),),
              ],
            ),

            SizedBox(height: 8,),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: groupItem.length,
                itemBuilder: (context, index) {
                  return MyListItemPage(item: groupItem[index]);
                }
            )
          ],
        ),
      );
    }
    else {
      return Container();
    }
  }
}
