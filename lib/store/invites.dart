import 'package:dom24x7_flutter/models/house/invite.dart';
import 'package:mobx/mobx.dart';

part 'invites.g.dart';

class InvitesStore = _InvitesStore with _$InvitesStore;

abstract class _InvitesStore with Store {
  @observable
  List<Invite>? list;

  @action
  void setInvites(List<Invite> invites) {
    list = invites;
  }

  @action
  void clear() {
    list = null;
  }
}