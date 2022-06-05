import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final documents = store.documents.list!;

    return Scaffold(
      appBar: Header(context, 'Документы'),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          final document = documents[index];
          return ListTile(
            leading: const Icon(Icons.description),
            title: Text(document.title),
            subtitle: document.annotation != null ? Text(document.annotation!) : null,
            onTap: () => launchUrl(Uri.parse(document.url))
          );
        }
      )
    );
  }
}
