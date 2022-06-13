import 'package:dom24x7_flutter/models/mutual_help_item.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MutualHelpCategoryItem {
  String text;
  String value;

  MutualHelpCategoryItem(this.text, this.value);
}

class MutualHelpCreatePage extends StatefulWidget {
  final MutualHelpItem? item;
  final MutualHelpCategory? category;
  const MutualHelpCreatePage(this.item, {Key? key, this.category}) : super(key: key);

  @override
  State<MutualHelpCreatePage> createState() => _MutualHelpCreatePageState();
}

class _MutualHelpCreatePageState extends State<MutualHelpCreatePage> {
  final List<MutualHelpCategoryItem> _mutualHelpCategories = [];
  MutualHelpCategoryItem? _mutualHelpCategory;

  late TextEditingController _cTitle;
  late TextEditingController _cBody;

  bool _btnEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _cTitle = TextEditingController();
    _cBody = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      store.client.socket.emit('mutualHelp.categories', {}, (String name, dynamic error, dynamic data) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
          );
          return;
        }
        setState(() {
          // загружаем список категорий
          for (var item in data) {
            _mutualHelpCategories.add(MutualHelpCategoryItem(item['name'], item['id'].toString()));
          }

          // теперь, если необходимо, можем инициализировать поля редактируемой помощи
          _initMutualHelpFields(widget.item, widget.category);
        });
      });
    });
  }

  @override
  void dispose() {
    _cTitle.dispose();
    _cBody.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final String title = widget.item != null ? 'Редактировать' : 'Создать помощь';

    return Scaffold(
        appBar: Header.get(context, title),
        bottomNavigationBar: const Footer(FooterNav.services),
        body: Container(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
                children: [
                  DropdownButtonFormField<MutualHelpCategoryItem>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                        labelText: 'Категория'
                    ),
                    value: _mutualHelpCategory,
                    onChanged: (MutualHelpCategoryItem? value) {
                      setState(() => _mutualHelpCategory = value!);
                      _calcBtnEnabled();
                    },
                    items: _mutualHelpCategories.map<DropdownMenuItem<MutualHelpCategoryItem>>((MutualHelpCategoryItem value) {
                      return DropdownMenuItem<MutualHelpCategoryItem>(
                          value: value,
                          child: Text(value.text)
                      );
                    }).toList(),
                  ),
                  TextField(
                      controller: _cTitle,
                      onChanged: (String value) => _calcBtnEnabled(),
                      decoration: const InputDecoration(
                          labelText: 'Заголовок'
                      )
                  ),
                  TextField(
                    controller: _cBody,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (String value) => _calcBtnEnabled(),
                    decoration: const InputDecoration(
                        labelText: 'Описание помощи'
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _btnEnabled && !_isLoading ? () => _save(context, store) : null,
                    child: Text('Сохранить'.toUpperCase()),
                  )
                ]
            )
        )
    );
  }

  void _calcBtnEnabled() {
    setState(() {
      _btnEnabled = _mutualHelpCategory != null // категория должна быть выбрана
          && _cTitle.text.trim().isNotEmpty // заголовок должен быть заполнен
          && _cBody.text.trim().isNotEmpty; // описание должно быть заполнено
    });
  }

  void _initMutualHelpFields(MutualHelpItem? item, MutualHelpCategory? category) {
    if (category != null) {
      setState(() {
        final dropdownCategory = _mutualHelpCategories.firstWhere((item) => item.value == category.id.toString());
        _mutualHelpCategory = dropdownCategory;
      });
    }
    if (item == null) return;
    setState(() {
      final category = item.category;
      final dropdownCategory = _mutualHelpCategories.firstWhere((item) => item.value == category.id.toString());
      _mutualHelpCategory = dropdownCategory;
    });

    _cTitle.text = item.title;
    _cBody.text = item.body;

    _calcBtnEnabled();
  }

  void _save(BuildContext context, MainStore store) {
    var data = {
      'id': widget.item != null ? widget.item!.id : null,
      'title': _cTitle.text.trim(),
      'body': _cBody.text.trim(),
      'categoryId': _mutualHelpCategory!.value,
    };
    setState(() => _isLoading = true);
    store.client.socket.emit('mutualHelp.save', data, (String name, dynamic error, dynamic data) {
      setState(() => _isLoading = false);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data != null && data['status'] == 'OK') {
        Navigator.pop(context, 'save');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось сохранить помощь. Попробуйте позже'), backgroundColor: Colors.red)
        );
      }
    });
  }
}
