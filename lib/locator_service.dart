import 'package:get_it/get_it.dart';
// Импорт библиотеки get_it — это сервис-локатор для управления зависимостями.
// Позволяет удобно регистрировать и получать нужные классы.

import 'package:internet_connection_checker/internet_connection_checker.dart';
// Импорт пакета, который проверяет наличие интернета.

import 'package:rick_and_morty_flutter_3/core/platform/network_info.dart';
// Импорт интерфейса и реализации проверки интернета (обёртка над InternetConnectionChecker).

import 'package:rick_and_morty_flutter_3/feature/data/datasources/person_local_data_source.dart';
// Импорт локального источника данных (кэш в SharedPreferences).

import 'package:rick_and_morty_flutter_3/feature/data/datasources/person_remote_data_source.dart';
// Импорт удалённого источника данных (запросы по сети через http).

import 'package:rick_and_morty_flutter_3/feature/domain/repositories/person_repository.dart';
// Импорт интерфейса репозитория (доменный слой).

import 'package:shared_preferences/shared_preferences.dart';
// Импорт SharedPreferences — кэш-хранилище, встроенное в устройство.

import 'feature/data/repositories/person_repository_impl.dart';
// Импорт реализации репозитория.

import 'feature/domain/usecases/get_all_persons.dart';
// Импорт use case, который получает список всех персонажей.

import 'feature/domain/usecases/search_person.dart';
// Импорт use case, который ищет персонажей по запросу.

import 'feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
// Импорт Cubit, управляющего списком персонажей.

import 'feature/presentation/bloc/search_bloc/search_bloc.dart';
// Импорт BLoC, управляющего логикой поиска.

import 'package:http/http.dart' as http;
// Импорт http-клиента, с помощью которого делаются сетевые запросы.

final sl = GetIt.instance;
// Создаём глобальный объект sl (service locator), через который будем регистрировать и получать зависимости.

Future<void> init() async {
  // ========== BLoC / Cubit ==========
  // Регистрируем PersonListCubit, чтобы можно было получить его в любой части приложения.
  // getAllPersons автоматически подтянется из sl (ниже он зарегистрирован).
  sl.registerFactory(
    () => PersonListCubit(getAllPersons: sl<GetAllPersons>()),
  );

  // Регистрируем SearchBloc (для поиска персонажей).
  sl.registerFactory(
    () => PersonSearchBloc(searchPerson: sl()),
  );

  // ========== UseCases ==========
  // Регистрируем GetAllPersons и SearchPerson как одиночки (lazySingleton).
  // Они создаются один раз при первом вызове.
  sl.registerLazySingleton(() => GetAllPersons(sl()));
  sl.registerLazySingleton(() => SearchPerson(sl()));

  // ========== Repository ==========
  // Регистрируем реализацию репозитория PersonRepositoryImpl.
  // Он требует три зависимости: remoteDataSource, localDataSource и networkInfo.
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
      remoteDataSource: sl(),  // подтянется PersonRemoteDataSource
      localDataSource: sl(),   // подтянется PersonLocalDataSource
      networkInfo: sl(),       // подтянется NetworkInfo
    ),
  );

  // ========== Data Sources ==========
  // Удалённый источник данных (делает запросы в интернет).
  sl.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(
      client: sl(),  // http.Client
    ),
  );

  // Локальный источник данных (SharedPreferences).
  sl.registerLazySingleton<PersonLocalDataSource>(
    () => PersonLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ========== Core ==========
  // Класс, проверяющий наличие интернета.
  // Используется в репозитории, чтобы понять, нужно ли брать данные из сети или из кэша.
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(sl()),  // внутрь передаётся InternetConnectionChecker
  );

  // ========== External (внешние зависимости) ==========
  // Получаем SharedPreferences (асинхронно, поэтому await).
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Регистрируем http-клиент для сетевых запросов.
  sl.registerLazySingleton(() => http.Client());

  // Регистрируем проверку интернета.
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

// Объяснение для новичка:
// get_it — это сервис-локатор, он позволяет один раз зарегистрировать нужный объект, а потом получать его где угодно, не создавая вручную.
// В этом файле:
// 📦 Регистрируются BLoC-и (логика для экрана),
// ⚙️ Use Case-ы (одна конкретная бизнес-операция),
// 🗂 Репозиторий (отвечает за работу с данными),
// 📡 Источники данных (локальный и сетевой),
// 🔌 Внешние зависимости: SharedPreferences, http-клиент и проверка интернета.
// Всё это связывается между собой — и приложение становится легко управляемым и расширяемым.