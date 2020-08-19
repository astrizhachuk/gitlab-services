#Область ПрограммныйИнтерфейс

// Возвращает фиксированную структуру со всеми текущими настройками механизмов управления сервисами GitLab.
// 
// Параметры:
// Возвращаемое значение:
// ФиксированнаяСтруктура - описание:
// * ОбрабатыватьЗапросыВнешнегоХранилища - Булево - (См. Константа.ОбрабатыватьЗапросыВнешнегоХранилища);
// * ИмяФайлаНастроекМаршрутизации - Строка - (См. Константа.ИмяФайлаНастроекМаршрутизации);
// * GitLabUserPrivateToken - Строка - (См. Константа.GitLabUserPrivateToken);
// * ТаймаутGitLab - Число - (См. Константа.ТаймаутGitLab);
// * AccessTokenReceiver - Строка - (См. Константа.AccessTokenReceiver);
// * ТаймаутДоставкиФайла - Число - (См. Константа.ТаймаутДоставкиФайла);
//
Функция ТекущиеНастройки() Экспорт
	
	Перем Результат;

	Результат = Новый Структура();
	Результат.Вставить( "ОбрабатыватьЗапросыВнешнегоХранилища", ОбрабатыватьЗапросыВнешнегоХранилища() );
	Результат.Вставить( "ИмяФайлаНастроекМаршрутизации", ИмяФайлаНастроекМаршрутизации() );
	Результат.Вставить( "GitLabUserPrivateToken", GitLabUserPrivateToken() );
	Результат.Вставить( "ТаймаутGitLab", ТаймаутGitLab() );
	Результат.Вставить( "AccessTokenReceiver", AccessTokenReceiver() );
	Результат.Вставить( "ТаймаутДоставкиФайла", ТаймаутДоставкиФайла() );
	
	Результат = Новый ФиксированнаяСтруктура( Результат );

	Возврат Результат;
	
КонецФункции

// Параметры доставки данных до веб-сервиса работы с внешними отчетами и обработками в информационной базе получателе.
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Описание:
// * Адрес - Строка - адрес веб-сервиса для работы с внешними отчетами и обработками в информационной базе получателе;
// * Token - Строка - token доступа к сервису получателя;
// * Таймаут - Число - таймаут соединения с сервисом, секунд (если 0 - таймаут не установлен);
//
Функция ПараметрыПолучателя() Экспорт
	
	Перем Результат;
	
	Результат = Новый Структура();
	Результат.Вставить( "Адрес", "localhost/receiver/hs/gitlab" );
	Результат.Вставить( "Token", AccessTokenReceiver() );
	Результат.Вставить( "Таймаут", ТаймаутДоставкиФайла() );
	
	Возврат Результат;
	
КонецФункции

// Получает значение константы с именем файла настроек маршрутизации, расположенном в корне репозитория GitLab.
//
// Параметры:
// Возвращаемое значение:
// 	Строка - имя файла (макс. 50);
//
Функция ИмяФайлаНастроекМаршрутизации() Экспорт
	
	Возврат Константы.ИмяФайлаНастроекМаршрутизации.Получить();
	
КонецФункции

// Получает значение константы с private token пользователя GitLab с правами доступа к API GitLab.
// 
// Параметры:
// Возвращаемое значение:
// 	Строка - значение PRIVATE-TOKEN (макс. 50);
// 
Функция GitLabUserPrivateToken() Экспорт
	
	Возврат Константы.GitLabUserPrivateToken.Получить();
	
КонецФункции

// Получает значение константы с таймаутом соединения к серверу GitLab.
//
// Параметры:
// Возвращаемое значение:
// 	Число - таймаут соединения, секунд (0 - таймаут не установлен);
//
Функция ТаймаутGitLab() Экспорт
	
	Возврат Константы.ТаймаутGitLab.Получить();

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает значение настройки включения/отключения функционала обработки запросов от внешнего хранилища GitLab.
//
// Параметры:
// Возвращаемое значение:
// 	Булево - Истина - загружать, Ложь - загрузка запрещена;
//
Функция ОбрабатыватьЗапросыВнешнегоХранилища()
	
	Возврат Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Получить();

КонецФункции

// Получает значение константы AccessTokenReceiver, используемое для подключения к сервисам
// конечных точек доставки файлов.
// 
// Параметры:
// Возвращаемое значение:
// 	Строка - token подключения к базе получателю (макс. 20);
// 
Функция AccessTokenReceiver()
	
	Возврат Константы.AccessTokenReceiver.Получить();
	
КонецФункции

// Получает значение константы с таймаутом соединения к веб-сервису информационной базы получателя.
//
// Параметры:
// Возвращаемое значение:
// 	Число - таймаут соединения, секунд (0 - таймаут не установлен);
//
Функция ТаймаутДоставкиФайла()
	
	Возврат Константы.ТаймаутДоставкиФайла.Получить();
	
КонецФункции

#КонецОбласти