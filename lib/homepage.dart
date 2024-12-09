import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_notifier.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(context, null),
        tooltip: 'Add Task',
        child: const Icon(Icons.add_card_rounded),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<TaskNotifier>(
      builder: (context, taskNotifier, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Expanded(child: _buildTaskList(taskNotifier)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskList(TaskNotifier taskNotifier) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemCount: taskNotifier.tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskItem(taskNotifier, index);
      },
    );
  }

  Widget _buildTaskItem(TaskNotifier taskNotifier, int index) {
    final task = taskNotifier.tasks[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4.0,
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: const Icon(Icons.delete_forever_rounded,
                size: 28, color: Color.fromARGB(255, 227, 98, 89)),
            onPressed: () =>
                _showDeleteConfirmationDialog(context, taskNotifier, index),
          ),
          onTap: () => _showEditDialog(context, task, index),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Task? task, [int? index]) {
    String title = task?.title ?? '';
    String description = task?.description ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), 
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Edit Task',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Title', (value) => title = value,
                    initialValue: title),
                const SizedBox(height: 12),
                _buildTextField('Description', (value) => description = value,
                    initialValue: description),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (title.isNotEmpty && description.isNotEmpty) {
                          final taskNotifier =
                              Provider.of<TaskNotifier>(context, listen: false);
                          if (task == null) {
                            taskNotifier.addTask(
                                Task(title: title, description: description));
                          } else {
                            taskNotifier.updateTask(index!,
                                Task(title: title, description: description));
                          }
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {String? initialValue}) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(Icons.edit, color: Colors.blue), 
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8.0), 
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
void _showDeleteConfirmationDialog(
    BuildContext context, TaskNotifier taskNotifier, int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Delete Task',
          style: TextStyle(color: Color.fromARGB(255, 218, 96, 87)),
        ),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () {
              taskNotifier.removeTask(index); 
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color.fromARGB(255, 219, 110, 103)),
            ),
          ),
        ],
      );
    },
  );
}
