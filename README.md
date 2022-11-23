# Pet project «DWH: Пересмотр модели данных»

### Описание

В данной работе на примере таблицы с заказми интернет-магазина реализована миграция данных в отдельные логические таблицы, а затем на основе них собрана витрина данных.

### Структура репозитория

Папка `migrations` хранит файлы миграции с расширением `.sql` и содержит SQL-скрипт обновления базы данных.

### Ипользуемые технологии

1. `DDL` для созадния таблиц;
2. `DML` для наполнения таблиц;
3. Витрина данных создана в формате `view`

### Запуск контейнера

```
docker run -d --rm -p 3000:3000 -p 15432:5432 --name=de-project-sprint-2-server sindb/project-sprint-2:latest
```
