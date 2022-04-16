import 'package:dom24x7_flutter/pages/services/documents_page.dart';
import 'package:dom24x7_flutter/pages/services/faq/categories_page.dart';
import 'package:dom24x7_flutter/pages/services/recommendations/categories_page.dart';
import 'package:dom24x7_flutter/pages/services/votes/list_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'instructions/instructions_page.dart';

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
        bottomNavigationBar: const Footer(FooterNav.services),
        body: Container(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(crossAxisCount: 2, children: [
              ServiceCard('Инструкции',
                  count: store.instructions.list != null ? store.instructions.list!.length : 0,
                  color: Colors.blue,
                  onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const InstructionsPage())) }),
              ServiceCard('Документы',
                  count: store.documents.list != null ? store.documents.list!.length : 0,
                  color: Colors.red,
                  onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const DocumentsPage())) }),
              ServiceCard('Голосования',
                  count: store.votes.list != null ? store.votes.list!.length : 0,
                  color: Colors.green,
                  onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const VotesListPage())) }),
              ServiceCard('ЧаВо',
                  count: store.faq.list != null ? store.faq.list!.length : 0,
                  color: Colors.deepPurple,
                  onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQCategoriesPage())) }),
              ServiceCard('Рекомендации',
                  count: store.recommendations.list != null ? store.recommendations.list!.length : 0,
                  color: Colors.purpleAccent,
                  onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const RecommendationsCategoriesPage())) }),
            ])));
  }
}
