import 'package:conditional_builder/conditional_builder.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news/modules/archived_tasks.dart';
import 'package:news/modules/don_tasks.dart';
import 'package:news/modules/new_tasks.dart';
import 'package:news/shered/constens.dart';
import 'package:news/shered/cubit/cubit.dart';
import 'package:news/shered/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldkay = GlobalKey<ScaffoldState>();
  var formkay = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabase) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkay,
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: Text(
                cubit.titles[cubit.cureentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formkay.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                    // insertToDatabase(
                    //         title: titleController.text,
                    //         date: dateController.text,
                    //         time: timeController.text)
                    //     .then((value) {
                    //   getDataFromDatabase(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShown = false;
                    //     //   fabIcon = Icons.edit;

                    //     //   tasks = value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scaffoldkay.currentState
                      ?.showBottomSheet(
                        (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formkay,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.title),
                                    labelText: 'Task Title',
                                  ),
                                  controller: titleController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter name Task ';
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    )
                                        .then((value) => {
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString()
                                            })
                                        .catchError((onError) {
                                      timeController.text = '';
                                    });
                                    ;
                                  },
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.watch_later_outlined),
                                    labelText: 'Task Time',
                                  ),
                                  controller: timeController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter time Task ';
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-12-05'),
                                    )
                                        .then((value) => {
                                              dateController.text =
                                                  DateFormat.yMMMd()
                                                      .format(value!)
                                            })
                                        .catchError((onError) {
                                      dateController.text = '';
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.calendar_today),
                                    labelText: 'Task Date',
                                  ),
                                  controller: dateController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter date Task ';
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);

                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                  //cubit.isBottomSheetShown = true;
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.blueAccent,
              items: const <Widget>[
                Icon(Icons.menu, size: 30),
                Icon(Icons.check_circle_outline, size: 30),
                Icon(Icons.archive_outlined, size: 30),
              ],
              index: AppCubit.get(context).cureentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLodingeState,
              builder: (context) => cubit.screen[cubit.cureentIndex],
              fallback: ((context) =>
                  const Center(child: CircularProgressIndicator())),
            ),
          );
        },
      ),
    );
  }
}
