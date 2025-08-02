// Импортируем пакет dartz — он используется для функционального программирования в Dart.
// Здесь он нужен для типа Either, который позволяет обрабатывать как успешный результат, так и ошибку.
import 'package:dartz/dartz.dart';

// Импортируем класс Failure — он описывает возможные ошибки (например, проблемы с сетью).
import 'package:rick_and_morty_flutter_3/core/error/failure.dart';

// Импортируем сущность персонажа, которая описывает данные одного персонажа.
import 'package:rick_and_morty_flutter_3/feature/domain/entities/person_entity.dart';

// Абстрактный класс (интерфейс) для репозитория персонажей.
// Репозиторий — это "прослойка" между данными и бизнес-логикой.
// Он отвечает за получение данных, не важно откуда (из интернета, базы данных и т.д.).
abstract class PersonRepository {
  // Метод getAllPersons загружает список персонажей постранично.
  // page — это номер страницы (например, 1, 2, 3 и т.д.).
  // Возвращает Future (то есть результат будет в будущем, асинхронно).
  // Тип Either<Failure, List<PersonEntity>> означает:
  // - Либо произошла ошибка (Failure),
  // - Либо получен список персонажей (List<PersonEntity>).
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page);

  // Метод searchPerson выполняет поиск по имени или другой строке.
  // query — это строка запроса (например, "Rick").
  // Возвращает либо ошибку, либо список подходящих персонажей.
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query);
}
