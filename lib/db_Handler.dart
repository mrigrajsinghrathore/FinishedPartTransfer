

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';

import 'ModelClass/db_model.dart';
import 'ModelClass/db_model_addinfo.dart';


class dbHandler {
  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      Directory directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, 'techelecondatabase');
      _db = await openDatabase(path, version: 1, onCreate: (_onCreate));
      return _db;
    }
  }

  Future _onCreate(Database db, int version) async {
    print("table created 1");
    await db.execute('''
CREATE TABLE  IF NOT EXISTS usertable (id INTEGER PRIMARY KEY, Name TEXT,role TEXT ,companyid TEXT,username TEXT,password TEXT,Email TEXT)
''');
    print("table created 2");
    await db.execute('''
CREATE TABLE IF NOT EXISTS ProductInformation (id INTEGER PRIMARY KEY ,
 barCodeNo TEXT,
 productName TEXT,
 manufacturingPlant TEXT,
 productDimension TEXT,
 Description TEXT,
 Review TEXT,
 ProductionCompanyId TEXT,
 QaQcRemark TEXT,
 QaQcStatus TEXT,
 QaQcCompanyId TEXT,
 StoreRemark TEXT,
 StoreStatus TEXT,
 StoreCompanyId TEXT)
''');
  }


  Future insertUserInfomation(dbModel model) async {
    Database? databaseinsert = await db;
    await databaseinsert!.insert('usertable', model.toMap());
  }

  getUserAuth(dbModel model) async {
    Database? database = await db;
    var result = await database!.rawQuery(
        "select * from usertable where role = '${model
            .role}' AND companyId = '${model
            .companyId}' AND username = '${model
            .username}'AND password = '${model.password}' ");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future insertData(dbModelAddInformation model) async {
    Database? databaseinsert = await db;
    await databaseinsert!.insert('ProductInformation', model.toMap());
  }

  Future<List<Map<String, dynamic>>> fetchdata() async {
    Database? database = await db;
    return await database!.query('usertable');
  }

  Future fetchdataProduct( barcode) async {
    Database? database = await db;
    return await database!.query('ProductInformation'   ,   where: 'barCodeNo = ?',
      whereArgs: [barcode],
    );
  }

  Future<void>updataproduct(int id,String Description,String Review,String ProductionCompanyId)async{
    Database? database = await db;
    await database!.update('ProductInformation', {
      'Description':Description,
      'Review':Review,
      'ProductionCompanyId':ProductionCompanyId

    },where: 'id=?',
        whereArgs: [id]

    );
  }


 Future CheckBar(dbModelAddInformation model) async {
   Database? database = await db;
   var result = await database!.rawQuery(
       "select * from ProductInformation where barCodeNo = '${
           model.barCodeNo}'");
   if (result.isNotEmpty) {
     return result;
   } else {
     return false;
   }


 }

  fetchUseremailData(productionId,CheckByUser_QA,CheckByUser_production) async {
    Database? database = await db;
    var result = await database!.rawQuery(
        "select Email from usertable where companyId IN('${productionId}','${CheckByUser_QA}','${CheckByUser_production}')");
    if (result.isNotEmpty) {
      print(result);
      return result;
    } else {
      return false;
    }

  }

  Future<void>updateQId(int id,String QaQcCompanyId, String QaQcStatus)async{
    Database? database = await db;
    await database!.update('ProductInformation', {
      'QaQcCompanyId':QaQcCompanyId,
      'QaQcStatus':QaQcStatus

    },where: 'id=?',
        whereArgs: [id]


    );
  }

  Future<void>updateSId(int id ,String StoreCompanyId, String StoreStatus )async{
    Database? database = await db;
    await database!.update('ProductInformation', {
      'StoreCompanyId':StoreCompanyId,
      'StoreStatus':StoreStatus

    },where: 'id=?',
        whereArgs: [id]


    );
  }


  Future<void>updateQRemark(int id ,String QaQcRemark, String QaQcStatus, String QaQcCompanyId )async{
    Database? database = await db;
    await database!.update('ProductInformation', {
      'QaQcRemark':QaQcRemark,
      'QaQcStatus':QaQcStatus,
      'QaQcCompanyId':QaQcCompanyId


    },where: 'id=?',
        whereArgs: [id]


    );
  }


  Future<void>updateSRemark(int id ,String StoreRemark, String StoreStatus,String StoreCompanyId )async{
    Database? database = await db;
    await database!.update('ProductInformation', {
      'StoreRemark':StoreRemark,
      'StoreStatus':StoreStatus,
      'StoreCompanyId':StoreCompanyId


    },where: 'id=?',
        whereArgs: [id]


    );
  }






}