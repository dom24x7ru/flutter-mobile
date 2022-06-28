import 'package:dom24x7_flutter/models/miniapp/miniapp.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'miniapps.g.dart';

class MiniAppsStore = _MiniAppsStore with _$MiniAppsStore;

abstract class _MiniAppsStore with Store {
  @observable
  List<MiniApp>? list;

  @action
  void addMiniApp(MiniApp miniApp) {
    list = Utilities.addOrReplaceById(list, miniApp);
  }

  @action
  void setMiniApps(List<MiniApp> miniApps) {
    list = miniApps;
  }

  @action
  void clear() {
    list = null;
  }
}