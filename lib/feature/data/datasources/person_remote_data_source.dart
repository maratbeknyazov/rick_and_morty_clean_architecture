// ignore_for_file: avoid_print
// Эта строка говорит Dart-линтеру не ругаться на использование print (что обычно не рекомендуется в продакшене).

// Импортируем стандартную библиотеку для работы с JSON (декодирование строки в объекты).
import 'dart:convert';

// Импортируем http-пакет, чтобы делать запросы к интернету.
import 'package:http/http.dart' as http;

// Импортируем наше пользовательское исключение ServerException.
import 'package:rick_and_morty_flutter_3/core/error/exception.dart';

// Импортируем модель персонажа, чтобы преобразовывать данные из JSON в объекты.
import 'package:rick_and_morty_flutter_3/feature/data/models/person_model.dart';

// Абстрактный класс (интерфейс), который описывает, какие методы должен реализовать источник данных из интернета.
// Он работает с API Rick and Morty и должен уметь:
// - Получать всех персонажей по страницам
// - Искать персонажей по имени
abstract class PersonRemoteDataSource {
  /// Отправляет запрос на https://rickandmortyapi.com/api/character/?page=1
  ///
  /// Если возникает ошибка (например, код ответа не 200), выбрасывает [ServerException].
  Future<List<PersonModel>> getAllPersons(int page);

  /// Отправляет запрос на https://rickandmortyapi.com/api/character/?name=rick
  ///
  /// Если возникает ошибка (например, персонаж не найден или сервер вернул ошибку), выбрасывает [ServerException].
  Future<List<PersonModel>> searchPerson(String query);
}

// Класс, который реализует интерфейс выше.
// Именно в нём пишется конкретная логика получения данных с API.
class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  // http.Client — это объект, через который отправляются запросы к серверу.
  final http.Client client;

  // Конструктор класса. Через него передаётся http.Client.
  PersonRemoteDataSourceImpl({required this.client});

  // Метод, реализующий получение всех персонажей.
  // Просто вызывает вспомогательный метод _getPersonFromUrl с нужной ссылкой.
  @override
  Future<List<PersonModel>> getAllPersons(int page) => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?page=$page');

  // Метод, реализующий поиск персонажа по имени.
  @override
  Future<List<PersonModel>> searchPerson(String query) => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?name=$query');

  // Вспомогательный метод, который делает основной http-запрос по переданному URL.
  // Он универсален и используется и для getAllPersons, и для searchPerson.
  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    // Выводим URL в консоль (для отладки, не для продакшена).
    print(url);

    // Делаем GET-запрос на указанный URL.
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    // Проверяем, успешно ли прошёл запрос.
    if (response.statusCode == 200) {
      // Расшифровываем JSON-строку из тела ответа.
      final persons = json.decode(response.body);

      // Преобразуем список результатов из JSON в список объектов PersonModel.
      return (persons['results'] as List)
          .map((person) => PersonModel.fromJson(person))
          .toList();
    } else {
      // Если код ответа не 200 — выбрасываем исключение.
      // Это будет обработано на уровне репозитория или use case.
      throw ServerException();
    }
  }
}
