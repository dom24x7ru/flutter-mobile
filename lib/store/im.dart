import 'package:dom24x7_flutter/models/im/im_channel.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'im.g.dart';

class IMStore = _IMStore with _$IMStore;

abstract class _IMStore with Store {
  @observable
  List<IMChannel>? channels;

  @action
  void addChannel(IMChannel channel) {
    channels = Utilities.addOrReplaceById(channels, channel);
  }

  @action
  void setChannels(List<IMChannel> channels) {
    this.channels = channels;
  }

  @action
  void clear() {
    channels = null;
  }
}