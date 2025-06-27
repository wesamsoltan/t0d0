import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../firebase/FirestoreHandler.dart';
import '../../firebase/model/Task.dart';
import '../../style/DialogUtils.dart';
import '../../style/reusable_components/CustomFormField.dart';
import '../../style/reusable_components/Validtion.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = "edit_screen";

  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  Task? task;

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

    if(task==null){
      task = ModalRoute.of(context)?.settings.arguments as Task;
      titleController.text = task!.title!;
      descController.text = task!.description!;
      selectedDate = task!.date?.toDate();

    }
    return Scaffold(
      appBar: AppBar(title: Text("To do list")),
      body: Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Edit Task",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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
                    SizedBox(height: height * 0.1),
                    ElevatedButton(
                      onPressed: () {
                        updateTask();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.7, height * 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(22),
                        ),
                      ),
                      child: Text("save changes"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateTask() async {
    if (formKey.currentState!.validate()) {
      if (selectedDate != null) {
        Dialogutils.Showloading(context);
        //task!.title=titleController.text;
        //task!.description=descController.text;
        //task!.date=Timestamp.fromMillisecondsSinceEpoch(
          //selectedDate!.millisecondsSinceEpoch);
        Task updateTask=Task(
          id: task!.id,
          isDone: task!.isDone,
          title: titleController.text,
          description: descController.text,
          date: Timestamp.fromMillisecondsSinceEpoch(
            selectedDate!.millisecondsSinceEpoch,
          ),
        );
        try {
          await FirestoreHandler.updateTask(updateTask,

            //task!,
            FirebaseAuth.instance.currentUser!.uid,
          );

          print('Task update successfully');
        } catch (e) {
          print('Error update task: $e');
        }
        Navigator.pop(context);
        Dialogutils.ShowMessageDialog(
          context,
          message: "task updated succesfully",
          positiveActionClick: () {
            Navigator.pop(context);
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
