// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invites.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InvitesStore on _InvitesStore, Store {
  late final _$listAtom = Atom(name: '_InvitesStore.list', context: context);

  @override
  List<Invite>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Invite>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$_InvitesStoreActionController =
      ActionController(name: '_InvitesStore', context: context);

  @override
  void addInvite(Invite invite) {
    final _$actionInfo = _$_InvitesStoreActionController.startAction(
        name: '_InvitesStore.addInvite');
    try {
      return super.addInvite(invite);
    } finally {
      _$_InvitesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInvites(List<Invite> invites) {
    final _$actionInfo = _$_InvitesStoreActionController.startAction(
        name: '_InvitesStore.setInvites');
    try {
      return super.setInvites(invites);
    } finally {
      _$_InvitesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_InvitesStoreActionController.startAction(
        name: '_InvitesStore.clear');
    try {
      return super.clear();
    } finally {
      _$_InvitesStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
