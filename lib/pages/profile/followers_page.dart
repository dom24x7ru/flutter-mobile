import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/profile/widgets/user_profile.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DataType { followers, following }

class FollowersPage extends StatefulWidget {
  const FollowersPage({Key? key, required this.type}) : super(key: key);

  final DataType type;

  static Route route({ required DataType type }) =>
      MaterialPageRoute(builder: (context) => FollowersPage(type: type));

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  late SocketClient _client;
  late List<IMPerson> _persons;
  late List<IMPerson> _following;

  @override
  void initState() {
    super.initState();
    setState(() => _persons = []);
    setState(() => _following = []);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      _client.socket.emit('social.${widget.type.name}', {}, (String name, dynamic error, dynamic data) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
          );
          return;
        }
        if (data != null && data['status'] == 'OK') {
          for (var personMap in data[widget.type.name]) {
            final person = IMPerson.fromMap(personMap);
            setState(() => _persons.add(person));
            if (widget.type == DataType.following) {
              setState(() => _following.add(person));
            }
          }
        }
      });

      if (widget.type == DataType.followers) {
        _client.socket.emit('social.following', {}, (String name, dynamic error, dynamic data) {
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
            );
            return;
          }
          if (data != null && data['status'] == 'OK') {
            for (var personMap in data['following']) {
              final person = IMPerson.fromMap(personMap);
              setState(() => _following.add(person));
            }
          }
        });
      }
    });
  }

  bool _isFollowing(IMPerson user) {
    return _following.where((item) => item.person.id == user.person.id).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type == DataType.followers ? 'Подписчики' : 'Подписки';
    return Scaffold(
      appBar: Header.get(context, Utilities.getHeaderTitle(title)),
      body: ListView.builder(
        itemCount: _persons.length,
        itemBuilder: (BuildContext context, int index) {
          final person = _persons[index];
          return UserProfile(user: person, isFollowing: _isFollowing(person));
        }
      )
    );
  }
}
