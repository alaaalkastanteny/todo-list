import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/modules/archived_tasks.dart';
import 'package:news/modules/don_tasks.dart';
import 'package:news/modules/new_tasks.dart';
import 'package:news/shered/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());
  static AppCubit get(contex) => BlocProvider.of(contex);

  int cureentIndex = 0;
  Database? database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  List<Widget> screen = [
    NewTasks(),
    const DonTasks(),
    const ArchivedTasks(),
  ];
  List<String> titles = [
    ' New Tasks',
    ' Done Tasks',
    'Archived Task',
  ];

  void changeIndex(dynamic index) {
    cureentIndex = index;
    emit(AppChangeBottonBarNavegator());
  }

  void creatDatabase() async {
    openDatabase(
      'todo2.db',
      version: 1,
      onCreate: (database, version) {
        print("database creating");
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT, date TEXT,time TEXT, status TEXT)')
            .then((value) {
          print("creat table");
        }).catchError((error) {
          print("error creating table to db ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print("database openend");
      },
    ).then((value) {
      database = value;
      emit(AppCreatDatabase());
    });
  }

  Future insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    await database!.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted succssfully');
        emit(AppInsertDatabase());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when inserted new Record ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) async {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    emit(AppGetDatabaseLodingeState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        print(element['status']);

        if (element['status'] == 'new')
          newtasks.add(element);
        else if (element['status'] == 'Done')
          donetasks.add(element);
        else
          archivedtasks.add(element);
      });
      emit(AppGetDatabase());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottonSheetState());
  }

  void updateData({required String status, required int id}) async {
    database!.rawUpdate('UPDATE tasks SET status = ?  WHERE id = ?',
        [status, id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabase());
    });
  }

  void deleteData({required int id}) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabase());
    });
  }
}
