import 'package:dom24x7_flutter/models/mutual_help/mutual_help_item.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'mutual_help.g.dart';

class MutualHelpStore = _MutualHelpStore with _$MutualHelpStore;

abstract class _MutualHelpStore with Store {
  @observable
  List<MutualHelpItem>? list;

  @action
  void addMutualHelpItem(MutualHelpItem item) {
    list = Utilities.addOrReplaceById(list, item);
  }

  @action
  void delMutualHelpItem(MutualHelpItem item) {
    list = Utilities.deleteById(list, item);
  }

  @action
  void setMutualHelpItems(List<MutualHelpItem> items) {
    list = items;
  }

  @action
  void clear() {
    list = null;
  }
}