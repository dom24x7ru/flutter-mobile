import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'flats.g.dart';

class FlatsStore = _FlatsStore with _$FlatsStore;

abstract class _FlatsStore with Store {
  @observable
  List<Flat>? list;

  @action
  void addFlat(Flat flat) {
    list = Utilities.addOrReplaceById(list, flat);
  }

  @action
  void setFlats(List<Flat> flats) {
    list = flats;
  }

  @action
  void clear() {
    list = null;
  }
}