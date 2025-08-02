// Импортируем пакет dartz — он позволяет использовать тип Either,
// который помогает обрабатывать как успешный результат, так и ошибку.
import 'package:dartz/dartz.dart';

// Импортируем equatable — это утилита, которая делает объекты сравнимыми по значениям.
import 'package:equatable/equatable.dart';

// Импортируем базовый класс ошибки (Failure), который описывает возможные ошибки в приложении.
import 'package:rick_and_morty_flutter_3/core/error/failure.dart';

// Импортируем базовый абстрактный класс UseCase, от которого мы наследуем конкретный вариант использования.
import 'package:rick_and_morty_flutter_3/core/usecases/usecase.dart';

// Импортируем сущность персонажа — объект, который хранит данные об одном персонаже.
import 'package:rick_and_morty_flutter_3/feature/domain/entities/person_entity.dart';

// Импортируем интерфейс репозитория, который отвечает за получение данных (например, из интернета).
import 'package:rick_and_morty_flutter_3/feature/domain/repositories/person_repository.dart';

// Класс SearchPerson — это конкретный use case (вариант использования).
// Он отвечает за поиск персонажа по имени или фразе.
// Наследуется от UseCase, где:
//   - List<PersonEntity> — тип возвращаемого результата при успехе,
//   - SearchPersonParams — параметры для выполнения поиска.
class SearchPerson extends UseCase<List<PersonEntity>, SearchPersonParams> {
  // Сохраняем ссылку на репозиторий, через который будем получать данные.
  final PersonRepository personRepository;

  // Конструктор класса. В него нужно передать объект репозитория.
  SearchPerson(this.personRepository);

  // Переопределяем метод call (это специальный метод, который можно вызывать как функцию).
  // Он получает параметры поиска (SearchPersonParams) и возвращает результат асинхронно.
  // Результат — это либо ошибка (Failure), либо список найденных персонажей (List<PersonEntity>).
  @override
  Future<Either<Failure, List<PersonEntity>>> call(
      SearchPersonParams params) async {
    // Вызываем метод searchPerson у репозитория, передаём туда строку запроса.
    return await personRepository.searchPerson(params.query);
  }
}

// Класс SearchPersonParams описывает параметры для поиска.
// В нашем случае — это просто строка запроса (например, "Rick").
class SearchPersonParams extends Equatable {
  final String query; // Слово или фраза, по которой будем искать персонажа

  // Конструктор — query обязателен для передачи.
  const SearchPersonParams({required this.query});

  // Переопределяем props, чтобы Dart мог сравнивать два объекта SearchPersonParams
  // по значению поля query (а не по ссылке в памяти).
  @override
  List<Object> get props => [query];
}
