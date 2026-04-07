import 'package:exp02/providers/color.dart';
import 'package:exp02/providers/expense.dart';
import 'package:exp02/providers/page.dart';
import 'package:exp02/providers/settings.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension ProviderContext on BuildContext {
  // UI 渲染用: 監聽對象
  PageIndex get pageIndex => watch<PageIndex>();
  AppSettings get appSettings => watch<AppSettings>();
  ExpenseProvider get expenseData => watch<ExpenseProvider>();

  // 一次性實例: 不監聽
  // 用在 onPressed, initState 等場景
  MyColor get myColor => read<MyColor>();
  PageIndex get pageIndexAction => read<PageIndex>();
  AppSettings get appSettingsAction => read<AppSettings>();
  ExpenseProvider get expenseDataAction => read<ExpenseProvider>();
}