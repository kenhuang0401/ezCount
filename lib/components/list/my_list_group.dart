/// 依標籤分組的區塊：顯示標籤名稱與該標籤下的多筆 [MyListItemPage]
import 'package:exp02/components/list/my_list.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';
import '../../models/transaction.dart';

class MyListGroupPage extends StatefulWidget {
  final String tagName;
  final Day today;
  const MyListGroupPage({super.key, required this.tagName, required this.today});

  @override
  State<MyListGroupPage> createState() => _MyListGroupPageState();
}

class _MyListGroupPageState extends State<MyListGroupPage> {
  @override
  Widget build(BuildContext context) {
    List<TransactionItem> groupItem = widget.today.tagsOfItems(widget.tagName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.tagName ?? "null", style: TextStyle(color: context.myColor.text, fontSize: 14),),
          SizedBox(height: 6,),
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
