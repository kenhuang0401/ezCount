import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 管理所有收入和支出標籤的資料庫
// 還有很多設定值
class AppSettings with ChangeNotifier {
  late List<String> _expenseTags = [];
  late List<String> _incomeTags = [];
  late List<String> _typeAheadItems = [];
  late SharedPreferences _prefs;
  double _fixedIncome = 1000.0;
  double _target_Income = 300.0;

  List<String> get expenseTags => _expenseTags;
  List<String> get incomeTags => _incomeTags;
  List<String> get typeAheadItems => _typeAheadItems;
  double get fixedIncome => _fixedIncome;
  double get target => _target_Income;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _expenseTags = _prefs.getStringList('expense_tags') ?? ['伙食', '交通', '娛樂'];
    _incomeTags = _prefs.getStringList('income_tags') ?? ['獎學金', '打工錢', '同學的施捨'];
    _typeAheadItems = _prefs.getStringList('type_ahead_items') ?? [];
    _fixedIncome = _prefs.getDouble('fixed_income') ?? 1000.0;
    _target_Income = _prefs.getDouble('target_income') ?? 300.0;

    // 初始化完也要通知，確保剛開 App 時 UI 能拿到正確資料
    notifyListeners();
  }

  // 抽離出更新方法，讓代碼乾淨點
  Future<void> _saveTags() async {
    await _prefs.setStringList('expense_tags', _expenseTags);
    await _prefs.setStringList('income_tags', _incomeTags);
    notifyListeners(); // 這裡通知，標籤列表才會更新
  }

  void addTag(String type, String tag) { // 修正參數語法
    if(type == "expense") {
      _expenseTags.add(tag);
    } else {
      _incomeTags.add(tag);
    }
    _saveTags(); // 儲存並通知
  }

  void insertTag(String type, int idx, String tag) { // 修正參數語法
    if(type == "expense") {
      _expenseTags.insert(idx, tag);
    } else {
      _incomeTags.insert(idx, tag);
    }
    _saveTags(); // 儲存並通知
  }

  void removeTag(String type, String tag) {
    if(type == "expense") {
      _expenseTags.remove(tag);
    } else {
      _incomeTags.remove(tag);
    }
    _saveTags(); // 儲存並通知
  }

  String removeTagAt(String type, int idx) {
    if(type == "expense") {
      String tmp = _expenseTags.removeAt(idx);
      return tmp;
    } else {
      String tmp = _incomeTags.removeAt(idx);
      return tmp;
    }
    _saveTags(); // 儲存並通知
  }

  Future<void> addTypeAheadItem(String str) async {
    _typeAheadItems.add(str);
    await _prefs.setStringList('type_ahead_items', _typeAheadItems);
    notifyListeners();
  }

  Future<void> removeTypeAheadItem(String str) async {
    _typeAheadItems.remove(str);
    await _prefs.setStringList('type_ahead_items', _typeAheadItems);
    notifyListeners();
  }

  Future<void> setTarget(double num) async {
    _target_Income = num;
    await _prefs.setDouble('target_income', _target_Income);
    notifyListeners(); // 關鍵：通知主頁面目標金額變了
  }

  Future<void> setFixedIncome(double num) async {
    _fixedIncome = num;
    await _prefs.setDouble('fixed_income', _fixedIncome);
    notifyListeners();
  }
}