import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:t0d0/firebase/model/Task.dart';
import 'model/User.dart';

class FirestoreHandler {
  static CollectionReference<User> getUserCollection() {
    var collection = FirebaseFirestore.instance
        .collection(User.collectionName)
        .withConverter(
      fromFirestore: (snapshot, options) {
        var data = snapshot.data();
        return User.fromFireStore(snapshot.data());
      },
      toFirestore: (user, options) {
        return user.toFirestore();
      },
    );
    return collection;
  }

  static Future<void> createUser(User user) async {
    try {
      var collection = getUserCollection();
      var docRef = collection.doc(user.uid);
      await docRef.set(user);
      print('User added successfully');
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  static CollectionReference<Task> getTasksCollection(String userId) {
    var collection = getUserCollection()
        .doc(userId)
        .collection(Task.collectionName)
        .withConverter(
      fromFirestore: (snapshot, options) {
        return Task.fromFireStore(snapshot.data());
      },
      toFirestore: (task, options) {
        return task.toFireStore();
      },
    );
    return collection;
  }

  static Future<void> createTask(String userId, Task task) async {
    var collection = getTasksCollection(userId);
    var docRef = collection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<List<Task>> getTasks(userId) async {
    var collection = getTasksCollection(userId);
    var querySnapshot = await collection.get();
    var queryList = querySnapshot.docs;
    var tasksList = queryList.map((doc) => doc.data()).toList();
    return tasksList;
  }

  static Stream<List<Task>> getTasksListen(String userId) async* {
    var collection = getTasksCollection(userId);
    var queryStream = collection.snapshots();
    var tasksStream = queryStream.map(
          (event) => event.docs.map((doc) => doc.data()).toList(),
    );
    yield* tasksStream;
  }

  static Future<void> deleteTask(String userId, String taskId) {
    var collection = getTasksCollection(userId);
    return collection.doc(taskId).delete();
  }

  static Future<void> editIsDone(Task task, String uId) {
    var collection = getTasksCollection(uId);
    return collection.doc(task.id).update({"isDone": task.isDone});
  }

  static Future<void> updateTask(Task task,String uId)
  {
    return getTasksCollection(uId).doc(task.id).update(task.toFireStore());
  }

}