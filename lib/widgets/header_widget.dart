import 'package:dom24x7_flutter/pages/house/flat_page.dart';
import 'package:dom24x7_flutter/pages/services/noise_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// enum AppBarMenu { about, profile, invite, settings, spaces }
enum AppBarMenu { about, profile, invite, settings, feedback }
enum FlatSearchMenu { ownerFlat, topFlat, bottomFlat }

class Header {
  static AppBar get(BuildContext context, String title) {
    final store = Provider.of<MainStore>(context);
    final miniApps = store.miniApps.list;

    final actions = <Widget>[
      PopupMenuButton<FlatSearchMenu>(
          icon: const Icon(Icons.search),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<FlatSearchMenu>(
                value: FlatSearchMenu.ownerFlat, child: Text('Моя квартира')),
            const PopupMenuItem<FlatSearchMenu>(
                value: FlatSearchMenu.topFlat, child: Text('Квартира сверху')),
            const PopupMenuItem<FlatSearchMenu>(
                value: FlatSearchMenu.bottomFlat, child: Text('Квартира снизу'))
          ],
          onSelected: (FlatSearchMenu item) async {
            switch (item) {
              case FlatSearchMenu.ownerFlat:
                Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage.owner()));
                break;
              case FlatSearchMenu.topFlat:
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage.top()));
                if (result != null && result['error'] != null) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['error']), backgroundColor: Colors.red)
                    );
                  });
                }
                break;
              case FlatSearchMenu.bottomFlat:
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage.bottom()));
                if (result != null && result['error'] != null) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['error']), backgroundColor: Colors.red)
                    );
                  });
                }
                break;
              default:
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          }
      ),
      PopupMenuButton<AppBarMenu>(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<AppBarMenu>(
            value: AppBarMenu.about, child: Text('О приложении')
          ),
          const PopupMenuDivider(),
          // const PopupMenuItem<AppBarMenu>(
          //   value: AppBarMenu.profile, child: Text('Профиль')),
          const PopupMenuItem<AppBarMenu>(
            value: AppBarMenu.invite, child: Text('Приглашения')
          ),
          const PopupMenuItem<AppBarMenu>(
            value: AppBarMenu.settings, child: Text('Настройки')
          ),
          // const PopupMenuItem<AppBarMenu>(
          //   value: AppBarMenu.spaces, child: Text('Помещения')),
          const PopupMenuItem<AppBarMenu>(
            value: AppBarMenu.feedback, child: Text('Обратная связь')
          ),
        ],
        onSelected: (AppBarMenu item) {
          switch (item) {
            case AppBarMenu.about:
              Navigator.pushNamedAndRemoveUntil(context, '/about', (route) => false);
              break;
            case AppBarMenu.profile:
              Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
              break;
            case AppBarMenu.invite:
              Navigator.pushNamedAndRemoveUntil(context, '/invite', (route) => false);
              break;
            case AppBarMenu.settings:
              Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false);
              break;
          // case AppBarMenu.spaces:
          //   Navigator.pushNamedAndRemoveUntil(context, '/spaces', (route) => false);
          //   break;
            case AppBarMenu.feedback:
              Navigator.pushNamedAndRemoveUntil(context, '/feedback', (route) => false);
              break;
            default:
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
      ),
    ];
    if (miniApps != null && miniApps.where((miniApp) => miniApp.extra.code == 'noise').isNotEmpty) {
      actions.insert(1, IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NoisePage())),
          icon: const Icon(Icons.ads_click_outlined)
      ));
    }

    return AppBar(title: Row(children: [Text(title)]), actions: actions);
  }
}
