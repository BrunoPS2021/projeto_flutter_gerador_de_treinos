import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_de_treinos/models/auth.dart';
import 'package:gerador_de_treinos/models/fitness_list.dart';
import 'package:gerador_de_treinos/models/training_list.dart';
import 'package:gerador_de_treinos/screens/fitness_form_screen.dart';
import 'package:gerador_de_treinos/screens/pdf_screen.dart';
import 'package:gerador_de_treinos/screens/training_overview_screen.dart';
import 'package:gerador_de_treinos/screens/fitness_screen.dart';
import 'package:gerador_de_treinos/screens/training_register_screen.dart';
import 'package:gerador_de_treinos/screens/training_screen.dart';
import 'package:gerador_de_treinos/utils/app_routes.dart';
import 'package:gerador_de_treinos/utils/default_material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        //SystemUiOverlay.bottom, // Shows Status bar and hides Navigation bar
      ],
    );
    final ThemeData tema = ThemeData();
    final DefaultMaterial defaultMaterial = DefaultMaterial();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, FitnessList>(
          create: (_) => FitnessList(),
          update: (ctx, auth, previous) {
            return FitnessList(
              auth.token ?? '',
              previous?.listFitness ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, TrainingList>(
          create: (_) => TrainingList(),
          update: (ctx, auth, previous) {
            return TrainingList(
              auth.token ?? '',
              previous?.listTraining ?? [],
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Gerador de Treinos',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: tema.colorScheme.copyWith(
            primary: Colors.cyan[500],
            secondary: Colors.lime[600],
          ),
          listTileTheme: tema.listTileTheme.copyWith(
            iconColor: Colors.lime[600],
          ),
          dividerTheme: tema.dividerTheme.copyWith(
            color: Colors.transparent,
          ),
          drawerTheme: tema.drawerTheme.copyWith(
            backgroundColor: Colors.amber[50],
          ),
          appBarTheme: tema.appBarTheme.copyWith(
            backgroundColor: Colors.cyan[500],
            foregroundColor: Colors.amber[50],
          ),
          scaffoldBackgroundColor: Colors.amber[50],
          switchTheme: tema.switchTheme.copyWith(
            thumbIcon: defaultMaterial.thumbIcon,
            thumbColor: defaultMaterial.thumbIconColor,
            trackColor: MaterialStatePropertyAll(Colors.amber[100]),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.HOME,
        routes: {
          AppRoutes.HOME: (ctx) => const TrainingOverviewScreen(),
          AppRoutes.FITNESS: (ctx) => const FitnessScreen(),
          AppRoutes.FITNESS_FORM: (ctx) => const FitnessFormScreen(),
          AppRoutes.TRAINING_REGISTER: (ctx) => const TrainingRegisterScreen(),
          AppRoutes.TRAINING: (ctx) => const TrainingScreen(),
          AppRoutes.PDF: (ctx) => const PdfScreen(),
        },
      ),
    );
  }
}
