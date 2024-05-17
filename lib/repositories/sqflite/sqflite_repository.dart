import 'package:membo/models/board/linked_board_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sqflite_repository.g.dart';

@Riverpod(keepAlive: true)
SqfliteRepository sqfliteRepository(
  SqfliteRepositoryRef ref,
) {
  // throw UnimplementedError();
  return SqfliteRepository.instance;
}

class SqfliteRepository {
  static const _databaseName = "sqflite_Database_test.db";
  static const _databaseVersion = 1;
  static const linkedBoardTable = 'linkedBoardTable';

  static const boardId = 'board_id';
  static const boardName = 'board_name';
  static const thumbnailUrl = 'thumbnail_url';
  static const createdAt = 'created_at';

  SqfliteRepository._();
  static final SqfliteRepository instance = SqfliteRepository._();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $linkedBoardTable (
            $boardId TEXT PRIMARY KEY,
            $boardName TEXT NOT NULL,
            $thumbnailUrl TEXT NOT NULL,
            $createdAt TEXT NOT NULL
          )
          ''');
  }

  /// add database row
  Future<int> insertLinkedBoard(LinkedBoardModel linkedBoardModel) async {
    Database db = await instance.database;
    try {
      final row = {
        boardId: linkedBoardModel.boardId,
        boardName: linkedBoardModel.boardName,
        thumbnailUrl: linkedBoardModel.thumbnailUrl,
        createdAt: linkedBoardModel.createdAt.toIso8601String(),
      };
      int result = await db.insert(
        linkedBoardTable,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace, // 上書き
      );
      return result;
    } catch (e) {
      throw Exception('リンクボードの追加に失敗しました');
    }
  }

  Future<List<LinkedBoardModel>> loadLinkedBoards() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> loadData =
          await db.query(linkedBoardTable, orderBy: '$createdAt DESC');
      final List<LinkedBoardModel> allData = loadData.map((e) {
        return LinkedBoardModel.fromJson(e);
      }).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }

  Future<LinkedBoardModel?> findById(String id) async {
    try {
      Database db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query(
        linkedBoardTable,
        where: '$boardId = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return LinkedBoardModel.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// formatNameを更新 更新が成功した場合は1を返す
  Future<int> updateLinkedBoard(String boardId,
      {String? boardName, String? thumbnailUrl}) async {
    Map<String, Object?>? updateRow;

    if (boardName != null && thumbnailUrl != null) {
      updateRow = {
        boardName: boardName,
        thumbnailUrl: thumbnailUrl,
      };
    } else if (boardName != null) {
      updateRow = {boardName: boardName};
    } else if (thumbnailUrl != null) {
      updateRow = {thumbnailUrl: thumbnailUrl};
    } else {
      throw Exception('更新する値がありません');
    }

    try {
      Database db = await instance.database;
      return await db.update(
        linkedBoardTable,
        updateRow,
        where: '$boardId = ?',
        whereArgs: [boardId],
      );
    } catch (e) {
      throw Exception('更新に失敗しました');
    }
  }

  /// delete row 削除が成功した場合は1を返す
  Future<int> deleteRow(String id) async {
    try {
      Database db = await instance.database;
      return await db.delete(
        linkedBoardTable,
        where: '$boardId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('削除に失敗しました');
    }
  }
}
