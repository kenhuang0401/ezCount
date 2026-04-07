import 'package:exp02/utils/extension.dart';
import 'package:flutter/material.dart';

class MyTagAddPage extends StatefulWidget {
  final String type;
  MyTagAddPage({super.key, required this.type});

  @override
  State<MyTagAddPage> createState() => _MyTagAddPageState();
}

class _MyTagAddPageState extends State<MyTagAddPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.myColor.grey,
      ),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 17, bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("新增標籤", style: TextStyle(color: Colors.black87, fontSize: 20,),),

          SizedBox(height: 14,),

          Container(
            height: 40,
            decoration: BoxDecoration(
              color: context.myColor.item,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: AlignmentGeometry.center,
            child: TextField(
              controller: _controller,
              cursorColor: Colors.black54,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "名稱",
                hintStyle: TextStyle(color: context.myColor.hint, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),

          SizedBox(height: 20,),

          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              onTap: () {
                if(_controller.text.isNotEmpty) {
                  if(widget.type == "expense") {
                    context.appSettingsAction.addTag("expense", _controller.text.toString());
                  }
                  else if(widget.type == "income"){
                    context.appSettingsAction.addTag("income", _controller.text.toString());
                  }
                  else {
                    context.appSettingsAction.addTypeAheadItem(_controller.text.toString());
                  }

                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                }
                else {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("尚未輸入項目名稱"),
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
                }
              },
              child: Container(
                width: 50,
                height: 30,
                decoration: BoxDecoration(
                  color: context.myColor.item,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: AlignmentGeometry.center,
                child: Text("儲存", style: TextStyle(fontSize: 12),),
              ),
            ),
          )
        ],
      ),
    );
  }
}
