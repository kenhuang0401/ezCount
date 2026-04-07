import 'package:exp02/pages/calendar_page.dart';
import 'package:exp02/pages/home_page.dart';
import 'package:exp02/providers/color.dart';
import 'package:exp02/providers/expense.dart';
import 'package:exp02/providers/page.dart';
import 'package:exp02/providers/settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:exp02/utils/extension.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyColor()),
        ChangeNotifierProvider(create: (_) => PageIndex()),
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// 下方子頁面切換
class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    var now = context.pageIndex.currentPageIndex;
    
    return Scaffold(
      backgroundColor: context.myColor.grey,
      extendBody: true,
      body: PageView(
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(
            parent: PageScrollPhysics() // 這才是官方有捕捉效果的 Physics
        ),
        scrollDirection: Axis.horizontal,
        children: [
          MyExpensePage(),
          MyCalendarPage(),
        ],
      )
    );
  }
}
