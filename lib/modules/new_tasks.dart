import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shered/components.dart';
import 'package:news/shered/constens.dart';
import 'package:news/shered/cubit/cubit.dart';
import 'package:news/shered/cubit/states.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, AppStates state) {
        var tasks = AppCubit.get(context).newtasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
