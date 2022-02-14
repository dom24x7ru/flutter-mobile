import 'package:dom24x7_flutter/models/faq_item.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'faq.g.dart';

class FAQ = _FAQ with _$FAQ;

abstract class _FAQ with Store {
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