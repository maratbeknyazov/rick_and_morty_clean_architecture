import 'package:equatable/equatable.dart';
// Импорт библиотеки Equatable, которая позволяет сравнивать объекты по значениям их полей.
// Это важно для корректной работы BLoC, чтобы понять, изменилось ли состояние.

import 'package:rick_and_morty_flutter_3/feature/domain/entities/person_entity.dart';
// Импорт сущности персонажа — используется в состоянии, где нужно вернуть список найденных персонажей.

/// Абстрактный класс для всех состояний поиска персонажей.
/// Наследуется от Equatable, чтобы состояния можно было сравнивать по содержимому.
abstract class PersonSearchState extends Equatable {
  const PersonSearchState();

  @override
  List<Object> get props => [];
  // Пустой список — потому что в базовом классе нет полей, участвующих в сравнении.
}

/// Состояние по умолчанию — когда пользователь ещё не начал поиск.
/// Например, при первом открытии экрана.
class PersonSearchEmpty extends PersonSearchState {}

/// Состояние загрузки — когда идёт запрос на сервер.
/// Обычно отображается индикатор загрузки (спиннер).
class PersonSearchLoading extends PersonSearchState {}

/// Состояние, когда поиск завершился успешно и вернулся список персонажей.
class PersonSearchLoaded extends PersonSearchState {
  final List<PersonEntity> persons;
  // Поле — список найденных персонажей (используется в UI для отображения).

  const PersonSearchLoaded({required this.persons});
  // Конструктор — принимает список найденных персонажей.

  @override
  List<Object> get props => [persons];
  // Equatable будет сравнивать состояния по списку persons.
}

/// Состояние, когда произошла ошибка при поиске.
/// Например, нет интернета или сервер вернул ошибку.
class PersonSearchError extends PersonSearchState {
  final String message;
  // Поле — сообщение об ошибке, которое можно показать пользователю.

  const PersonSearchError({required this.message});
  // Конструктор — принимает текст ошибки.

  @override
  List<Object> get props => [message];
  // Equatable будет сравнивать состояния по сообщению.
}



// Это разные состояния экрана поиска в архитектуре BLoC.
// State — это то, в каком сейчас состоянии находится UI:
// ничего не ввели → Empty,
// идёт загрузка → Loading,
// нашли результат → Loaded,
// произошла ошибка → Error.
// Все эти классы расширяют PersonSearchState, чтобы BLoC мог ими управлять.
// Equatable нужен, чтобы BLoC знал, изменилось ли состояние, и перерисовал UI только если надо.