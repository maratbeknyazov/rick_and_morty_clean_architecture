// ignore_for_file: constant_identifier_names, avoid_print
// Отключаем предупреждения о стиле написания констант (SERVER_FAILURE_MESSAGE) и использовании print().

import 'package:flutter_bloc/flutter_bloc.dart';
// Импорт библиотеки flutter_bloc — используем Cubit для управления состоянием.

import 'package:rick_and_morty_flutter_3/core/error/failure.dart';
// Импорт классов ошибок: ServerFailure, CacheFailure и т.д.

import 'package:rick_and_morty_flutter_3/feature/domain/entities/person_entity.dart';
// Импорт сущности PersonEntity — персонаж в виде бизнес-объекта.

import 'package:rick_and_morty_flutter_3/feature/domain/usecases/get_all_persons.dart';
// Импорт use case, который получает список всех персонажей с сервера или кэша.

import 'package:rick_and_morty_flutter_3/feature/presentation/bloc/person_list_cubit/person_list_state.dart';
// Импорт состояний (PersonEmpty, PersonLoading, PersonLoaded, PersonError).

const SERVER_FAILURE_MESSAGE = 'Server Failure'; // Сообщение при ошибке сервера.
const CACHED_FAILURE_MESSAGE = 'Cache Failure';  // Сообщение при ошибке получения из кэша.

/// Cubit-класс, который управляет состоянием списка персонажей.
/// Используется вместо Bloc для упрощённой логики (только state → state, без event).
class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;
  // Use case, который получает список персонажей (по страницам).

  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());
  // Конструктор: начальное состояние — пустой список (PersonEmpty).

  int page = 1;
  // Номер текущей страницы — нужен для постраничной загрузки (pagination).

  /// Метод, который загружает персонажей (с учётом пагинации).
  void loadPerson() async {
    if (state is PersonLoading) return;
    // Если уже идёт загрузка — ничего не делаем (предотвращаем дублирующие вызовы).

    final currentState = state;
    // Получаем текущее состояние Cubit.

    var oldPerson = <PersonEntity>[];
    // Создаём временный список для старых данных (из предыдущих страниц).

    if (currentState is PersonLoaded) {
      oldPerson = currentState.personsList;
      // Если уже были загружены персонажи — добавим их к новым.
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));
    // Показываем состояние загрузки.
    // Если это первая страница — показываем "первичную" загрузку, иначе добавление.

    final failureOrPerson = await getAllPersons(PagePersonParams(page: page));
    // Вызываем use case, передаём текущую страницу. Получаем либо ошибку, либо список персонажей.

    failureOrPerson.fold(
      // Метод .fold позволяет обработать обе стороны Either: ошибку (Left) и успех (Right).

      (error) => emit(PersonError(message: _mapFailureToMessage(error))),
      // Если ошибка — переходим в состояние ошибки с сообщением.

      (character) {
        page++;
        // Если успех — увеличиваем номер страницы для следующей подгрузки.

        final persons = (state as PersonLoading).oldPersonsList;
        // Берём старый список персонажей (которые уже были загружены).

        persons.addAll(character);
        // Добавляем новых персонажей к старому списку.

        print('List length: ${persons.length.toString()}');
        // Для отладки: выводим в консоль, сколько всего персонажей загружено.

        emit(PersonLoaded(persons));
        // Обновляем состояние — теперь список успешно загружен.
      },
    );
  }

  /// Метод, который преобразует объект ошибки (Failure) в понятное сообщение.
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}


// Cubit управляет состояниями: что происходит на экране (загрузка, ошибка, данные).
// Метод loadPerson() загружает новую порцию персонажей (с постраничной навигацией).
// Когда пользователь, например, прокручивает вниз — вызывается loadPerson() снова и подгружает следующую страницу.
// В случае ошибки (например, нет интернета), Cubit покажет сообщение об ошибке.
// emit(...) — это ключевая команда, чтобы поменять состояние UI.
// Either (из пакета dartz) — тип, который возвращает либо Left(ошибка), либо Right(успешный результат).