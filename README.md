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
* Файл спецификации интерфейса генерируемого модуля
	CARGOROOT/doc/*module*.md

Все файлы наполенны исходными кодами из шаблонов и сгенерированы согласно 
передынных праметров настроек генератора

```
Пример иллюстрирующий настрйоки генератора для гипотетического модуля yiqitest

Будут сгенерирвоаны файлы

/abs/path/to/cargo/test/yiqitest_SUITE.erl
/abs/path/to/cargo/lib/t_yiqitest.erl
/abs/path/to/cargo/lib/yiqitest.erl
/abs/path/to/cargo/doc/yiqitest.md

Также, зададим следующие обработчики каналов(маршруты,topics)

insert
delete
update
move/from
move/to

зададим ещё фукнции пустышки для тесткейсов
будут сгенерированы как функции тесткейсы, так и фукции в файле api тестов
пустые заготовки без MQTT(в отдельную группу?) 

yiqi_etcase_A
yiqi_etcase_B

```

Эти имена, темы каналов или topics появятся в соответсующих файлах
с вариациями зависящими от контекста

Параметр задаётся БЕЗ пробелов! --topics=topic1,topic2,...,topicN

Пробел ялвяетя разделителем аргументов командной строки
```sh
#это ещё не работает!
./yiqi.pl --root=/abs/path/to/cargo --module=yiqitest --topics=insert,delete,update,move/to,move/from

#fullpath = /abs/path/to/cargo

./yiqi.pl --cargo-root=/rel/path/to/cargo --module=yiqitest --topics=insert,delete,update,move/to,move/from --standalone-testcases=yiqi_etcase_A,yiqi_etcase_B 

#fullpath = HOME + cargo-root
```
В результате выполнения программы должны появится указанные файлы 
содеражщие заготовки кода для дальнейшей разработки

## Тонкие настройки генератора

Если требуется дополнить API для теста командами не связанными с MQTT каналом,
можно воспользоваться такой командой standalone-testcases=login
после знака равенсва(=) следует спико команад разделённым запятой(,) без пробелов!
```sh
./yiqi.pl --module=adm_auth --topic=users/list --standalone-testcases=login,logout
```

Вот так, с помощью опиции no-handler, можно не создавать модуль обработчика канала

```sh
./yiqi.pl --no-handler --module=adm_auth --topic=users/list --standalone-testcases=login
```

Опция no-suite позволяет не создавать common test suite

```sh
./yiqi.pl --no-suite --module=adm_auth --topic=users/list --standalone-testcases=login
```

А опиция no-test заставит генератор проигноврировать этап создания API для теста
```sh
./yiqi.pl --no-test --module=adm_auth --topic=users/list --standalone-testcases=login
```

Если надо добавить префикс к имени файлу чтобы не ломать имя канала есть параметр prefix.
Наример надо файлы t_adm_users.erl adm_users.erl amd_users_SUITE 
с транками ../users/list, ../users/add and so on.

```sh
./yiqi.pl --cargo-root=relative/path/to/cargo/from/HOME --module=users --topics=list,add --prefix=amd
```

Если надо сгенерировать только обработчики для указанных топиков без тестов
Например надо чтобы топики add/prev,add/next,add/cur не включались в тесты сформирует такую команду
```sh
./yiqi.pl --cargo-root=relative/path/to/cargo/from/HOME --module=users --topics=list,add,^add/prev,^add/next,^add/cur,delete
```

Для справок, традиционно

```sh
./yiqi.pl --help
```
Нет времени объяснять! 
Скорей, копируй и сразу вставляй команду в командную строку!
Смотри как жить стало лучше, жить стало веслей!

```sh
./yiqi.pl --module=yiqitest --topics=insert,delete,update,move/to,move/from
```
