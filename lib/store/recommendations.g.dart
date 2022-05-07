// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendations.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RecommendationsStore on _RecommendationsStore, Store {
  late final _$listAtom =
      Atom(name: '_RecommendationsStore.list', context: context);

  @override
  List<Recommendation>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Recommendation>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$_RecommendationsStoreActionController =
      ActionController(name: '_RecommendationsStore', context: context);

  @override
  void addRecommendation(Recommendation recommendation) {
    final _$actionInfo = _$_RecommendationsStoreActionController.startAction(
        name: '_RecommendationsStore.addRecommendation');
    try {
      return super.addRecommendation(recommendation);
    } finally {
      _$_RecommendationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void delRecommendation(Recommendation recommendation) {
    final _$actionInfo = _$_RecommendationsStoreActionController.startAction(
        name: '_RecommendationsStore.delRecommendation');
    try {
      return super.delRecommendation(recommendation);
    } finally {
      _$_RecommendationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRecommendations(List<Recommendation> recommendations) {
    final _$actionInfo = _$_RecommendationsStoreActionController.startAction(
        name: '_RecommendationsStore.setRecommendations');
    try {
      return super.setRecommendations(recommendations);
    } finally {
      _$_RecommendationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_RecommendationsStoreActionController.startAction(
        name: '_RecommendationsStore.clear');
    try {
      return super.clear();
    } finally {
      _$_RecommendationsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
