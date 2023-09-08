import 'dart:io';
import 'package:dog/dog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


import 'package:base/base.dart';

import '../model/message_session.dart';


enum TableName {
  Message,
  Session,
}

enum MessageField {
  sessionId,
  messageId,
  srcUid,
  targetId,
  targetType,
  createAt,
  read,
  status,
  message,
}

enum SessionField {
  sessionId,
  sessionName,
  peerGender,
  targetId,
  targetType,
  msgCount,
  unReadCount,
  lastData,
}

class DatabaseHelper {

  static const _dbVersion = 1;
  String get dbName{
  return '${Session.uid}_my11.db';
  }
  // Making it a Singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database.
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  void close(){
    _database?.close();
    _database = null;
  }
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await _createMessageTable(db, version);
   return await _createSessionTable(db, version);
  }

  Future _createMessageTable(Database db, int version) async {
     await db.execute('''
          CREATE TABLE IF NOT EXISTS ${TableName.Message.name} (
            ${MessageField.messageId.name} TEXT PRIMARY KEY,
            ${MessageField.sessionId.name} TEXT NOT NULL,
            ${MessageField.srcUid.name} INTEGER,
            ${MessageField.targetId.name} INTEGER,
            ${MessageField.targetType.name} INTEGER,
            ${MessageField.createAt.name} INTEGER,
            ${MessageField.read.name} INTEGER,
             ${MessageField.status.name} INTEGER,
             ${MessageField.message.name} TEXT NOT NULL
          )
          ''');
   return await db.execute(
        'CREATE INDEX index_${MessageField.createAt.name} ON ${TableName.Message
            .name} (${MessageField.createAt.name})');
  }

  Future _createSessionTable(Database db, int version) async {
     await db.execute('''
          CREATE TABLE IF NOT EXISTS ${TableName.Session.name} (
            ${SessionField.sessionId.name} TEXT PRIMARY KEY,
            ${SessionField.sessionName.name} TEXT NOT NULL,
             ${SessionField.peerGender.name} INTEGER,
            ${SessionField.targetType.name} INTEGER,
            ${SessionField.targetId.name} INTEGER,
            ${SessionField.msgCount.name} INTEGER,
             ${SessionField.unReadCount.name} INTEGER,
             ${SessionField.lastData.name} TEXT NOT NULL
          )
          ''');
     return await db.execute(
        'CREATE INDEX index_${SessionField.targetType.name} ON ${TableName
            .Message.name} (${MessageField.createAt.name})');
  }

  //Message CRUD
  Future<int> insertMessage(SocketData socketData) async {
    Database db = await instance.database;
    Map insertData = socketData.toMMap();
    dog.d('insertData=>$insertData');
    int res = await db.insert(TableName.Message.name, socketData.toMMap());
    return res;
  }


  Future<List<SocketData>> queryMessages(
      {required String filedName,required  dynamic fieldValue, int? limit,String? orderBy,int? offset}) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> res = await db.query(TableName.Message.name,
        where: '$filedName = ? ', whereArgs: [fieldValue], limit: limit,orderBy: orderBy,offset:offset);
    List<SocketData> list =
    res.isNotEmpty ? res.map((c) => SocketData.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> updateMessage(SocketData socketData,[Map<String, Object?>? data]) async {
    Database db = await instance.database;

    return await db.update(TableName.Message.name, data??socketData.toMMap(),
        where: '${MessageField.messageId.name} = ?',
        whereArgs: [socketData.messageId]);
  }

  Future<int> deleteMessage(String messageId) async {
    Database db = await instance.database;
    return await db.delete(TableName.Message.name,
        where: '${MessageField.messageId.name} = ?', whereArgs: [messageId]);
  }

  //Sesion CRUD
  Future<int> insertSession(MessageSession session) async {
    Database db = await instance.database;
    return await db.insert(TableName.Session.name, session.toMMap());
  }

  Future<List<MessageSession>> queryAllSessions(
      {int? limit,String? orderBy}) async {
    Database db = await instance.database;
    var res = await db.query(TableName.Session.name,limit: limit,orderBy: orderBy);
    List<MessageSession> list = res.isNotEmpty
        ? res.map((c) => MessageSession.fromMap(c)).toList()
        : [];
    return Future.value(list);
  }
  Future<List<MessageSession>> querySessions(
      {required String fieldName, required dynamic fieldValue, int? limit}) async {
    Database db = await instance.database;
    var res = await db.query(TableName.Session.name,where: '$fieldName = ?',whereArgs: [fieldValue], limit: limit);
    List<MessageSession> list = res.isNotEmpty
        ? res.map((c) => MessageSession.fromMap(c)).toList()
        : [];
    return Future.value(list);
  }


  Future<int> updateSession(MessageSession data) async {
    Database db = await instance.database;

    return await db.update(TableName.Session.name, data.toMMap(),
        where: '${SessionField.sessionId.name} = ?',
        whereArgs: [data.sessionId]);
  }

  Future<int> deleteSession(String sessionId) async {
    Database db = await instance.database;
    return await db.delete(TableName.Session.name,
        where: '${SessionField.sessionId.name} = ?', whereArgs: [sessionId]);
  }
}
