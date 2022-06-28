import 'package:dom24x7_flutter/models/faq/faq_item.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'faq.g.dart';

class FAQStore = _FAQStore with _$FAQStore;

abstract class _FAQStore with Store {
  @observable
  List<FAQItem>? list;

  @action
  void addFAQItem(FAQItem item) {
    list = Utilities.addOrReplaceById(list, item);
  }

  @action
  void setFAQItems(List<FAQItem> items) {
    list = items;
  }

  @action
  void clear() {
    list = null;
  }
}