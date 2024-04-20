import 'package:hive/hive.dart';
import 'package:task_tracker_assignment/model/task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    return Task(
      title: reader.readString(),
      description: reader.readString(),
      selectedDate: DateTime.parse(reader.readString()),
      from: reader.readString(),
      to: reader.readString(),
      completed: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeString(obj.selectedDate.toIso8601String());
    writer.writeString(obj.from);
    writer.writeString(obj.to);
    writer.writeBool(obj.completed);
  }
}
