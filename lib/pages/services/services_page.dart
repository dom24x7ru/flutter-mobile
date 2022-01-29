import 'package:dom24x7_flutter/pages/services/documents_page.dart';
import 'package:dom24x7_flutter/pages/services/faq_categories_page.dart';
import 'package:dom24x7_flutter/pages/services/recommendations_page.dart';
import 'package:dom24x7_flutter/pages/services/votes_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'instructions_page.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final int count;
  final Function()? onTap;
  final Color? color;

  const ServiceCard(this.title,
      {Key? key, this.count = 0, this.onTap, this.color = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              padding: const EdgeInsets.all(15.0),
              color: color,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                    Text('Доступно: $count',
                        style: const TextStyle(color: Colors.white))
                  ])),
        ));
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    return Scaffold(
        appBar: Header(context, 'Сервисы'),
        bottomNavigationBar: Footer(context, FooterNav.services),
        body: Container(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(crossAxisCount: 2, children: [
              ServiceCard('Инструкции',
                  count: store.instructions.list!.length,
                  color: Colors.blue,
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InstructionsPage()))
                      }),
              ServiceCard('Документы',
                  count: store.documents.list!.length,
                  color: Colors.red,
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DocumentsPage()))
                  }),
              ServiceCard('Голосования',
                  count: 0,
                  color: Colors.green,
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VotesPage()))
                  }),
              ServiceCard('ЧаВо',
                  count: store.faq.list!.length,
                  color: Colors.deepPurple,
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FAQCategoriesPage()))
                  }),
              ServiceCard('Рекомендации',
                  count: store.recommendations.list!.length,
                  color: Colors.purpleAccent,
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecommendationsPage()))
                  }),
            ])));
  }
}
