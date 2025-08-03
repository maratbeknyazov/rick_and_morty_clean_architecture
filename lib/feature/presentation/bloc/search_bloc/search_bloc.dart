// ignore_for_file: constant_identifier_names
// Это директива, чтобы не было предупреждений о написании констант капсом (например, SERVER_FAILURE_MESSAGE)

import 'dart:async'; // Импорт для работы с Future и Stream.

import 'package:flutter_bloc/flutter_bloc.dart'; 
// Импорт библиотеки flutter_bloc — основа для реализации BLoC (бизнес-логики).

import 'package:rick_and_morty_flutter_3/core/error/failure.dart'; 
// Импорт собственных классов ошибок: ServerFailure, CacheFailure и базового Failure.

import 'package:rick_and_morty_flutter_3/feature/domain/usecases/search_person.dart'; 
// Импорт use case, который отвечает за поиск персонажей (выполняет запросы).

import 'package:rick_and_morty_flutter_3/feature/presentation/bloc/search_bloc/search_event.dart'; 
// Импорт событий для поиска — например, когда пользователь ввёл запрос.

import 'package:rick_and_morty_flutter_3/feature/presentation/bloc/search_bloc/search_state.dart'; 
// Импорт состояний поиска — загрузка, ошибка, результат и т.д.

const SERVER_FAILURE_MESSAGE = 'Server Failure'; 
// Сообщение, которое мы показываем, если сервер не отвечает.

const CACHED_FAILURE_MESSAGE = 'Cache Failure'; 
// Сообщение, если не удалось получить данные из кэша.

/// Класс PersonSearchBloc реализует бизнес-логику поиска персонажей.
/// Он получает события, обрабатывает их и возвращает состояния.
class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;
  // Это use case, который выполняет сам поиск по переданному запросу.

  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty()) {
    // Конструктор: изначально состояние — пустое (ничего не ищем).
    on<SearchPersons>(_onEvent);
    // Регистрируем обработчик события SearchPersons.
  }

  /// Метод, который обрабатывает событие поиска персонажей.
  /// Он запускается автоматически при получении SearchPersons.
  FutureOr<void> _onEvent(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading());
    // Показываем состояние загрузки (например, спиннер на экране).

    final failureOrPerson =
        await searchPerson(SearchPersonParams(query: event.personQuery));
    // Вызываем use case и передаём туда строку запроса, которую ввёл пользователь.
    // Метод вернёт Either<Failure, List<PersonEntity>> — либо ошибка, либо список.

    emit(failureOrPerson.fold(
      // .fold позволяет обработать оба случая: Left (ошибка) и Right (успех).
        (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        // Если ошибка — переходим в состояние ошибки с сообщением.
        (person) => PersonSearchLoaded(persons: person)));
        // Если успех — передаём список персонажей в состояние Loaded.
  }

  /// Метод, который переводит ошибку в понятное сообщение.
  /// Используется выше, чтобы определить, что именно показать пользователю.
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

// Ниже закомментирована старая версия блока — для BLoC 7.2.0.
// Там использовался другой подход: через mapEventToState.
// Ниже просто оставлены для справки, как было раньше:

// BLoC 7.2.0
// class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
//   final SearchPerson searchPerson;

//   PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty());

//   @override
//   Stream<PersonSearchState> mapEventToState(PersonSearchEvent event) async* {
//     if (event is SearchPersons) {
//       yield* _mapFetchPersonsToState(event.personQuery);
//     }
//   }

//   Stream<PersonSearchState> _mapFetchPersonsToState(String personQuery) async* {
//     yield PersonSearchLoading();

//     final failureOrPerson =
//         await searchPerson(SearchPersonParams(query: personQuery));

//     yield failureOrPerson.fold(
//         (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
//         (person) => PersonSearchLoaded(persons: person));
//   }

//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return SERVER_FAILURE_MESSAGE;
//       case CacheFailure:
//         return CACHED_FAILURE_MESSAGE;
//       default:
//         return 'Unexpected Error';
//     }
//   }
// }



// Этот класс PersonSearchBloc отвечает за логику поиска.
// Пользователь вводит текст → происходит событие SearchPersons → запускается searchPerson → возвращаются данные или ошибка → обновляется состояние (state).
// BLoC сам решает, какое состояние выдать: Loading, Loaded, Error и т. д.
// Используется подход BLoC 8.0+, где обработка событий выполняется с помощью on<Event>().