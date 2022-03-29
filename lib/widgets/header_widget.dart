import 'package:flutter/material.dart';

// enum AppBarMenu { about, profile, invite, settings, spaces }
enum AppBarMenu { about, profile, invite, settings }

class Header extends AppBar {
  Header(BuildContext context, String title, {Key? key})
      : super(
          key: key,
          title: Row(
            children: [Text(title)],
          ),
          actions: [
            PopupMenuButton<AppBarMenu>(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem<AppBarMenu>(
                    value: AppBarMenu.about, child: Text('О приложении')),
                const PopupMenuDivider(),
                // const PopupMenuItem<AppBarMenu>(
                //     value: AppBarMenu.profile, child: Text('Профиль')),
                const PopupMenuItem<AppBarMenu>(
                    value: AppBarMenu.invite, child: Text('Приглашения')),
                const PopupMenuItem<AppBarMenu>(
                    value: AppBarMenu.settings, child: Text('Настройки')),
                // const PopupMenuItem<AppBarMenu>(
                //     value: AppBarMenu.spaces, child: Text('Помещения')),
              ],
              onSelected: (AppBarMenu item) {
                switch (item) {
                  case AppBarMenu.about:
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/about', (route) => false);
                    break;
                  case AppBarMenu.profile:
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/profile', (route) => false);
                    break;
                  case AppBarMenu.invite:
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/invite', (route) => false);
                    break;
                  case AppBarMenu.settings:
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/settings', (route) => false);
                    break;
                  // case AppBarMenu.spaces:
                  //   Navigator.pushNamedAndRemoveUntil(
                  //       context, '/spaces', (route) => false);
                  //   break;
                  default:
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                }
              },
            ),
          ],
        );
}
