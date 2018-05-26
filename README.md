# Yi qi
Инструмент генерирует, насыщает исходными кодами из шаблонов
и раскладывает по нужным каталогам файлы описывающие модуль вновь 
создаваемой подсистемы.

## Структура генерируемых данных:
* Файл модуля тестирования
	CARGOROOT/test/*module*_SUITE.erl
* Файл модуля API функций для тестов
	CARGOROOT/lib/t_*module*.erl
* Файл модуля обработчика каналов, реализующего функционал подсистемы
	CARGOROOT/lib/*module*.erl

Все файлы наполенны исходными кодами из шаблонов и сгенерырованы согласно 
передынных праметров настроек герератора

```
Пример иллюстрирующий настрйоку генератор для гипотетического модуля yiqitest

Будут сгенерирвоаны файлы

/abs/path/to/cargo/test/yiqitest_SUITE.erl
/abs/path/to/cargo/lib/t_yiqitest.erl
/abs/path/to/cargo/lib/yiqitest.erl

Также, зададим следующие обработчики каналов(маршруты)

insert
delete
update
move/from
move/to
```

Эти имена темы каналов или topics появятся в соответсующих файлах
с вариациями зависящими от контекста

Параметр задаётся БЕЗ пробелов! --topics=topic1,topic2,...,topicN
Пробел ялвяетя разделителем аргументов командной строки

это ещё не работает!
> yiqi.pl --root=/abs/path/to/cargo --module=yiqitest --topics=insert,delete,update,move/to,move/from

fullpath = /abs/path/to/cargo

> yiqi.pl --cargo-root=/rel/path/to/cargo --module=yiqitest --topics=insert,delete,update,move/to,move/from

fullpath = HOME + cargo-root

В результате выполнения программы должны появится указанные файлы 
содеражщие заготовки кода для дальнейшей разработки

для справок, традиционно

> yiqi.pl --help

Нет времени объяснять! 
Скорей, копируй и сразу вставляй команду в командную строку!
Смотри как жить стало лучше, жить стало веслей!


> ./yiqi.pl --module=yiqitest --topics=insert,delete,update,move/to,move/from
