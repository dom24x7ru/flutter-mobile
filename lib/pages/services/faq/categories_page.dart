import 'package:dom24x7_flutter/models/faq_item.dart';
import 'package:dom24x7_flutter/pages/services/faq/list_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FAQCategoriesPage extends StatelessWidget {
  const FAQCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final faq = store.faq.list!;
    final categories = getCategories(faq);

    return Scaffold(
      appBar: Header(context, 'ЧаВо'),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: ListView.separated(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.name),
            subtitle: category.description != null ? Text(category.description!) : null,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FAQListPage(getFAQList(faq, category))))
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        }
      ),
    );
  }

  List<FAQCategory> getCategories(List<FAQItem> list) {
    Map<int, FAQCategory> categories = {};
    for (FAQItem item in list) {
      if (categories[item.category.id] == null) categories[item.category.id] = item.category;
    }
    return categories.values.toList();
  }

  List<FAQItem> getFAQList(List<FAQItem> faqItems, FAQCategory category) {
    List<FAQItem> list = [];
    for (FAQItem item in faqItems) {
      if (item.category.id == category.id) {
        list.add(item);
      }
    }
    return list;
  }
}
