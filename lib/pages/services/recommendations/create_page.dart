import 'package:dom24x7_flutter/models/recommendation.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationCategoryItem {
  String text;
  String value;

  RecommendationCategoryItem(this.text, this.value);
}

class RecommendationCreatePage extends StatefulWidget {
  const RecommendationCreatePage({Key? key}) : super(key: key);

  @override
  State<RecommendationCreatePage> createState() => _RecommendationCreatePageState();
}

class _RecommendationCreatePageState extends State<RecommendationCreatePage> {
  late List<RecommendationCategoryItem> _recommendationCategories = [];
  RecommendationCategoryItem? _recommendationCategory;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      store.client.socket.emit('recommendation.categories', {}, (String name, dynamic error, dynamic data) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
          );
          return;
        }
        setState(() {
          for (var item in data) {
            _recommendationCategories.add(RecommendationCategoryItem(item['name'], item['id'].toString()));
          }
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, 'Создать рекомендацию'),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            DropdownButtonFormField<RecommendationCategoryItem>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Категория'
              ),
              value: _recommendationCategory,
              onChanged: (RecommendationCategoryItem? value) {
                setState(() {
                  _recommendationCategory = value!;
                });
              },
              items: _recommendationCategories.map<DropdownMenuItem<RecommendationCategoryItem>>((RecommendationCategoryItem value) {
                return DropdownMenuItem<RecommendationCategoryItem>(
                    value: value,
                    child: Text(value.text)
                );
              }).toList(),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Заголовок'
              )
            ),
            const TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Описание рекомендации'
              ),
            ),
            const TextField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                prefix: Text('+7 '),
                labelText: 'Телефон'
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                prefix: Text('https://'),
                labelText: 'Сайт'
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Эл. почта'
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Адрес'
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                prefix: Text('@'),
                labelText: 'Инстаграм'
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                prefix: Text('@'),
                labelText: 'Телеграм'
              ),
            ),
            ElevatedButton(
              onPressed: () => { },
              child: Text('Сохранить'.toUpperCase()),
            )
          ]
        )
      )
    );
  }
}
