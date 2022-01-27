// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InstructionsStore on _InstructionsStore, Store {
  final _$listAtom = Atom(name: '_InstructionsStore.list');

  @override
  List<Instruction>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Instruction>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$_InstructionsStoreActionController =
      ActionController(name: '_InstructionsStore');

  @override
  void addInstruction(Instruction instruction) {
    final _$actionInfo = _$_InstructionsStoreActionController.startAction(
        name: '_InstructionsStore.addInstruction');
    try {
      return super.addInstruction(instruction);
    } finally {
      _$_InstructionsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInstructions(List<Instruction> instructions) {
    final _$actionInfo = _$_InstructionsStoreActionController.startAction(
        name: '_InstructionsStore.setInstructions');
    try {
      return super.setInstructions(instructions);
    } finally {
      _$_InstructionsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_InstructionsStoreActionController.startAction(
        name: '_InstructionsStore.clear');
    try {
      return super.clear();
    } finally {
      _$_InstructionsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
