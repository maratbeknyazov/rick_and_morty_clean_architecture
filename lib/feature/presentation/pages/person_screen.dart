// Импортируем основной пакет Flutter для создания UI
import 'package:flutter/material.dart';

// Импортируем кастомный виджет поиска, который ты где-то сам реализовал
import 'package:rick_and_morty_flutter_3/feature/presentation/widgets/custom_search_delegate.dart';

// Импортируем виджет списка персонажей
import 'package:rick_and_morty_flutter_3/feature/presentation/widgets/persons_list_widget.dart';

// Создаём класс главной страницы приложения.
// Он не хранит состояние, поэтому наследуется от StatelessWidget
class HomePage extends StatelessWidget {
  // Конструктор класса с ключом. Константа, так как состояние не меняется
  const HomePage({Key? key}) : super(key: key);

  // Метод build отвечает за отрисовку UI
  @override
  Widget build(BuildContext context) {
    // Scaffold — это каркас экрана: содержит AppBar, тело, и другие элементы
    return Scaffold(
      // Верхняя панель (AppBar) экрана
      appBar: AppBar(
        // Заголовок в AppBar
        title: const Text('Characters'),
        // Центрируем заголовок
        centerTitle: true,
        // Добавляем действия справа в AppBar (например, иконку поиска)
        actions: [
          IconButton(
            // Иконка лупы (поиск)
            icon: const Icon(Icons.search),
            // Цвет иконки
            color: Colors.white,
            // Что происходит при нажатии на иконку
            onPressed: () {
              // Открывается встроенное окно поиска
              // CustomSearchDelegate — это твой собственный класс, который описывает, как работает поиск
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          )
        ],
      ),
      // Основное тело экрана — здесь отображается список персонажей
      body: PersonsList(), // Это виджет, который, скорее всего, выводит карточки или список с персонажами
    );
  }
}
