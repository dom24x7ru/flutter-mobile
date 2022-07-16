// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostsStore on _PostsStore, Store {
  late final _$listAtom = Atom(name: '_PostsStore.list', context: context);

  @override
  List<Post>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Post>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$_PostsStoreActionController =
      ActionController(name: '_PostsStore', context: context);

  @override
  void addPost(Post post) {
    final _$actionInfo =
        _$_PostsStoreActionController.startAction(name: '_PostsStore.addPost');
    try {
      return super.addPost(post);
    } finally {
      _$_PostsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPosts(List<Post> posts) {
    final _$actionInfo =
        _$_PostsStoreActionController.startAction(name: '_PostsStore.setPosts');
    try {
      return super.setPosts(posts);
    } finally {
      _$_PostsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markAllAsDeleted() {
    final _$actionInfo = _$_PostsStoreActionController.startAction(
        name: '_PostsStore.markAllAsDeleted');
    try {
      return super.markAllAsDeleted();
    } finally {
      _$_PostsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearDeleted() {
    final _$actionInfo = _$_PostsStoreActionController.startAction(
        name: '_PostsStore.clearDeleted');
    try {
      return super.clearDeleted();
    } finally {
      _$_PostsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_PostsStoreActionController.startAction(name: '_PostsStore.clear');
    try {
      return super.clear();
    } finally {
      _$_PostsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
