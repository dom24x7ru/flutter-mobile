// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IMStore on _IMStore, Store {
  late final _$channelsAtom = Atom(name: '_IMStore.channels', context: context);

  @override
  List<IMChannel>? get channels {
    _$channelsAtom.reportRead();
    return super.channels;
  }

  @override
  set channels(List<IMChannel>? value) {
    _$channelsAtom.reportWrite(value, super.channels, () {
      super.channels = value;
    });
  }

  late final _$_IMStoreActionController =
      ActionController(name: '_IMStore', context: context);

  @override
  void addChannel(IMChannel channel) {
    final _$actionInfo =
        _$_IMStoreActionController.startAction(name: '_IMStore.addChannel');
    try {
      return super.addChannel(channel);
    } finally {
      _$_IMStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChannels(List<IMChannel> channels) {
    final _$actionInfo =
        _$_IMStoreActionController.startAction(name: '_IMStore.setChannels');
    try {
      return super.setChannels(channels);
    } finally {
      _$_IMStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_IMStoreActionController.startAction(name: '_IMStore.clear');
    try {
      return super.clear();
    } finally {
      _$_IMStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
channels: ${channels}
    ''';
  }
}
