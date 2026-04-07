import 'package:exp02/components/list/my_list.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';
import '../../models/transaction.dart';

class MyWeekListPage extends StatefulWidget {
  final String tagName;
  final double total;
  const MyWeekListPage({super.key, required this.tagName, required this.total});

  @override
  State<MyWeekListPage> createState() => _MyWeekListPageState();
}

class _MyWeekListPageState extends State<MyWeekListPage> {
  @override
  Widget build(BuildContext context) {
    List<TransactionItem> groupItem = [];
    var week = context.expenseData.weekData;
    for(var day in week) {
      for(var item in day.items) {
        if(item.tags == widget.tagName) {
          groupItem.add(item);
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.tagName, style: TextStyle(color: context.myColor.text, fontSize: 14),),
              Text("\$${widget.total}", style: TextStyle(color: Color(0xFF505050), fontSize: 14),),
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
}
