import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/mutual_help_item.dart';
import 'package:dom24x7_flutter/pages/services/mutual_help/create_page.dart';
import 'package:dom24x7_flutter/pages/services/mutual_help/list_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/parallax_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MutualHelpCategoriesPage extends StatefulWidget {
  const MutualHelpCategoriesPage({Key? key}) : super(key: key);

  @override
  State<MutualHelpCategoriesPage> createState() => _MutualHelpCategoriesPageState();
}

class _MutualHelpCategoriesPageState extends State<MutualHelpCategoriesPage> {
  late List<MutualHelpCategory> _categories = [];
  late List<MutualHelpItem> _items = [];
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _items = store.mutualHelp.list != null ? store.mutualHelp.list! : [];
      _client = store.client;

      setState(() => _categories = _getCategories(_items));
      var listener = _client.on('mutualHelp', this, (event, cont) {
        setState(() => _categories = _getCategories(_items));
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
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MutualHelpCreatePage(null)));
            if (result == 'save') setState(() => _categories = _getCategories(_items));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add)
      );
    }

    return Scaffold(
        appBar: Header.get(context, 'Могу помочь'),
        bottomNavigationBar: const Footer(FooterNav.services),
        floatingActionButton: floatingActionButton,
        body: ListView.builder(
            itemCount: _categories.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Card(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    color: Colors.blue,
                    child: const Text('Сервис для безвозмездной помощи соседей друг другу', style: TextStyle(color: Colors.white)),
                  )
                );
              }
              final category = _categories[index - 1];
              return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MutualHelpListPage(_getMutualHelpList(_items, category)))),
                  child: ParallaxListItem(imageUrl: category.img, title: category.name, subtitle: 'Доступно: ${category.count}')
              );
            }
        )
    );
  }

  List<MutualHelpCategory> _getCategories(List<MutualHelpItem> items) {
    Map<int, MutualHelpCategory> categories = {};
    for (MutualHelpItem item in items) {
      if (categories[item.category.id] == null) {
        categories[item.category.id] = item.category;
        categories[item.category.id]!.count = 0;
      }
      categories[item.category.id]!.count++;
    }
    return categories.values.toList();
  }

  List<MutualHelpItem> _getMutualHelpList(List<MutualHelpItem> items, MutualHelpCategory category) {
    return items.where((item) => item.category.id == category.id).toList();
  }
}
