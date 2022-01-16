import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/in_development_info_widget.dart';
import 'package:flutter/material.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, 'Приглашения'),
      bottomNavigationBar: Footer(context, FooterNav.news),
      body: const InDevelopmentInfo(),
    );
  }
}