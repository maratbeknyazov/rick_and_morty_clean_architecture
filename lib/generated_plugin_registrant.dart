//
// Generated file. Do not edit.
// 
// Этот файл сгенерирован автоматически системой Flutter при сборке проекта.
// Его не нужно редактировать вручную, потому что при следующей сборке он может быть перезаписан.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars
// Эти директивы говорят анализатору Dart не ругаться:
// - если порядок импортов не идеален
// - если строки длиннее 80 символов

// Импортируем веб-реализацию shared_preferences — плагина для хранения данных (например, токенов или настроек пользователя)
import 'package:shared_preferences_web/shared_preferences_web.dart';

// Импортируем систему плагинов Flutter для веба
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// Функция, которая регистрирует нужные веб-плагины при запуске приложения
// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  // Регистрируем плагин shared_preferences для работы в вебе
  SharedPreferencesPlugin.registerWith(registrar);

  // Регистрируем обработчик сообщений между Dart и JavaScript (браузером)
  registrar.registerMessageHandler();
}
