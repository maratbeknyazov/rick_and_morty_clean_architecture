// Импортируем модель LocationModel, которая нужна для парсинга местоположений из JSON.
import 'package:rick_and_morty_flutter_3/feature/data/models/location_model.dart';

// Импортируем сущность PersonEntity — это "чистый" класс, в котором хранятся только данные (без логики).
import 'package:rick_and_morty_flutter_3/feature/domain/entities/person_entity.dart';

// Класс PersonModel — это модель данных, которая расширяет (наследует) PersonEntity.
// То есть он содержит те же поля, что и PersonEntity, но ещё добавляет методы для работы с JSON.
class PersonModel extends PersonEntity {
  // Конструктор PersonModel получает все поля, как и PersonEntity.
  // Ключевое слово `super(...)` передаёт эти значения в родительский класс (PersonEntity).
  const PersonModel({
    required id,
    required name,
    required status,
    required species,
    required type,
    required gender,
    required origin,
    required location,
    required image,
    required episode,
    required created,
  }) : super(
          id: id,
          name: name,
          status: status,
          species: species,
          type: type,
          gender: gender,
          origin: origin,
          location: location,
          image: image,
          episode: episode,
          created: created,
        );

  // Фабричный метод fromJson — это специальный способ создать объект PersonModel из JSON-данных.
  // JSON — это формат, в котором обычно приходят данные из интернета.
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] as int, // Преобразуем значение из JSON в int
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      // origin и location — это вложенные объекты, поэтому для них вызываем fromJson из LocationModel.
      origin: json['origin'] != null
          ? LocationModel.fromJson(json['origin'])
          : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      image: json['image'] as String,
      // episode — это список строк, его тоже нужно корректно обработать.
      episode:
          (json['episode'] as List<dynamic>).map((e) => e as String).toList(),
      // created — строка с датой, которую превращаем в объект DateTime.
      created: DateTime.parse(json['created'] as String),
    );
  }

  // Метод toJson — делает обратное: превращает объект PersonModel обратно в Map (в JSON).
  // Это может пригодиться, если ты хочешь сохранить данные или отправить их куда-то.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
      'episode': episode,
      // Преобразуем дату в строку, чтобы её можно было записать в JSON.
      'created': created.toIso8601String(),
    };
  }
}

// PersonModel — это модель, которая умеет работать с JSON (то есть с тем, как данные приходят из интернета).
// Она наследуется от PersonEntity, чтобы повторно использовать описание полей (id, name, status и т.д.).
// Метод fromJson — создаёт объект из данных.
// Метод toJson — превращает объект обратно в Map, чтобы можно было, например, его сохранить или отправить.
// Такой подход помогает отделить чистые данные (Entity) от логики их обработки (Model).