#language: ru

@tree

Функционал: Регистрация и просмотр POST запроса с сервера GitLab

Как Пользователь
Я хочу иметь возможность просмотреть факт получения POST запроса
Чтобы анализировать данные по обработке запроса и управлять фоновыми заданиями

Контекст:
    Дано Я подключаю TestClient "Этот клиент" логин "Пользователь" пароль ""
    И Я настраиваю сервисы GitLab
    И Я делаю POST запрос на "$$МестоположениеСервисовИБРаспределителя$$" с данными "$$ТелоPOSTЗапросаJSON$$" по ключу "$$GitlabToken$$"

Сценарий: Добавление данных о внешнем хранилище на GitLab

	Пусть В командном интерфейсе я выбираю 'Сервисы GitLab' 'Webhooks'
	Тогда открылось окно 'Webhooks'

    И я нажимаю на кнопку с именем 'ФормаСоздать'
    Тогда открылось окно 'Webhooks (создание)'
    И в поле 'Наименование' я ввожу текст 'ТестированиеДобавленияРедактированияУдаления'
    И в поле 'Секретный токен (Secret Token)' я ввожу текст "$$GitlabToken$$"
    И я нажимаю на кнопку 'Записать и закрыть'
    И я жду закрытия окна 'Webhooks (создание)' в течение 5 секунд
    Тогда открылось окно 'Webhooks'