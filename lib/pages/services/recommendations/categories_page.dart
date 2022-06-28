import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/recommendation/recommendation.dart';
import 'package:dom24x7_flutter/models/recommendation/recommendation_category.dart';
import 'package:dom24x7_flutter/pages/services/recommendations/create_page.dart';
import 'package:dom24x7_flutter/pages/services/recommendations/list_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/parallax_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationsCategoriesPage extends StatefulWidget {
  const RecommendationsCategoriesPage({Key? key}) : super(key: key);

  @override
  State<RecommendationsCategoriesPage> createState() => _RecommendationsCategoriesPageState();
}

class _RecommendationsCategoriesPageState extends State<RecommendationsCategoriesPage> {
  late List<RecommendationCategory> _categories = [];
  late List<Recommendation> _recommendations = [];
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _recommendations = store.recommendations.list != null ? store.recommendations.list! : [];
      _client = store.client;

      setState(() => _categories = _getCategories(_recommendations));
      var listener = _client.on('recommendations', this, (event, cont) {
        setState(() => _categories = _getCategories(_recommendations));
      });
      _listeners.add(listener);
    });
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      _client.off(listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    Widget? floatingActionButton;
    if (store.user.value!.residents.isNotEmpty) {
      floatingActionButton = FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const RecommendationCreatePage(null)));
            if (result == 'save') setState(() => _categories = _getCategories(_recommendations));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add)
      );
    }

    return Scaffold(
        appBar: Header.get(context, 'Рекомендации'),
        bottomNavigationBar: const Footer(FooterNav.services),
        floatingActionButton: floatingActionButton,
        body: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (BuildContext context, int index) {
              final category = _categories[index];
              return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendationsListPage(_getRecommendationsList(_recommendations, category)))),
                  child: ParallaxListItem(imageUrl: category.img, title: category.name, subtitle: 'Доступно: ${category.count}')
              );
            }
        )
    );
  }

  List<RecommendationCategory> _getCategories(List<Recommendation> recommendations) {
    Map<int, RecommendationCategory> categories = {};
    for (Recommendation item in recommendations) {
      if (categories[item.category.id] == null) {
        categories[item.category.id] = item.category;
        categories[item.category.id]!.count = 0;
      }
      categories[item.category.id]!.count++;
    }
    return categories.values.toList();
  }

  List<Recommendation> _getRecommendationsList(List<Recommendation> recommendations, RecommendationCategory category) {
    return recommendations.where((item) => item.category.id == category.id).toList();
  }
}
