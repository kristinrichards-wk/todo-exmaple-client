library todo_example.src.service.wdesk_service;

import 'dart:async';
import 'dart:html';

import 'package:base_service/base_service.dart' as base_service;
import 'package:messaging_sdk/messaging_sdk.dart';
import 'package:todo_service/todo_service.dart' as todo_service;
import 'package:uuid/uuid.dart';
import 'package:w_oauth2/w_oauth2.dart';
import 'package:w_session/w_session.dart';

import 'package:todo_example/src/service/definition.dart' show TodoService;
import 'package:todo_example/src/service/models.dart' show Todo;

class WdeskTodoService implements TodoService {
  Client _client;
  OAuth2 _oauth2;
  Session _session;
  todo_service.TodosSubscriber _todoSubscriber;
  Completer<todo_service.TodoServiceClient> _todoService = new Completer();
  Uuid _uuid = new Uuid();

  StreamController<Todo> _todoCreated = new StreamController.broadcast();
  StreamController<Todo> _todoDeleted = new StreamController.broadcast();
  StreamController<Todo> _todoUpdated = new StreamController.broadcast();

  WdeskTodoService(Client client, Session session, OAuth2 oauth2)
      : _client = client,
        _session = session,
        _oauth2 = oauth2 {
    _client.provideRPCClient('todo-service').then((protocol) {
      _todoService.complete(new todo_service.TodoServiceClient(protocol));
    });

    var account = _session.context.account.accountId;
    var membership =
        _decodeResourceId(_session.context.membership.resourceId, 'Membership');
    _todoSubscriber = new todo_service.TodosSubscriber(_client.providePubSub());

    _todoSubscriber.subscribeTodoCreated(account, membership,
        (todo_service.Todo serviceTodo) {
      _todoCreated.add(_convertForClient(serviceTodo));
    });

    _todoSubscriber.subscribeTodoDeleted(account, membership,
        (todo_service.Todo serviceTodo) {
      _todoDeleted.add(_convertForClient(serviceTodo));
    });

    _todoSubscriber.subscribeTodoUpdated(account, membership,
        (todo_service.Todo serviceTodo) {
      _todoUpdated.add(_convertForClient(serviceTodo));
    });
  }

  @override
  Stream<Todo> get todoCreated => _todoCreated.stream;

  @override
  Stream<Todo> get todoDeleted => _todoDeleted.stream;

  @override
  Stream<Todo> get todoUpdated => _todoUpdated.stream;

  /// Create a to-do.
  @override
  Future<Todo> createTodo(Todo clientTodo) async {
    var service = await _getTodoService();
    var rc = _createRequestContext();
    var serviceTodo = _convertForService(clientTodo);

    todo_service.Todo created = await service.createTodo(rc, serviceTodo);
    return _convertForClient(created);
  }

  /// Delete a to-do.
  @override
  Future<Null> deleteTodo(String todoID) async {
    var service = await _getTodoService();
    var rc = _createRequestContext();

    await service.deleteTodo(rc, todoID);
  }

  /// Query for to-dos.
  @override
  Future<List<Todo>> queryTodos(
      {bool includeComplete: false,
      bool includeIncomplete: false,
      bool includePrivate: false,
      bool includePublic: false}) async {
    var service = await _getTodoService();
    var rc = _createRequestContext();

    var params = new todo_service.TodoQueryParams()
      ..includeComplete = includeComplete
      ..includeIncomplete = includeIncomplete
      ..includePrivate = includePrivate
      ..includePublic = includePublic;

    List<todo_service.Todo> serviceTodos = await service.queryTodos(rc, params);
    return serviceTodos
        .map((serviceTodo) => _convertForClient(serviceTodo))
        .toList();
  }

  /// Update a to-do.
  @override
  Future<Todo> updateTodo(Todo clientTodo) async {
    var service = await _getTodoService();
    var rc = _createRequestContext();
    var serviceTodo = _convertForService(clientTodo);

    todo_service.Todo updated = await service.updateTodo(rc, serviceTodo);
    return _convertForClient(updated);
  }

  base_service.RequestContext _createRequestContext() => new base_service.RequestContext()
    ..accountID = _session.context.account.accountId
    ..authorizationToken = _oauth2.accessToken
    ..clientID = _oauth2.clientId
    ..correlationID = _uuid.v4()
    ..membershipID =
        _decodeResourceId(_session.context.membership.resourceId, 'Membership')
    ..userID = _session.context.user.resourceId;

  _getTodoService() => _todoService.future;

  Todo _convertForClient(todo_service.Todo serviceTodo) => new Todo(
      description: serviceTodo.description,
      id: serviceTodo.id,
      isCompleted: serviceTodo.isCompleted,
      isPublic: serviceTodo.isPublic,
      notes: serviceTodo.notes,
      userID: serviceTodo.userID);

  todo_service.Todo _convertForService(Todo clientTodo) => new todo_service.Todo()
    ..description = clientTodo.description
    ..id = clientTodo.id
    ..isCompleted = clientTodo.isCompleted
    ..isPublic = clientTodo.isPublic
    ..notes = clientTodo.notes
    ..userID = _session.context.user.resourceId;

  String _decodeResourceId(resourceId, strip) =>
      window.atob(resourceId).replaceAll('$strip\x1f', '');

  DateTime _toDateTime(int timestamp) => timestamp != null
      ? new DateTime.fromMillisecondsSinceEpoch(timestamp)
      : null;

  int _toTimestamp(DateTime dateTime) =>
      dateTime != null ? dateTime.millisecondsSinceEpoch : null;
}
