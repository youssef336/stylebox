import 'package:flutter/material.dart';
import 'widgets/home_custom_bottom_navigation_bar.dart';

import 'widgets/main_view_body_bloc_listener.dart';
import '../../../ai_chat/presentation/views/ai_chat_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const String routeName = '/home';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AiChatView.routeName);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.smart_toy_outlined),
      ),
      bottomNavigationBar: HomeCustomBottomNavigationBar(
        onItemTapped: (int value) {
          currentViewIndex = value;
          setState(() {});
        },
      ),
      body: MainViewBodyBlocListener(currentViewIndex: currentViewIndex),
    );
  }
}
