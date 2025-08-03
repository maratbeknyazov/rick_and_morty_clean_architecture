import 'package:flutter/material.dart';
// Импорт основного пакета Flutter — нужен для построения UI.

import 'package:flutter_bloc/flutter_bloc.dart';
// Импорт библиотеки flutter_bloc — используется для управления состоянием (BLoC и Cubit).

import 'package:rick_and_morty_flutter_3/common/app_colors.dart';
// Импорт файла с цветами приложения — используется в оформлении темы.

import 'package:rick_and_morty_flutter_3/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
// Импорт Cubit, который управляет загрузкой списка персонажей.

import 'package:rick_and_morty_flutter_3/feature/presentation/bloc/search_bloc/search_bloc.dart';
// Импорт BLoC, который обрабатывает поиск персонажей.

import 'package:rick_and_morty_flutter_3/locator_service.dart' as di;
// Импорт файла с зависимостями (DI = Dependency Injection) под псевдонимом `di` для инициализации.

import 'feature/presentation/pages/person_screen.dart';
// Импорт экрана, который будет открыт при запуске приложения.

import 'locator_service.dart';
// Импорт `sl` — глобального сервис-локатора, через который мы получаем зависимости (например, Cubit/BLoC).

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Обязательно вызываем, если в main есть асинхронный код до runApp (например, инициализация зависимостей).

  await di.init();
  // Вызываем метод init() из locator_service.dart, чтобы зарегистрировать все зависимости через GetIt.

  runApp(const MyApp());
  // Запускаем главное приложение.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // StatelessWidget — главный виджет приложения, который не меняется во время жизни приложения.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // MultiBlocProvider позволяет подключить сразу несколько BLoC или Cubit к дереву виджетов.

      providers: [
        BlocProvider<PersonListCubit>(
          create: (context) => sl<PersonListCubit>()..loadPerson(),
          // Получаем PersonListCubit из сервис-локатора (sl) и сразу запускаем загрузку персонажей.
        ),
        BlocProvider<PersonSearchBloc>(
          create: (context) => sl<PersonSearchBloc>(),
          // Получаем PersonSearchBloc для логики поиска.
        ),
      ],

      child: MaterialApp(
        // Обёртка над всем приложением, в ней задаются тема и стартовый экран.

        theme: ThemeData.dark().copyWith(
          // Используем тёмную тему, но настраиваем фон на свой цвет.

          primaryColor: AppColors.mainBackground,
          scaffoldBackgroundColor: AppColors.mainBackground,
          // Цвет фона всего экрана и appbar'а.
        ),

        home: const HomePage(),
        // Начальный экран, который будет открыт при запуске.
      ),
    );
  }
}


// 🧠 Объяснение для новичка:
// 🔧 В main() ты инициализируешь зависимости (через init()), чтобы можно было в любом месте приложения использовать sl<ИмяКласса>().
// 📦 Через MultiBlocProvider ты передаёшь в MaterialApp сразу два компонента:
// PersonListCubit — для загрузки списка персонажей (например, при прокрутке вниз).
// PersonSearchBloc — для логики поиска.
// 🎨 ThemeData.dark().copyWith(...) позволяет изменить стандартную тёмную тему под стили твоего приложения.
// 📱 Стартовая страница — HomePage() (она определена в person_screen.dart).