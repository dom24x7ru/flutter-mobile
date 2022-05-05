import 'package:dom24x7_flutter/models/recommendation.dart';
import 'package:dom24x7_flutter/pages/services/recommendations/create_page.dart';
import 'package:dom24x7_flutter/pages/services/recommendations/list_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/parallax_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationsCategoriesPage extends StatelessWidget {
  const RecommendationsCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final recommendations = store.recommendations.list!;
    final categories = _getCategories(recommendations);

    Widget? floatingActionButton;
    if (store.user.value!.residents.isNotEmpty) {
      floatingActionButton = FloatingActionButton(
          onPressed: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const RecommendationCreatePage())) },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add)
      );
    }

    return Scaffold(
      appBar: Header(context, 'Рекомендации'),
      bottomNavigationBar: const Footer(FooterNav.services),
      floatingActionButton: floatingActionButton,
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendationsListPage(_getRecommendationsList(recommendations, category)))) },
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
    List<Recommendation> list = [];
    for (Recommendation item in recommendations) {
      if (item.category.id == category.id) list.add(item);
    }
    return list;
  }
}
