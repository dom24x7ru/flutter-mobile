import 'package:dom24x7_flutter/models/recommendation.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'recommendations.g.dart';

class RecommendationsStore = _RecommendationsStore with _$RecommendationsStore;

abstract class _RecommendationsStore with Store {
  @observable
  List<Recommendation>? list;

  @action
  void addRecommendation(Recommendation recommendation) {
    list = Utilities.addOrReplaceById(list, recommendation);
  }

  @action
  void setRecommendations(List<Recommendation> recommendations) {
    list = recommendations;
  }

  @action
  void clear() {
    list = null;
  }
}