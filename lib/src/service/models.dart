library todo_example.src.service.models;

import 'dart:convert';

const dynamic unspecified = #unspecified;

class Todo {
  /// Short description of item. Serves as the title.
  final String description;

  /// Assigned due date. Null if no due date assigned.
  final DateTime dueDate;

  /// Unique identifier. Assigned by server.
  final String id;

  /// Whether or not this item has been marked as completed.
  final bool isCompleted;

  /// Whether or not this item is public. Public means anyone in the application
  /// can see it. Private means only the creator can see it.
  final bool isPublic;

  /// Notes
  final String notes;

  /// Unique user identifier of the user who created this item.
  final String userID;

  /// Create a new item.
  Todo(
      {String this.description: '',
      DateTime this.dueDate,
      bool this.isCompleted: false,
      bool this.isPublic: false,
      String this.notes: ''})
      : id = null,
        userID = null;

  /// Create a new item, allowing the ID and userID fields to be set. Used by
  /// [change].
  Todo._(String this.id, String this.userID,
      {String this.description: '',
      DateTime this.dueDate,
      bool this.isCompleted: false,
      bool this.isPublic: false,
      String this.notes: ''});

  /// Construct an item from a map.
  Todo.fromMap(Map source)
      : id = source['id'],
        description =
            source['description'] != null ? source['description'] : '',
        dueDate = source['dueDate'] != null
            ? DateTime.parse(source['dueDate'])
            : null,
        isCompleted = source['isCompleted'] == true,
        isPublic = source['isPublic'] == true,
        notes = source['notes'] != null ? source['notes'] : '',
        userID = source['userID'];

  /// Construct an item from the service response.
  Todo.fromServerJson(String json) : this.fromMap(JSON.decode(json));

  Map toMap() => {
        'description': description,
        'dueDate': dueDate,
        'id': id,
        'isCompleted': isCompleted,
        'isPublic': isPublic,
        'notes': notes,
      };

  /// Encode this item to the JSON payload the server expects.
  String toServerJson() => JSON.encode(toMap());

  Todo change(
      {String description: unspecified,
      DateTime dueDate: unspecified,
      bool isCompleted: unspecified,
      bool isPublic: unspecified,
      String notes: unspecified}) {
    String rDescription =
        description != unspecified ? description : this.description;
    DateTime rDueDate = dueDate != unspecified ? dueDate : this.dueDate;
    bool rIsCompleted =
        isCompleted != unspecified ? isCompleted : this.isCompleted;
    bool rIsPublic = isPublic != unspecified ? isPublic : this.isPublic;
    String rNotes = notes != unspecified ? notes : this.notes;

    return new Todo._(id, userID,
        description: rDescription,
        dueDate: rDueDate,
        isCompleted: rIsCompleted,
        isPublic: rIsPublic,
        notes: rNotes);
  }
}
