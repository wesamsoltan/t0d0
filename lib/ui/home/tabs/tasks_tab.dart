import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t0d0/firebase/FirestoreHandler.dart';
import 'package:t0d0/ui/home/widgets/TaskItem.dart';

class TasksTab extends StatefulWidget {
  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          EasyInfiniteDateTimeLine(
            firstDate: DateTime.now(),
            focusDate: selectedDate,
            lastDate: DateTime.now().add(Duration(days: 365)),
            showTimelineHeader: false,
            dayProps: EasyDayProps(
              inactiveDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              todayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ),
            onDateChange: (newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              stream: FirestoreHandler.getTasksListen(
                FirebaseAuth.instance.currentUser!.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Column(
                    children: [
                      Text(snapshot.error.toString()),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("try again"),
                      ),
                    ],
                  );
                }
                var tasksList = snapshot.data ?? [];
                return ListView.separated(
                  itemBuilder: (context, index) =>
                      TaskItem(task: tasksList[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount: tasksList.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
