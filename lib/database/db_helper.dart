/// SQLite 資料庫操作封裝

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:exp02/models/transaction.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper._internal();

  /// 取得資料庫實例（若尚未建立則執行 _initDatabase）
  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  /// 建立資料庫與 transactions 表（id, name, amount, type, tags, date）
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            amount REAL,
            type TEXT,
            tags TEXT,
            date TEXT
          )
        """);
      },
    );
  }

  /// 新增一筆收支紀錄，回傳插入的 row id
  Future<int> insert(TransactionItem item) async {
    var db = await database;
    return await db.insert('transactions', item.toMap());
  }

  /// 修改一筆資料
  Future<int> update(TransactionItem item) async {
    var db = await database;

    return await db.update(
      'transactions',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }


  /// 刪除一筆紀錄
  Future<int> delete(TransactionItem item) async {
    var db = await database;
    if (item.id != null) {
      return await db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [item.id],
      );
    }
    return await db.delete(
        'transactions',
        where: 'name = ? AND amount = ? AND date = ? AND type = ?',
        whereArgs: [item.name, item.amount, item.date.toIso8601String(), item.type]
    );
  }

  /// 清空 transactions 表內所有資料
  Future<void> clear() async {
    var db = await database;
    await db.delete('transactions');
  }

  /// 取得全表最早一筆交易的日期，供日曆起始月使用
  Future<DateTime?> getFirstTransactionDate() async {
    var db = await database;
    List<Map<String, dynamic>> mp = await db.query(
      'transactions',
      orderBy: "date ASC",
      limit: 1,
    );

    if(mp.isNotEmpty) return DateTime.parse(mp.first['date']);
    else return null;
  }

  /// 取得所有交易紀錄
  Future<List<TransactionItem>> getAll() async {
    var db = await database;
    List<Map<String, dynamic>> mp = await db.query(
      'transactions',
      orderBy: "date ASC",
    );
    return List.generate(mp.length, (x) => TransactionItem.fromMap(mp[x]));
  }
}