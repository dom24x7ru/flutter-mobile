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
  final List<RecommendationCategoryItem> _recommendationCategories = [];
  RecommendationCategoryItem? _recommendationCategory;

  late TextEditingController _cTitle;
  late TextEditingController _cBody;
  late TextEditingController _cPhone;
  late TextEditingController _cSite;
  late TextEditingController _cEmail;
  late TextEditingController _cAddress;
  late TextEditingController _cInstagram;
  late TextEditingController _cTelegram;

  bool _btnEnabled = false;

  @override
  void initState() {
    super.initState();

    _cTitle = TextEditingController();
    _cBody = TextEditingController();
    _cPhone = TextEditingController();
    _cSite = TextEditingController();
    _cEmail = TextEditingController();
    _cAddress = TextEditingController();
    _cInstagram = TextEditingController();
    _cTelegram = TextEditingController();

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
    _cTitle.dispose();
    _cBody.dispose();
    _cPhone.dispose();
    _cSite.dispose();
    _cEmail.dispose();
    _cAddress.dispose();
    _cInstagram.dispose();
    _cTelegram.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
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
                _calcBtnEnabled();
              },
              items: _recommendationCategories.map<DropdownMenuItem<RecommendationCategoryItem>>((RecommendationCategoryItem value) {
                return DropdownMenuItem<RecommendationCategoryItem>(
                    value: value,
                    child: Text(value.text)
                );
              }).toList(),
            ),
            TextField(
              controller: _cTitle,
              onChanged: (String value) => { _calcBtnEnabled() },
              decoration: const InputDecoration(
                labelText: 'Заголовок'
              )
            ),
            TextField(
              controller: _cBody,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (String value) => { _calcBtnEnabled() },
              decoration: const InputDecoration(
                labelText: 'Описание рекомендации'
              ),
            ),
            TextField(
              controller: _cPhone,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                prefix: Text('+7 '),
                labelText: 'Телефон'
              ),
            ),
            TextField(
              controller: _cSite,
              decoration: const InputDecoration(
                prefix: Text('https://'),
                labelText: 'Сайт'
              ),
            ),
            TextField(
              controller: _cEmail,
              decoration: const InputDecoration(
                labelText: 'Эл. почта'
              ),
            ),
            TextField(
              controller: _cAddress,
              decoration: const InputDecoration(
                labelText: 'Адрес'
              ),
            ),
            TextField(
              controller: _cInstagram,
              decoration: const InputDecoration(
                prefix: Text('@'),
                labelText: 'Инстаграм'
              ),
            ),
            TextField(
              controller: _cTelegram,
              decoration: const InputDecoration(
                prefix: Text('@'),
                labelText: 'Телеграм'
              ),
            ),
            ElevatedButton(
              onPressed: _btnEnabled ? () => { save(context, store) } : null,
              child: Text('Сохранить'.toUpperCase()),
            )
          ]
        )
      )
    );
  }

  void _calcBtnEnabled() {
    setState(() {
      _btnEnabled = _recommendationCategory != null // категория должна быть выбрана
          && _cTitle.text.trim().isNotEmpty // заголовок должен быть заполнен
          && _cBody.text.trim().isNotEmpty; // описание должно быть заполнено
    });
  }

  void save(BuildContext context, MainStore store) {
    var data = {
      'id': null,
      'title': _cTitle.text.trim(),
      'body': _cBody.text.trim(),
      'categoryId': _recommendationCategory!.value,
      'extra': {
        'phone': _cPhone.text.trim().isNotEmpty ? '7${_cPhone.text.trim()}' : null,
        'site': _cSite.text.trim().isNotEmpty ? _cSite.text.trim() : null,
        'email': _cEmail.text.trim().isNotEmpty ? _cEmail.text.trim() : null,
        'address': _cAddress.text.trim().isNotEmpty ? _cAddress.text.trim() : null,
        'instagram': _cInstagram.text.trim().isNotEmpty ? _cInstagram.text.trim() : null,
        'telegram': _cTelegram.text.trim().isNotEmpty ? _cTelegram.text.trim() : null
      }
    };
    store.client.socket.emit('recommendation.save', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data != null && data['status'] == 'OK') {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось сохранить рекомендацию. Попробуйте позже'), backgroundColor: Colors.red)
        );
      }
    });
  }
}
