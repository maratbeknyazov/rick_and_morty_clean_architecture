import 'package:dartz/dartz.dart'; 
// Импорт библиотеки dartz, которая позволяет работать с типом Either.
// Either – это тип, который возвращает либо ошибку (Left), либо успешный результат (Right).

import 'package:rick_and_morty_flutter_3/core/error/exception.dart'; 
// Импорт собственных исключений, например, ServerException и CacheException.

import 'package:rick_and_morty_flutter_3/core/error/failure.dart'; 
// Импорт собственных классов ошибок (Failure), которые используются вместо Exception внутри приложения.

import 'package:rick_and_morty_flutter_3/core/platform/network_info.dart'; 
// Импорт класса, который позволяет проверить, есть ли интернет-соединение.

import 'package:rick_and_morty_flutter_3/feature/data/datasources/person_local_data_source.dart'; 
// Импорт локального источника данных (чтение/запись в память устройства).

import 'package:rick_and_morty_flutter_3/feature/data/datasources/person_remote_data_source.dart'; 
// Импорт удалённого источника данных (получение данных с сервера).

import 'package:rick_and_morty_flutter_3/feature/data/models/person_model.dart'; 
// Импорт модели данных персонажа.

import 'package:rick_and_morty_flutter_3/feature/domain/entities/person_entity.dart'; 
// Импорт сущности персонажа, используемой в бизнес-логике.

import 'package:rick_and_morty_flutter_3/feature/domain/repositories/person_repository.dart'; 
// Импорт абстрактного репозитория, который определяет, какие методы должен реализовать репозиторий.

/// Реализация репозитория персонажей.
/// Репозиторий объединяет источники данных (локальный и удалённый)
/// и предоставляет данные в нужной форме доменному слою.
class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource; // Удалённый источник данных (сервер).
  final PersonLocalDataSource localDataSource;   // Локальный источник данных (память).
  final NetworkInfo networkInfo;                 // Проверка интернет-соединения.

  PersonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  // Конструктор, в который передаются необходимые зависимости (через Dependency Injection).

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    // Метод получает список персонажей с определённой страницы.
    return await _getPersons(() {
      return remoteDataSource.getAllPersons(page);
      // Передаём функцию, которая загрузит персонажей с сервера.
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    // Метод для поиска персонажей по запросу (например, по имени).
    return await _getPersons(() {
      return remoteDataSource.searchPerson(query);
      // Передаём функцию, которая выполнит поиск на сервере.
    });
  }

  /// Приватный вспомогательный метод для получения данных.
  /// Он проверяет подключение к интернету и решает, откуда брать данные – с сервера или из кэша.
  Future<Either<Failure, List<PersonModel>>> _getPersons(
      Future<List<PersonModel>> Function() getPersons) async {
    if (await networkInfo.isConnected) {
      // Если есть интернет-соединение:
      try {
        final remotePerson = await getPersons(); 
        // Получаем данные с сервера (вызов переданной функции).
        
        localDataSource.personsToCache(remotePerson);
        // Сохраняем полученные данные в кэш (локальную память), чтобы использовать оффлайн.

        return Right(remotePerson);
        // Возвращаем данные как успех (Right).
      } on ServerException {
        return Left(ServerFailure());
        // Если произошла ошибка на сервере, возвращаем её (Left).
      }
    } else {
      // Если интернета нет:
      try {
        final localPerson = await localDataSource.getLastPersonsFromCache();
        // Пытаемся получить данные из кэша.

        return Right(localPerson);
        // Возвращаем данные как успех (Right).
      } on CacheException {
        return Left(CacheFailure());
        // Если нет данных в кэше, возвращаем ошибку (Left).
      }
    }
  }
}


// 📡 remoteDataSource — источник данных из интернета.
// 💾 localDataSource — источник данных из памяти устройства.
// 🌐 networkInfo.isConnected — проверка, есть ли интернет.
// ✅ Right(...) — успешный результат (всё ок).
// ❌ Left(...) — ошибка (что-то пошло не так).
// ❓ Either<Failure, List<PersonEntity>> — либо ошибка, либо список персонажей.