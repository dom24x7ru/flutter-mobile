// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'votes.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VotesStore on _VotesStore, Store {
  final _$listAtom = Atom(name: '_VotesStore.list');

  @override
  List<Vote>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Vote>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$_VotesStoreActionController = ActionController(name: '_VotesStore');

  @override
  void addVote(Vote vote) {
    final _$actionInfo =
        _$_VotesStoreActionController.startAction(name: '_VotesStore.addVote');
    try {
      return super.addVote(vote);
    } finally {
      _$_VotesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_VotesStoreActionController.startAction(name: '_VotesStore.clear');
    try {
      return super.clear();
    } finally {
      _$_VotesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
