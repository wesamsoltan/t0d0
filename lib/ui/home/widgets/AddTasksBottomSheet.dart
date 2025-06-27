import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t0d0/firebase/FirestoreHandler.dart';
import 'package:t0d0/firebase/model/Task.dart';
import 'package:t0d0/style/DialogUtils.dart';
import 'package:t0d0/style/reusable_components/CustomFormField.dart';
import 'package:t0d0/style/reusable_components/Validtion.dart';

class Addtasksbottomsheet extends StatefulWidget {
  const Addtasksbottomsheet({super.key});

  @override
  State<Addtasksbottomsheet> createState() => _AddtasksbottomsheetState();
}

class _AddtasksbottomsheetState extends State<Addtasksbottomsheet> {
  late TextEditingController titleController;
  late TextEditingController descController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        right: 22,
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 22,
        top: 22,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add New Tasks",
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: height * 0.05),
            Customformfield(
              label: "Enter task title",
              keyboard: TextInputType.text,
              controller: titleController,
              Validator: (value) {
                return Validation.fullNameValidator(
                  value,
                  "title shouldn't be empty",
                );
              },
            ),
            SizedBox(height: height * 0.02),
            Customformfield(
              label: "Enter your description",
              maxLines: null,
              keyboard: TextInputType.multiline,
              controller: descController,
              Validator: (value) {
                return Validation.fullNameValidator(
                  value,
                  "description shouldn't be empty",
                );
              },
            ),
            SizedBox(height: height * 0.02),
            InkWell(
              onTap: () {
                showTaskDate();
              },
              child: Text(
                selectedDate == null
                    ? "Date"
                    : DateFormat.yMMMd().format(selectedDate!),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: height * 0.05),
            ElevatedButton(
              onPressed: () {
                addNewTask();
              },
              child: Text("add task"),
            ),
          ],
        ),
      ),
    );
  }

  addNewTask() async {
    if (formKey.currentState!.validate()) {
      if (selectedDate != null) {
        Dialogutils.Showloading(context);
        try {
          await FirestoreHandler.createTask(
            FirebaseAuth.instance.currentUser!.uid,
            Task(
              title: titleController.text,
              description: descController.text,
              date: Timestamp.fromMillisecondsSinceEpoch(
                selectedDate!.millisecondsSinceEpoch,
              ),
            ),
          );
          print('Task added successfully');
        } catch (e) {
          print('Error adding task: $e');
        }
        Navigator.pop(context);
        Dialogutils.ShowMessageDialog(
          context,
          message: "task added succesfully",

          positiveActionClick: () {
            Navigator.pop(context);
          },
          positiveActionTitle: "ok",
        );
      } else {
        Dialogutils.showToast("choose task date");
      }
    }
  }

  showTaskDate() async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    setState(() {});
  }
}
