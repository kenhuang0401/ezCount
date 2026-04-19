import 'package:exp02/components/tag/tag_list.dart';
import 'package:exp02/components/tag/tag_dialog.dart';
import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';

class MyTagManagePage extends StatefulWidget {
  const MyTagManagePage({super.key});

  @override
  State<MyTagManagePage> createState() => _MyTagManagePageState();
}

class _MyTagManagePageState extends State<MyTagManagePage> {

  @override
  Widget build(BuildContext context) {
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

                SizedBox(width: 10,),

                Text("標籤管理", style: TextStyle(color: Colors.black54, fontSize: 14),),
              ],
            ),

            SizedBox(height: 20,),

            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(" 支出", style: TextStyle(color: context.myColor.text, fontSize: 16),),
                          GestureDetector(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: MyTagAddPage(type: "expense")
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
                      SizedBox(height: 8,),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: context.appSettingsAction.expenseTags.length,
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

                            final String item = context.appSettingsAction.removeTagAt("expense", oldIndex);
                            context.appSettingsAction.insertTag("expense", newIndex, item);
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          var tagItem = context.appSettingsAction.expenseTags[index];

                          return Padding(
                            key: tagItem.key,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Dismissible(
                              key: ValueKey('expense_${tagItem.key}'),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                setState(() {
                                  context.appSettingsAction.removeTag("expense", index);
                                });
                              },
                              child: MyTagItemPage(
                                item: tagItem.name,
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(" 收入", style: TextStyle(color: context.myColor.text, fontSize: 16),),
                          GestureDetector(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: MyTagAddPage(type: "income")
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
                      SizedBox(height: 8,),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: context.appSettingsAction.incomeTags.length,
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
                          var tagItem = context.appSettingsAction.incomeTags[index];

                          return Padding(
                            key: tagItem.key,
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Dismissible(
                              key: ValueKey('income_${tagItem.key}'),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                setState(() {
                                  context.appSettingsAction.removeTag("income", index);
                                });
                              },
                              child: MyTagItemPage(
                                  item: tagItem.name,
                                  index: index
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
