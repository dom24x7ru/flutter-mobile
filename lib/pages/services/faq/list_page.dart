import 'package:dom24x7_flutter/models/faq_item.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utilities.dart';

class FAQListPage extends StatelessWidget {
  final List<FAQItem> list;
  const FAQListPage(this.list, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryName = list.isNotEmpty ? list[0].category.name : null;

    return Scaffold(
      appBar: Header(context, categoryName != null ? Utilities.getHeaderTitle(categoryName) : 'Неизвестная категория'),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: ListView.separated(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          final FAQItem item = list[index];
          return ListTile(
            title: Text(item.title),
            onTap: () => { showFAQItem(context, item) }
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        }
      )
    );
  }

  void showFAQItem(BuildContext context, FAQItem item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 35.0),
                ),
                Text(item.title, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                Html(data: item.body, onLinkTap: (String? url, RenderContext context,  Map<String, String> attributes, dynamic element) {
                  if (url != null) launchUrl(Uri.parse(url));
                })
              ]
          )
        );
      },
      isScrollControlled: true
    );
  }
}
