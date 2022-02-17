import 'package:flutter/material.dart';

// enum FooterNav { news, house, im, services }
enum FooterNav { news, house, services }

class Footer extends BottomNavigationBar {
  Footer(BuildContext context, FooterNav nav, {Key? key})
      : super(
          key: key,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Новости',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Соседи',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.forum),
            //   label: 'Мессенджер',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.blur_on),
              label: 'Сервисы',
            ),
          ],
          currentIndex: nav.index,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          showUnselectedLabels: false,
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                break;
              case 1:
                Navigator.pushNamedAndRemoveUntil(context, '/house', (route) => false);
                break;
              // case 2:
              //   Navigator.pushNamedAndRemoveUntil(context, '/im', (route) => false);
              //   break;
              case 2:
                Navigator.pushNamedAndRemoveUntil(context, '/services', (route) => false);
                break;
              default:
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          }
        );
}
