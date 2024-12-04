import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = [];

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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskItem(index);
      },
    );
  }

  Widget _buildTaskItem(int index) {
    final task = _tasks[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4.0,
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.blueGrey),
            onPressed: () => _showDeleteConfirmationDialog(context, index),
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
        return AlertDialog(
          title: const Text('Edit Task',
              style: TextStyle(color: Colors.lightBlue)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Title', (value) => title = value,
                  initialValue: title),
              _buildTextField('Description', (value) => description = value,
                  initialValue: description),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.indigo)),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && description.isNotEmpty) {
                  if (task == null) {
                    _addTask(Task(title: title, description: description));
                  } else {
                    _updateTask(
                        index!, Task(title: title, description: description));
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text('Submit',
                  style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                _removeTask(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {String? initialValue}) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    ); 

  }

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _updateTask(int index, Task task) {
    setState(() {
      _tasks[index] = task;
    });
  }

  void _removeTask(int index) {
    setState(() {
      if (_tasks.isNotEmpty) {
        _tasks.removeAt(index);
      }
    });
  }
}

class Task {
  final String title;
  final String description;

  Task({required this.title, required this.description});
}
