import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo(a)'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Treinos'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.HOME,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Exercícios'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.FITNESS,
              );
            },
          ),
        ],
      ),
    );
  }
}
