import 'package:exp02/database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction.dart';

class ExpenseProvider with ChangeNotifier {
  Map<DateTime, List<Day>> _monthData = {};
  List<TransactionItem> _incomeData = [];
  DateTime _firstDate = DateTime.now();
  Map<String, double> _weekTags = {};
  List<Day> _weekData = [];
  double _totalCost = 0.0;
  Day? _nowData;

  Map<DateTime, List<Day>> get monthData => _monthData;
  List<TransactionItem> get incomeData => _incomeData;
  Map<String, double> get weekTags => _weekTags;
  DateTime get firstDate => _firstDate;
  List<Day> get weekData => _weekData;
  double? get totalCost => _totalCost;
  Day? get nowData => _nowData;

  final DatabaseHelper _helper = DatabaseHelper();

  // 取得所有資料，並依照月份分類存到 _monthData
  // 順便設定當日資料
  Future<void> setAllMonthData() async {
    _monthData.clear();
    _incomeData.clear();

    _firstDate = await _helper.getFirstTransactionDate() ?? DateTime.now();
    List<TransactionItem> allItems = await _helper.getAll();

    _ensureMonthExists(DateTime.now());

    for(var item in allItems) {
      if(item.type == "income") {
        _incomeData.add(item);
        continue;
      }

      _ensureMonthExists(item.date);

      try {
        _monthData[DateTime(item.date.year, item.date.month)]![item.date.day - 1].items.add(item);
      } catch(e) {
        print("error of getNotMonth");
      }
    }

    await getDayData();
    if(_totalCost == 0.0) _totalCost = _nowData!.items.fold(0, (prv, x) => (prv + x.amount));
    await getWeekData();

    notifyListeners();
    // print("ok");
  }

  void _ensureMonthExists(DateTime date) {
    DateTime monthKey = DateTime(date.year, date.month);
    if (!_monthData.containsKey(monthKey)) {
      _monthData[monthKey] = List.generate(
          DateTime(monthKey.year, monthKey.month + 1, 0).day,
          (idx) => Day(date: DateTime(monthKey.year, monthKey.month, idx + 1), items: [])
      );
    }
  }

  /// 取得今天的資料
  Future<void> getDayData() async {
    DateTime now = DateTime.now();
    _nowData = _monthData[DateTime(now.year, now.month)]?[now.day-1] ?? Day(date: now, items: []);
  }

  void updateWeekTags() {
    final Map<String, double> tagMap = {};
    for(var day in _weekData) {
      for(var item in day.items) {
        tagMap.update(
          item.tags,
          (value) => value + item.amount,
          ifAbsent: () => item.amount,
        );
      }
    }

    _weekTags = tagMap;
    /* for(var item in _weekData) {
      for(var item2 in item.items) {
        print("${item2.date} ${item2.amount}");
      }
    } */
  }

  /// 取得這週的資料
  Future<void> getWeekData() async {
    DateTime now = DateTime.now();
    DateTime monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    // DateTime nextMonday = monday.add(const Duration(days: 7));
    List<Day> tempWeek = [];

    for (int i = 0; i < 7; i++) {
      DateTime dayTarget = monday.add(Duration(days: i));
      DateTime monthKey = DateTime(dayTarget.year, dayTarget.month);

      if (_monthData.containsKey(monthKey)) {
        tempWeek.add(_monthData[monthKey]![dayTarget.day - 1]);
      }
    }

    _weekData = tempWeek;

    double tmp = 0.0;
    for(var day in _weekData) {
      tmp += day.items.fold(0, (prv, x) => (prv + x.amount));
    }
    _totalCost = tmp;

    updateWeekTags();
  }

  bool _isDataInThisWeek(DateTime time) {
    DateTime now = DateTime.now();
    DateTime monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    DateTime nextMonday = monday.add(const Duration(days: 7));

    return (time.isAtSameMomentAs(monday) || time.isAfter(monday)) && time.isBefore(nextMonday);
  }

  /// 新增資料至指定天數
  /// 如果新增日期剛好是今天，那就更新 _nowData
  Future<void> add(TransactionItem item) async {
    await _helper.insert(item);
    _ensureMonthExists(item.date);
    // _totalCost += item.amount;

    DateTime time = DateTime(item.date.year, item.date.month);
    _monthData[time]![item.date.day - 1].items.add(item);
    _monthData[time]![item.date.day - 1].items.sort(
      (a, b) => a.date.compareTo(b.date)
    );

    DateTime now = DateTime.now();
    if (item.date.year == now.year && item.date.month == now.month && item.date.day == now.day) {
      _nowData = _monthData[time]![item.date.day - 1];
    }

    if(_isDataInThisWeek(item.date)) {
      await getWeekData();
    }

    notifyListeners();
  }

  Future<void> modify(TransactionItem oldItem, TransactionItem newItem) async {
    await remove(oldItem);
    await add(newItem);
    notifyListeners();
  }

  /// 刪除一筆交易並刷新當日資料
  /// 如果刪除日期剛好是今天，那就更新 _nowData
  Future<void> remove(TransactionItem item) async {
    await _helper.delete(item);
    // _totalCost -= item.amount;

    DateTime time = DateTime(item.date.year, item.date.month);
    _monthData[time]![item.date.day - 1].items.remove(item);
    DateTime now = DateTime.now();
    if (item.date.year == now.year && item.date.month == now.month && item.date.day == now.day) {
      _nowData = _monthData[time]![item.date.day - 1];
    }

    if(_isDataInThisWeek(item.date)) {
      await getWeekData();
    }

    notifyListeners();
  }

  /// 清空資料庫所有交易並通知監聽者
  Future<void> clearAll() async {
    await _helper.clear();
    notifyListeners();
  }

  Future<void> addIncome(TransactionItem item) async {
    await _helper.insert(item);
    _incomeData.add(item);
    notifyListeners();
  }

  Future<void> removeIncome(TransactionItem item) async {
    await _helper.delete(item);
    _incomeData.remove(item);
    notifyListeners();
  }
}