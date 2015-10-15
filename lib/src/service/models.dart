library todo_example.src.service.models;

import 'dart:convert';

class Todo {
  /// Short description of item. Serves as the title.
  final String description;

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
      String this.id,
      bool this.isCompleted: false,
      bool this.isPublic: false,
      String this.notes: '',
      String this.userID});

  /// Create a new item, allowing the ID and userID fields to be set. Used by
  /// [change].
  Todo._(String this.id, String this.userID,
      {String this.description: '',
      bool this.isCompleted: false,
      bool this.isPublic: false,
      String this.notes: ''});

  /// Construct an item from a map.
  Todo.fromMap(Map source)
      : id = source['id'],
        description =
            source['description'] != null ? source['description'] : '',
        isCompleted = source['isCompleted'] == true,
        isPublic = source['isPublic'] == true,
        notes = source['notes'] != null ? source['notes'] : '',
        userID = source['userID'];

  /// Construct an item from the service response.
  Todo.fromServerJson(String json) : this.fromMap(JSON.decode(json));

  Map toMap() => {
        'description': description,
        'id': id,
        'isCompleted': isCompleted,
        'isPublic': isPublic,
        'notes': notes,
      };

  /// Encode this item to the JSON payload the server expects.
  String toServerJson() => JSON.encode(toMap());

  Todo change(
      {String description, bool isCompleted, bool isPublic, String notes}) {
    String rDescription = description != null ? description : this.description;
    bool rIsCompleted = isCompleted != null ? isCompleted : this.isCompleted;
    bool rIsPublic = isPublic != null ? isPublic : this.isPublic;
    String rNotes = notes != null ? notes : this.notes;

    return new Todo._(id, userID,
        description: rDescription,
        isCompleted: rIsCompleted,
        isPublic: rIsPublic,
        notes: rNotes);
  }
}
