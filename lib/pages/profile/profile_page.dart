import 'package:dom24x7_flutter/pages/profile/widgets/profile_header.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.get(context, 'Профиль'),
      bottomNavigationBar: const Footer(FooterNav.news),
      body: const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(numberOfPosts: 0),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 24),
          )
        ]
      )
    );
  }
}