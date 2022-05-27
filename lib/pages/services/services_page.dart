import 'package:dom24x7_flutter/pages/services/documents_page.dart';
import 'package:dom24x7_flutter/pages/services/faq/categories_page.dart';
import 'package:dom24x7_flutter/pages/services/miniapps/url_miniapp_page.dart';
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

  Color _getColor(String color) {
    switch (color) {
      case 'green': return Colors.green;
      case 'purpleAccent': return Colors.purpleAccent;
      case 'cyan': return Colors.cyan;
      case 'deepPurple': return Colors.deepPurple;
      case 'blue': return Colors.blue;
      case 'red': return Colors.red;
    }
    return Colors.black12;
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    final Map<String, dynamic> inlineMiniApps = {
      'votes': { 'page': const VotesListPage(), 'count': store.votes.list != null ? store.votes.list!.length : 0 },
      'recommendations': { 'page': const RecommendationsCategoriesPage(), 'count': store.recommendations.list != null ? store.recommendations.list!.length : 0 },
      'instructions': { 'page': const InstructionsPage(), 'count': store.instructions.list != null ? store.instructions.list!.length : 0 },
      'documents': { 'page': const DocumentsPage(), 'count': store.documents.list != null ? store.documents.list!.length : 0 },
      'faq': { 'page': const FAQCategoriesPage(), 'count': store.faq.list != null ? store.faq.list!.length : 0 }
    };

    List<Widget> miniapps = [];
    final miniApps = store.miniApps.list != null ? store.miniApps.list! : [];
    for (var miniapp in miniApps) {
      if (miniapp.type.code == 'inline') {
        miniapps.add(
          ServiceCard(miniapp.title,
            count: inlineMiniApps[miniapp.extra.code]['count'],
            color: _getColor(miniapp.extra.color),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => inlineMiniApps[miniapp.extra.code]['page']))
          )
        );
      } else if (miniapp.type.code == 'external') {
        // TODO: доработать когда появятся такие миниприложения
      } else if (miniapp.type.code == 'url') {
        miniapps.add(
          ServiceCard(miniapp.title,
            color: _getColor(miniapp.extra.color),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UrlMiniAppPage(miniapp.title, miniapp.extra.url!)))
          )
        );
      }
    }

    return Scaffold(
        appBar: Header(context, 'Сервисы'),
        bottomNavigationBar: const Footer(FooterNav.services),
        body: Container(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(crossAxisCount: 2, children: miniapps)
        )
    );
  }
}
