import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

enum FooterNav { news, house, im, services }

class Footer extends StatefulWidget {
  final FooterNav nav;
  const Footer(this.nav, {Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
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
          BottomNavigationBarItem(
            // icon: Icon(Icons.forum),
            icon: Badge(
              badgeContent: const Text('3'),
              badgeColor: Colors.white54,
              child: const Icon(Icons.forum),
            ),
            label: 'Мессенджер',
          ),
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
}