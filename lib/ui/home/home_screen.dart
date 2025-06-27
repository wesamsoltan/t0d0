import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t0d0/ui/home/tabs/settings_tab.dart';
import 'package:t0d0/ui/home/tabs/tasks_tab.dart';
import 'package:t0d0/ui/home/widgets/AddTasksBottomSheet.dart';
import 'package:t0d0/ui/login/login_screen.dart';
class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> tabs = [TasksTab(), SettingsTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            context: context,
            builder: (context) => Addtasksbottomsheet(),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text("To Do List"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        shape: CircularNotchedRectangle(),

        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.list, size: 30),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Icon(Icons.settings, size: 30),
            ),
          ],
        ),
      ),
      body: tabs[currentIndex],
    );
  }
}
