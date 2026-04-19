import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TypeAheadItem {
  final String name;
  final Key key; // 使用 UniqueKey 確保絕對不重複
  TypeAheadItem(this.name) : key = UniqueKey();
}

class TagsItem {
  final String name;
  final Key key; // 使用 UniqueKey 確保絕對不重複
  TagsItem(this.name) : key = UniqueKey();
}

// 管理所有收入和支出標籤的資料庫
// 還有很多設定值
class AppSettings with ChangeNotifier {
  late List<TagsItem> _expenseTags = [];
  late List<TagsItem> _incomeTags = [];
  late List<TypeAheadItem> _typeAheadItems = [];
  late SharedPreferences _prefs;
  double _fixedIncome = 1000.0;
  double _target_Income = 300.0;

  List<TagsItem> get expenseTags => _expenseTags;
  List<TagsItem> get incomeTags => _incomeTags;
  List<TypeAheadItem> get typeAheadItems => _typeAheadItems;
  double get fixedIncome => _fixedIncome;
  double get target => _target_Income;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    var tmp = _prefs.getStringList('expense_tags') ?? ['伙食', '交通', '娛樂'];
    _expenseTags = tmp.map((name) => TagsItem(name)).toList();

    tmp = _prefs.getStringList('income_tags') ?? ['獎學金', '打工錢', '同學的施捨'];
    _incomeTags = tmp.map((name) => TagsItem(name)).toList();
    
    tmp = _prefs.getStringList('type_ahead_items') ?? [];
    _typeAheadItems = tmp.map((name) => TypeAheadItem(name)).toList();

    _fixedIncome = _prefs.getDouble('fixed_income') ?? 1000.0;
    _target_Income = _prefs.getDouble('target_income') ?? 300.0;

    // 初始化完也要通知，確保剛開 App 時 UI 能拿到正確資料
    notifyListeners();
  }

  // 抽離出更新方法，讓代碼乾淨點
  Future<void> _saveTags() async {
    await _prefs.setStringList('expense_tags', _expenseTags.map((x) => x.name).toList());
    await _prefs.setStringList('income_tags', _incomeTags.map((x) => x.name).toList());
    notifyListeners(); // 這裡通知，標籤列表才會更新
  }

  void addTag(String type, String tag) { // 修正參數語法
    if(type == "expense") {
      _expenseTags.add(TagsItem(tag));
    } else {
      _incomeTags.add(TagsItem(tag));
    }
    _saveTags(); // 儲存並通知
  }

  void insertTag(String type, int idx, String tag) { // 修正參數語法
    if(type == "expense") {
      _expenseTags.insert(idx, TagsItem(tag));
    } else {
      _incomeTags.insert(idx, TagsItem(tag));
    }
    _saveTags(); // 儲存並通知
  }

  void removeTag(String type, int index) {
    if(type == "expense") {
      _expenseTags.removeAt(index);
    } else {
      _incomeTags.removeAt(index);
    }
    _saveTags(); // 儲存並通知
  }

  String removeTagAt(String type, int idx) {
    if(type == "expense") {
      String tmp = _expenseTags.removeAt(idx).name;
      return tmp;
    } else {
      String tmp = _incomeTags.removeAt(idx).name;
      return tmp;
    }
    _saveTags(); // 儲存並通知
  }

  void addTypeAheadItem(String str) {
    _typeAheadItems.add(TypeAheadItem(str));
    notifyListeners();
    _saveTypeAheadToPrefs();
  }

  void removeTypeAheadItem(int index) {
    _typeAheadItems.removeAt(index);
    notifyListeners();
    _saveTypeAheadToPrefs();
  }

  Future<void> _saveTypeAheadToPrefs() async {
    List<String> nameList = _typeAheadItems.map((e) => e.name).toList();
    await _prefs.setStringList('type_ahead_items', nameList);
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