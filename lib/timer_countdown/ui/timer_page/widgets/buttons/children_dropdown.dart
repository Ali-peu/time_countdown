import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_countdown/timer_countdown/bloc/timer_bloc/timer_bloc.dart';
import 'package:time_countdown/timer_countdown/domain/models/child_model.dart';

class ChildrenDropdown extends StatefulWidget {
  const ChildrenDropdown({super.key});

  @override
  State<ChildrenDropdown> createState() => _ChildrenDropdownState();
}

class _ChildrenDropdownState extends State<ChildrenDropdown> {
  ChildModel? chooseChildModel;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
      return FutureBuilder<List<ChildModel>>(
          future: Future.value(context.read<TimerBloc>().state.listChildren),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Text('no elements: snapshot.data == null)');
            } else {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  final listChild = snapshot.data!;
                  if (chooseChildModel == null) {
                    chooseChildModel = listChild.first;
                    context.read<TimerBloc>().add(GetPickedChildId(
                        pickedBabyId: chooseChildModel!.childId));
                  }

                  return DropdownButton<ChildModel>(
                      value: chooseChildModel,
                      items: listChild.map((child) {
                        return DropdownMenuItem<ChildModel>(
                            value: child, child: Text(child.name));
                      }).toList(),
                      onChanged: (child) {
                        chooseChildModel = child;
                        context.read<TimerBloc>().add(
                            GetPickedChildId(pickedBabyId: child!.childId));
                        setState(() {});
                      });
                } else {
                  return const Text('snapshot has data, but its empty');
                }
              } else {
                return const Text('snapshot not has data');
              }
            }
          });
    });
  }
}
