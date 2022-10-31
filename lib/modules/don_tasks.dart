import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shered/components.dart';
import 'package:news/shered/cubit/cubit.dart';
import 'package:news/shered/cubit/states.dart';

class DonTasks extends StatelessWidget {
  const DonTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, AppStates state) {
        var tasks = AppCubit.get(context).donetasks;
        return tasksBuilder(tasks: tasks);
      },
    );
  }
}
