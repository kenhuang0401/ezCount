
import 'package:exp02/models/transaction.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';

class MyTagItemPage extends StatefulWidget {
  final String item;
  final int index;
  const MyTagItemPage({super.key, required this.item, required this.index});

  @override
  State<MyTagItemPage> createState() => _MyTagItemPageState();
}

class _MyTagItemPageState extends State<MyTagItemPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.myColor.item,
        borderRadius: BorderRadius.circular(10)
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
          child: Icon(Icons.tag, size: 16,),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Row(
            children: [
              Text(
                widget.item,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
