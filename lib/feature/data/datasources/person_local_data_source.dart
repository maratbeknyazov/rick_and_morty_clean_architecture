// ignore_for_file: avoid_print
// Эта строчка отключает предупреждение от линтера о том, что не стоит использовать print().
// Мы оставляем print() для отладки.

import 'dart:convert'; // Позволяет работать с JSON: кодировать и декодировать объекты.

import 'package:rick_and_morty_flutter_3/core/error/exception.dart'; 
// Импорт кастомного исключения CacheException (наш класс ошибок).

import 'package:rick_and_morty_flutter_3/feature/data/models/person_model.dart'; 
// Импорт модели PersonModel – представляет персонажа.

import 'package:shared_preferences/shared_preferences.dart'; 
// Импорт библиотеки, с помощью которой можно сохранять простые данные в локальной памяти устройства.

/// Абстрактный класс – задаёт контракт (что именно должен делать класс, который реализует этот интерфейс).
abstract class PersonLocalDataSource {
  /// Возвращает закэшированный список персонажей [List<PersonModel>], 
  /// который был сохранён при последнем наличии интернета.
  ///
  /// Если данных нет — выбрасывается [CacheException].
  Future<List<PersonModel>> getLastPersonsFromCache();

  /// Сохраняет переданный список персонажей в кэш (локальное хранилище).
  Future<void> personsToCache(List<PersonModel> persons);
}

// ignore: constant_identifier_names        
const CACHED_PERSONS_LIST = 'CACHED_PERSONS_LIST'; 
// Константа-ключ, под которым данные будут сохранены в SharedPreferences.

/// Реализация интерфейса PersonLocalDataSource.
class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;
  // Объект SharedPreferences, с помощью которого мы читаем/пишем локальные данные.

  PersonLocalDataSourceImpl({required this.sharedPreferences});
  // Конструктор, принимающий объект sharedPreferences.

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final jsonPersonsList =
        sharedPreferences.getStringList(CACHED_PERSONS_LIST);
    // Пытаемся получить список строк (в формате JSON), сохранённый ранее под ключом CACHED_PERSONS_LIST.

    if (jsonPersonsList!.isNotEmpty) {
      // Если список не пустой (данные есть) — продолжаем.
      print('Get Persons from Cache: ${jsonPersonsList.length}');
      // Для отладки: выводим в консоль, сколько объектов получили из кэша.

      return Future.value(jsonPersonsList
          .map((person) => PersonModel.fromJson(json.decode(person)))
          .toList());
      // Преобразуем каждый JSON-строку в объект PersonModel.
      // json.decode превращает строку в Map, а fromJson делает из Map модель PersonModel.
    } else {
      throw CacheException();
      // Если список пустой, выбрасываем исключение — сигнализируем, что кэша нет.
    }
  }

  @override
  Future<List<String>> personsToCache(List<PersonModel> persons) {
    final List<String> jsonPersonsList =
        persons.map((person) => json.encode(person.toJson())).toList();
    // Переводим каждый объект PersonModel в JSON (Map -> строка),
    // чтобы можно было сохранить в SharedPreferences.

    sharedPreferences.setStringList(CACHED_PERSONS_LIST, jsonPersonsList);
    // Сохраняем получившийся список строк в SharedPreferences под ключом CACHED_PERSONS_LIST.

    print('Persons to write Cache: ${jsonPersonsList.length}');
    // Выводим в консоль количество сохранённых элементов.

    return Future.value(jsonPersonsList);
    // Возвращаем тот же список как результат (хотя можно было бы вернуть просто void).
  }
}



// SharedPreferences — это как «блокнот» внутри телефона. Мы можем туда что-то записать, а потом прочитать.
// JSON — это формат текста, в котором удобно хранить объекты (например, персонажей).
// toJson() — превращает объект в текст.
// fromJson() — превращает текст обратно в объект.
// CacheException — это наша ошибка на случай, если данных нет.
// Future — значит, результат придёт не сразу (например, через пару миллисекунд или секунд).