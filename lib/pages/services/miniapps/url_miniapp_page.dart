import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/pages/services/miniapps/url_miniapp.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UrlMiniAppPage extends StatefulWidget {
  final int miniappId;
  final String title;
  final String url;
  const UrlMiniAppPage(this.miniappId, this.title, this.url, {Key? key}) : super(key: key);

  @override
  State<UrlMiniAppPage> createState() => _UrlMiniAppPageState();
}

class _UrlMiniAppPageState extends State<UrlMiniAppPage> {
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
    _client.socket.emit('miniapp.setAction', { 'miniappId': widget.miniappId, 'action': 'close' });

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.get(context, Utilities.getHeaderTitle(widget.title)),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: UrlMiniApp(url: widget.url)
    );
  }
}
