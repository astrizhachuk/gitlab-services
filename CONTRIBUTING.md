# Участие в разработке

## Инструменты разработки

* Разработка ведется в [EDT](https://releases.1c.ru/project/DevelopmentTools10) не ниже 2020.4.0+425. Проект создан на основе [bootstrap-1c](https://github.com/astrizhachuk/bootstrap-1c);

* Платформа 1С не ниже 8.3.17.1549;

* Модульные тесты через [1CUnits](https://github.com/DoublesunRUS/ru.capralow.dt.unit.launcher) не ниже 0.4.0 - в расширении конфигурации EDT, см. [./GitlabServices.Tests](./GitlabServices.Tests);

* [MockServer](https://www.mock-server.com/#what-is-mockserver);

* Среда для разработки разворачивается с помощью docker-compose, а сам продукт поставляется в виде образов [docker](https://www.docker.com);

## Процесс разработки

Предполагается следующий цикл при работе над проектом:

Начинаем...

1. Pull проекта из удаленного репозитория;

2. Разворачивание среды;

3. Разработка в EDT в ранее созданном окружении (база-данных, веб-сервер, утилиты);

4. Тестирование (юнит-тесты, функциональные и интеграционные тесты);

5. Push изменений и PR (MR) в удаленный репозиторий;

6. Прогон автоматических тестов, сборка релиза и документации на сервере;

...повторяем.

### Сборка проекта

#### Установка требуемого ПО

Например, для ```windows```, можно воспользоваться менеджером пакетов [chocolatey](https://chocolatey.org):

```bash
> tools\install-env.cmd
```

#### Клонирование проекта из удаленного репозитория

```bash
> git clone https://github.com/astrizhachuk/gitlab-services.git
```

#### Конфигурация проекта

Для самостоятельной сборки проекта необходимо предварительно установить переменные окружения. Если docker-образы уже собраны, то данный шаг не обязателен.

>ONEC_USERNAME - учётная запись на http://releases.1c.ru
>
>ONEC_PASSWORD - пароль для учётной записи на http://releases.1c.ru
>
>ONEC_VERSION - версия платформы 1С:Преприятия 8.3, для которой собирается проект
>
>DOCKER_USERNAME - учетная запись на [Docker Hub](https://hub.docker.com) или в корпоративном registry
>
Настроить подключение к серверу лицензий в файле [nethasp.ini](./tools/nethasp.ini)

Настроить в системном hosts resolve имен сервисов из файла [docker-compose.yml](./docker-compose.yml).

```bash
# srv - сервер 1С;
# mock-server - mock-сервер (требуется для установки заглушек веб-сервисов);
# gitlab - сервер gitlab (требуется для интеграционных тестов);
# transmitter - веб-сервер для API и веб-клиента сервиса gitlab;
# receiver:[port] - веб-сервера для API тестовых баз (получателей)
127.0.0.1 localhost mock-server gitlab transmitter receiver
172.28.189.202 srv  #ult 172.28.189.202 - ip docker-демона
```

Местоположения hosts:

```bash
# windows
C:\Windows\System32\drivers\etc\hosts

# linux
/etc/hosts
```

#### Операции с окружением

Разворачивание окружения с предварительной сборкой образов:

```bash
> docker-compose up -d --build
```

Запуск всех сервисов:

```bash
> docker-compose start
```

Запуск выборочных сервисов:

```bash
> docker-compose start srv db transmitter
```

Остановка всех сервисов:

```bash
> docker-compose stop
```

Запуск нескольких тестовых баз-получателей (масштабированием) с веб-сервером, веб-клиентом и инициализацией базы из эталона:

```bash
# api для база_1 - receiver:8081/api/hs/gitlab/version
# client для база_1 - receiver:8081/client
# api для база_2 - receiver:8082/api/hs/gitlab/version
# client для база_2 - receiver:8082/client
# и т.д.

> docker-compose up --scale receiver=2 --build receiver
```

Пример определения IP адресов баз-получателей (для custom_settings.json):

```bash
docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" gitlab-services_receiver_1 gitlab-services_receiver_2
```

```Runtime``` копирование файла в контейнер с толстым клиентом:

```bash
docker cp ./test/empty.dt gitlab-services_client_1:/tmp/empty.dt
```

```Runtime``` удаление всех данных (в т. ч. пользователей) в информационной базе через пакетный режим запуска:

```bash
docker exec gitlab-services_client_1 bash -c "/opt/1C/v8.3/x86_64/1cv8 DESIGNER /S 'srv\gitlabServices' /N'Администратор' /EraseData /DisableStartupDialogs"
```

```Runtime``` загрузка в ранее очищенную базу dt-файла эталонной тестовой базы через пакетный режим запуска:

```bash
# вариант для загрузки dt-файла, переданного в контейнер при его создании
docker exec gitlab-services_client_1 bash -c "/opt/1C/v8.3/x86_64/1cv8 DESIGNER /S 'srv\gitlabServices' /RestoreIB /home/usr1cv8/empty.dt /DisableStartupDialogs"

# вариант для загрузки dt-файла, ранее переданного в runtime
docker exec gitlab-services_client_1 bash -c "/opt/1C/v8.3/x86_64/1cv8 DESIGNER /S 'srv\gitlabServices' /RestoreIB /tmp/empty.dt /DisableStartupDialogs"
```

```Runtime``` загрузка в "испорченную" базу dt-файла эталонной тестовой базы через пакетный режим запуска:

```bash
# вариант для загрузки dt-файла, переданного в контейнер при его создании
docker exec gitlab-services_client_1 bash -c "/opt/1C/v8.3/x86_64/1cv8 DESIGNER /S 'srv\gitlabServices' /N'Администратор' /RestoreIB /home/usr1cv8/empty.dt /DisableStartupDialogs"

# вариант для загрузки dt-файла, ранее переданного в runtime
docker exec gitlab-services_client_1 bash -c "/opt/1C/v8.3/x86_64/1cv8 DESIGNER /S 'srv\gitlabServices' /N'Администратор' /RestoreIB /tmp/empty.dt /DisableStartupDialogs"
```

> Помни! EDT может блокировать монопольный доступ к базе (запущен агент), что препятствует загрузке dt-файла. Перед загрузкой dt-файлов необходимо удалять блокирующие процессы на клиенте (либо закрывать EDT).

Создание бэкапа ```gitlab```:

```bash
docker-compose exec gitlab gitlab-backup create BACKUP=new_dump strategy=copy force=yes
```

Восстановление эталонного состояния ```gitlab```:

```bash
docker-compose exec gitlab /restore.sh
```

Пример, как сложное сделать простым:

(тестирование в ```vanessa-automation```  в среде ```linux``` на ```windows``` при наличии ```WSL2``` подключившись "сбоку" еще одним контейнером)

```bash
> docker run --rm \
    -it -p 5901:5900/tcp \
    --env-file=.env.docker \
    --network=gitlab-services_back_net \
    -v gitlab-services_client_data:/home/usr1cv8/.1cv8 \
    -v $PWD/tools/nethasp.ini:/opt/1C/v8.3/x86_64/conf/nethasp.ini \
    -v $PWD/tools/VAParams.json:/home/usr1cv8/VAParams.json \
    -v $PWD/:/home/usr1cv8/project \
    ${DOCKER_USERNAME}/client-vnc-va:${ONEC_VERSION}

```

В файле [.env.docker](./.env.docker) указываются параметры запуска толстого клиента в контейнере.

> Помни! В файлах ```linux``` перевод строки - ```LF```, а в ```windows``` - ```CRLF```

### Лаунчеры EDT

[Набор лаунчеров EDT](./tools/edt/) для запуска и тестирования под разными локализациями и в разрезе тегов.
