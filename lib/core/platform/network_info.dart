import 'package:internet_connection_checker/internet_connection_checker.dart';
// Импорт пакета, который позволяет проверить наличие подключения к интернету.
// Пакет предоставляет готовую проверку: есть ли интернет в данный момент.
  
/// Абстрактный класс (интерфейс), который задаёт структуру для проверки подключения к интернету.
/// Класс, который реализует этот интерфейс, должен уметь проверять, есть ли интернет.
abstract class NetworkInfo {
  Future<bool> get isConnected;
  // Свойство (геттер), которое возвращает Future<bool>.
  // true — если интернет есть, false — если нет.
  // Поскольку проверка происходит асинхронно, возвращается Future.
}

/// Конкретная реализация интерфейса NetworkInfo.
/// Использует библиотеку internet_connection_checker, чтобы проверить подключение.
class NetworkInfoImp implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;
  // Объект, который будет выполнять фактическую проверку соединения.

  NetworkInfoImp(this.connectionChecker);
  // Конструктор: сюда передаётся экземпляр InternetConnectionChecker.
  // Его можно передать через dependency injection.

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
  // Реализация геттера: просто возвращаем результат проверки от connectionChecker.
  // Это будет Future<bool> — как и требовалось в интерфейсе.
}
