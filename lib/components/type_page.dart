import 'package:flutter/material.dart';

import 'package:exp02/components/tag/tag_list.dart';
import 'package:exp02/components/tag/tag_dialog.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';

class MyTypePage extends StatefulWidget {
  const MyTypePage({super.key});

  @override
  State<MyTypePage> createState() => _MyTypePageState();
}

class _MyTypePageState extends State<MyTypePage> {

  @override
  Widget build(BuildContext context) {
    // print(context.appSettingsAction.typeAheadItems);

    return Material(
      color: context.myColor.grey,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20, top: 70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: context.myColor.item,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),

                SizedBox(width: 15,),

                Text("設定預輸入項目", style: TextStyle(color: Colors.black54, fontSize: 13),),
              ],
            ),

            SizedBox(height: 20,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(" 預輸入項目", style: TextStyle(color: context.myColor.text, fontSize: 16),),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: MyTagAddPage(type: "typeAhead")
                              );
                            }
                        );
                        setState(() {});
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
                  ],
                ),
                SizedBox(height: 12,),
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: context.appSettingsAction.typeAheadItems.length,
                  proxyDecorator: (Widget child, int index, Animation<double> animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget? child) {
                        return Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                          child: child,
                        );
                      },
                      child: child,
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }

                      final String item = context.appSettingsAction.removeTagAt("income", oldIndex);
                      context.appSettingsAction.insertTag("income", newIndex, item);
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var tagName = context.appSettingsAction.typeAheadItems[index];

                    return Padding(
                      key: ValueKey('tag_income_padding_$tagName'),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Dismissible(
                        key: ValueKey('income_${tagName}_$index'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          setState(() {
                            context.appSettingsAction.removeTypeAheadItem(tagName);
                          });
                        },
                        child: MyTagItemPage(
                            item: context.appSettingsAction.typeAheadItems[index],
                            index: index
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
