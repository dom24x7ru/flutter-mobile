import 'package:dom24x7_flutter/models/vote.dart';
import 'package:mobx/mobx.dart';

part 'votes.g.dart';

class VotesStore = _VotesStore with _$VotesStore;

abstract class _VotesStore with Store {
  @observable
  List<Vote>? list;

  @action
  void addVote(Vote vote) {
    list ??= [];
    list!.add(vote);
  }

  @action
  void clear() {
    list = null;
  }
}