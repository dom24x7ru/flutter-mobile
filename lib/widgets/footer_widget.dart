import 'package:badges/badges.dart';
import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FooterNav { news, house, im, services }

class Footer extends StatefulWidget {
  final FooterNav nav;
  const Footer(this.nav, {Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  late int _msgCount = 0;
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      setState(() {
        _msgCount = getMsgCount(store.im.channels);
      });

      _client = store.client;
      var listener = _client.on('imChannel', this, (event, cont) {
        setState(() {
          _msgCount = getMsgCount(store.im.channels);
        });
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
    BottomNavigationBarItem barItem = const BottomNavigationBarItem(
      icon: Icon(Icons.forum),
      label: 'Соседи',
    );
    if (_msgCount != 0) {
      barItem = BottomNavigationBarItem(
        // icon: Icon(Icons.forum),
        icon: Badge(
          badgeContent: Text('$_msgCount'),
          badgeColor: Colors.white54,
          child: const Icon(Icons.forum),
        ),
        label: 'Мессенджер',
      );
    }

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Новости',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Соседи',
          ),
          barItem,
          const BottomNavigationBarItem(
            icon: Icon(Icons.blur_on),
            label: 'Сервисы',
          ),
        ],
        currentIndex: widget.nav.index,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(context, '/house', (route) => false);
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(context, '/im', (route) => false);
              break;
            case 3:
              Navigator.pushNamedAndRemoveUntil(context, '/services', (route) => false);
              break;
            default:
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
    );
  }

  int getMsgCount(List<IMChannel>? channels) {
    int count = 0;
    if (channels == null || channels.isEmpty) return count;
    for (var channel in channels) {
      count += channel.count;
    }
    return count;
  }
}