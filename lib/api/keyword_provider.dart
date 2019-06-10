import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String path = "chp_app_keyword";
final String tableKeyword = "keyword";
final String columnId = "_id";
final String columnTitle = "title";
final String columnDate = "datetime";
final String columnSort = "sort"; //1 搜索历史 2 城市
final String columnDone = "done";

class Keyword {
  Keyword();

  Keyword.fromMap(Map map) {
    id = map[columnId] as int;
    title = map[columnTitle] as String;
    sort = map[columnSort] as int;
    dateTime = map[columnDate] as int;
    done = map[columnDone] == 1;
  }

  int id;
  String title;
  int sort;
  int dateTime;
  bool done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnSort: sort,
      columnDate: dateTime,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class KeywordProvider {
  Database db;

  Future open() async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableKeyword ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnSort integer not null,
  $columnDate intteger not null,
  $columnDone integer not null)
''');
    });
  }

  Future<Keyword> insert(Keyword keyword) async {
    Keyword k = await getKeyword(keyword.title, keyword.sort);
    if (k == null) {
      keyword.id = await db.insert(tableKeyword, keyword.toMap());
      return keyword;
    } else {
      int i = await db.update(tableKeyword, keyword.toMap(),
          where: "$columnId = ?", whereArgs: [keyword.id]);
      return keyword;
    }
  }

  Future<List<Keyword>> getKeywords(int sort) async {
    List<Map> maps = await db.query(tableKeyword,
        distinct: true,
        columns: [columnTitle, columnSort],
        where: "$columnSort = ? order by $columnDate desc",
        whereArgs: [sort]);
//    List<Map> maps = await db.rawQuery(
//        'select distinct "$columnTitle", "$columnSort" from "$tableKeyword" where "$columnSort" = $sort order by "$columnDate" desc');
    return maps.map((m) {
      return Keyword.fromMap(m);
    }).toList();
  }

  Future<Keyword> getKeyword(String title, int sort) async {
    List<Map> maps = await db.query(tableKeyword,
        columns: [columnId, columnDone, columnTitle, columnSort, columnDate],
        where: "$columnTitle = ? and $columnSort = ?",
        whereArgs: [title, sort]);
    if (maps.length > 0) {
      return Keyword.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int sort) async {
    return await db
        .delete(tableKeyword, where: "$columnSort = ?", whereArgs: [sort]);
  }

  Future close() async => db.close();
}
