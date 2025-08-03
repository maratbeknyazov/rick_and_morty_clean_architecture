// Импортируем класс LocationEntity — это "чистая сущность" (entity),
// которая содержит только данные о локации (местоположении), без логики.
import 'package:rick_and_morty_flutter_3/feature/domain/entities/person_entity.dart';

// Класс LocationModel расширяет LocationEntity.
// Это означает, что LocationModel наследует все поля (name и url),
// но добавляет к ним методы для преобразования JSON <-> объект.
class LocationModel extends LocationEntity {
  // Конструктор класса.
  // Принимает параметры name и url и передаёт их в родительский класс (LocationEntity) через super(...).
  LocationModel({name, url}) : super(name: name, url: url);

  // Фабричный метод fromJson — создает объект LocationModel из JSON-данных (Map).
  // JSON обычно приходит с сервера, и этот метод нужен, чтобы превратить его в объект Dart.
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String, // Извлекаем поле name из JSON и приводим к типу String
      url: json['url'] as String,   // Извлекаем поле url из JSON
    );
  }

  // Метод toJson — превращает объект LocationModel обратно в JSON (Map).
  // Это удобно, если нужно отправить данные на сервер или сохранить их.
  Map<String, dynamic> toJson() {
    return {
      'name': name, // Используем поля, унаследованные от LocationEntity
      'url': url,
    };
  }
}


// LocationEntity — это просто структура данных, которая хранит name и url.
// LocationModel — это модель, которая умеет читать и записывать данные в формате JSON.
// Метод fromJson(...) — превращает обычную Map (например, полученную из интернета) в объект LocationModel.
// Метод toJson() — делает всё наоборот: превращает объект LocationModel в Map, которую можно, например, отправить обратно на сервер.
// super(...) используется, чтобы передать значения в родительский класс LocationEntity.