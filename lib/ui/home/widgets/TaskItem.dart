import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:t0d0/firebase/FirestoreHandler.dart';
import 'package:t0d0/style/AppColors.dart';
import 'package:t0d0/style/DialogUtils.dart';
import 'package:t0d0/ui/edit_screen/editScreen.dart';

import '../../../firebase/model/Task.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: .3,
        motion: BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteTask();
            },
            icon: Icons.delete,
            backgroundColor: Colors.redAccent,
            label: "delete",
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          SlidableAction(
            onPressed: (context) {
              Navigator.pushNamed(context, EditScreen.routeName,arguments: widget.task);
            },
            icon: Icons.edit,
            backgroundColor: Theme.of(context).primaryColor,
            label: "edit task",

          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 5,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: widget.task.isDone!
                      ? Appcolors.greenColor
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title ?? "",
                      style: widget.task.isDone!
                          ? Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Appcolors.greenColor,
                            )
                          : Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.task.description ?? "",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              widget.task.isDone!
                  ? TextButton(
                      onPressed: () {
                        widget.task.isDone = !widget.task.isDone!;
                        FirestoreHandler.editIsDone(
                          widget.task,
                          FirebaseAuth.instance.currentUser!.uid,
                        );
                        setState(() {});
                      },
                      child: const Text(
                        "done!",
                        style: TextStyle(
                          color: Appcolors.greenColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        widget.task.isDone = !widget.task.isDone!;
                        FirestoreHandler.editIsDone(
                          widget.task,
                          FirebaseAuth.instance.currentUser!.uid,
                        );
                        setState(() {});
                      },
                      child: const Icon(Icons.check),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  deleteTask() async {
    Dialogutils.ShowMessageDialog(
      context,
      message: "Are you sure you want to delete this task?",
      positiveActionTitle: "yes",
      positiveActionClick: () async {
        Navigator.pop(context);
        Dialogutils.Showloading(context);
        await FirestoreHandler.deleteTask(
          FirebaseAuth.instance.currentUser!.uid,
          widget.task.id ?? "",
        );
        Navigator.pop(context);
        Dialogutils.showToast("this task deleted");
      },
      negativeActionClick: () {
        Navigator.pop(context);
      },
      negativeActionTitle: "no",
    );
  }
}
