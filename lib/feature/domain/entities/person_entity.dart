// https://rickandmortyapi.com/documentation/#get-all-characters
// Эта ссылка ведёт на документацию API Rick and Morty, откуда берутся данные о персонажах.

// Импортируем пакет equatable — он помогает удобно сравнивать объекты Dart по значениям,
// а не по ссылкам. Это особенно полезно при использовании блоков и состояния.
import 'package:equatable/equatable.dart';

// Описываем сущность (entity) персонажа — PersonEntity.
// "Entity" — это просто объект, который содержит только данные, без логики.
// Например, персонаж из мультфильма с его характеристиками.
class PersonEntity extends Equatable {
  // Поля класса, описывающие персонажа:
  final int id;                  // Уникальный идентификатор персонажа
  final String name;            // Имя
  final String status;          // Статус (жив, мёртв, неизвестно)
  final String species;         // Вид (например, человек, инопланетянин и т.п.)
  final String type;            // Подвид или тип (может быть пустым)
  final String gender;          // Пол
  final LocationEntity origin;  // Место происхождения (объект другого класса)
  final LocationEntity location; // Текущее местоположение (тоже объект)
  final String image;           // Ссылка на изображение персонажа
  final List<String> episode;   // Список эпизодов, в которых он появлялся
  final DateTime created;       // Дата создания записи в API

  // Конструктор класса. required говорит, что все поля обязательны при создании объекта.
  const PersonEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.created,
  });

  // Переопределяем геттер `props`, который используется equatable для сравнения объектов.
  // Это нужно, чтобы Dart знал, какие поля участвуют в сравнении.
  @override
  List<Object?> get props => [
        id,
        name,
        status,
        species,
        type,
        gender,
        origin,
        location,
        image,
        episode,
        created,
      ];
}

// Отдельный класс, описывающий местоположение (может быть как origin, так и location).
// Он тоже содержит только данные.
class LocationEntity {
  final String name;  // Название локации
  final String url;   // Ссылка на описание этой локации

  // Конструктор — оба поля обязательны.
  const LocationEntity({required this.name, required this.url});
}


// Этот код описывает, как выглядит персонаж из API Rick and Morty.
// Используются два класса: PersonEntity (сам персонаж) и LocationEntity (место).
// Используется equatable, чтобы объекты можно было удобно сравнивать.
// Это data-классы — они просто хранят информацию, не выполняют никакой логики.