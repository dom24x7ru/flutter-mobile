import 'package:dom24x7_flutter/pages/services/documents_page.dart';
import 'package:dom24x7_flutter/pages/services/faq/categories_page.dart';
import 'package:dom24x7_flutter/pages/services/miniapps/a3_miniapp.dart';
import 'package:dom24x7_flutter/pages/services/miniapps/dobrodel_miniapp.dart';
import 'package:dom24x7_flutter/pages/services/miniapps/pik_comfort_miniapp.dart';
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
    final children = [
      Text(title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold
        )
      )
    ];
    if (count > 0) {
      children.add(Text('Доступно: $count', style: const TextStyle(color: Colors.white)));
    }
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            color: color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
            )
          ),
        )
    );
  }
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    List<Widget> widgets = [
      ServiceCard('Голосования',
        count: store.votes.list != null ? store.votes.list!.length : 0,
        color: Colors.green,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VotesListPage()))
      ),
      ServiceCard('Рекомендации',
        count: store.recommendations.list != null ? store.recommendations.list!.length : 0,
        color: Colors.purpleAccent,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RecommendationsCategoriesPage()))
      ),
      ServiceCard('Добродел',
        color: Colors.cyan,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DobrodelMiniApp()))
      ),
      ServiceCard('Коммунальные платежи',
        color: Colors.deepPurple,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const A3MiniApp()))
      ),
      ServiceCard('ПИК-Комфорт',
        color: Colors.green,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PIKComfortMiniApp()))
      ),
    ];

    final instructionsCount = store.instructions.list != null ? store.instructions.list!.length : 0;
    if (instructionsCount > 0) {
      widgets.add(
        ServiceCard('Инструкции',
          count: instructionsCount,
          color: Colors.blue,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InstructionsPage()))
        )
      );
    }
    final documentsCount = store.documents.list != null ? store.documents.list!.length : 0;
    if (documentsCount > 0) {
      widgets.add(
        ServiceCard('Документы',
          count: documentsCount,
          color: Colors.red,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DocumentsPage()))
        )
      );
    }

    final faqCount = store.faq.list != null ? store.faq.list!.length : 0;
    if (faqCount > 0) {
      widgets.add(
        ServiceCard('ЧаВо',
          count: faqCount,
          color: Colors.deepPurple,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQCategoriesPage())))
      );
    }

    return Scaffold(
        appBar: Header(context, 'Сервисы'),
        bottomNavigationBar: const Footer(FooterNav.services),
        body: Container(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(crossAxisCount: 2, children: widgets)
        )
    );
  }
}
