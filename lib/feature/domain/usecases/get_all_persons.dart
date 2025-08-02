// Импортируем пакет dartz, чтобы использовать тип Either,
// который позволяет возвращать либо ошибку (Failure), либо успешный результат.
import 'package:dartz/dartz.dart';

// Импортируем equatable, чтобы можно было удобно сравнивать объекты (например, параметры запроса).
import 'package:equatable/equatable.dart';

// Импортируем класс Failure — это базовый класс всех ошибок в проекте.
import 'package:rick_and_morty_flutter_3/core/error/failure.dart';

// Импортируем базовый интерфейс UseCase (описание ниже).
import 'package:rick_and_morty_flutter_3/core/usecases/usecase.dart';

// Импортируем сущность персонажа — объект, который содержит данные о персонаже.
import 'package:rick_and_morty_flutter_3/feature/domain/entities/person_entity.dart';

// Импортируем интерфейс репозитория — он отвечает за получение данных.
import 'package:rick_and_morty_flutter_3/feature/domain/repositories/person_repository.dart';

// Класс GetAllPersons — это конкретный use case (вариант использования).
// Он реализует базовый UseCase, и говорит: "Я получаю список персонажей".
// Он работает с репозиторием, чтобы запросить данные.
class GetAllPersons extends UseCase<List<PersonEntity>, PagePersonParams> {
  // Создаём переменную для репозитория, через который получаем данные.
  final PersonRepository personRepository;

  // Конструктор класса. Получает репозиторий извне (внедрение зависимости).
  GetAllPersons(this.personRepository);

  // Метод call — основной метод use case.
  // Он вызывается с параметрами PagePersonParams и возвращает Future с Either:
  // либо ошибка (Failure), либо список персонажей.
  @override
  Future<Either<Failure, List<PersonEntity>>> call(
      PagePersonParams params) async {
    // Просто вызывает метод getAllPersons у репозитория, передавая номер страницы.
    return await personRepository.getAllPersons(params.page);
  }
}

// Этот класс описывает параметры, с которыми вызывается use case.
// В нашем случае — это просто номер страницы.
class PagePersonParams extends Equatable {
  final int page; // Номер страницы

  // Конструктор — принимает номер страницы как обязательный параметр.
  const PagePersonParams({required this.page});

  // Позволяет сравнивать объекты PagePersonParams по значению (а не по ссылке).
  @override
  List<Object> get props => [page];
}
