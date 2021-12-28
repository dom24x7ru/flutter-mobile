import 'package:dom24x7_flutter/models/version.dart';
import 'package:mobx/mobx.dart';

part 'version.g.dart';

class VersionStore = _VersionStore with _$VersionStore;

abstract class _VersionStore with Store {
  @observable
  Version? current;

  @action
  void setVersion(Version? version) {
    current = version;
  }

  @action
  void clear() {
    current = null;
  }
}