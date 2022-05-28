import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MutualHelpCategoriesPage extends StatefulWidget {
  const MutualHelpCategoriesPage({Key? key}) : super(key: key);

  @override
  State<MutualHelpCategoriesPage> createState() => _MutualHelpCategoriesPageState();
}

class _MutualHelpCategoriesPageState extends State<MutualHelpCategoriesPage> {
  late SocketClient _client;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    Widget? floatingActionButton;
    if (store.user.value!.residents.isNotEmpty) {
      floatingActionButton = FloatingActionButton(
          onPressed: () async {},
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add)
      );
    }

    return Scaffold(
      appBar: Header(context, 'Могу помочь'),
      bottomNavigationBar: const Footer(FooterNav.services),
      floatingActionButton: floatingActionButton,
    );
  }
}
