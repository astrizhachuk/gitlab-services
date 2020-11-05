#Region Internal

// @unit-test
Процедура ConnectionParams(Фреймворк) Экспорт

	// given
	Константы.TokenReceiver.Установить("998");
	Константы.TimeoutDeliveryFile.Установить(999);
	// when
	Результат = Receivers.ConnectionParams();
	// then
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 3);
	Фреймворк.ПроверитьРавенство(Результат.URL, "");
	Фреймворк.ПроверитьРавенство(Результат.Token, "998");
	Фреймворк.ПроверитьРавенство(Результат.Timeout, 999);		

КонецПроцедуры

// @unit-test
Процедура ConnectionParamsNegativeTimeout(Фреймворк) Экспорт

	// given
	Константы.TokenReceiver.Установить("998");
	Константы.TimeoutDeliveryFile.Установить(999);
	// when
	Результат = Receivers.ConnectionParams();
	// then
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 3);
	Фреймворк.ПроверитьРавенство(Результат.URL, "");
	Фреймворк.ПроверитьРавенство(Результат.Token, "998");
	Константы.TimeoutDeliveryFile.Установить(-5);
	Результат = Receivers.ConnectionParams();
	Фреймворк.ПроверитьРавенство(Результат.Timeout, 0);

КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFileWithoutSendParamsAndWithoutEventParams(Фреймворк) Экспорт
	
	RAISE_MESSAGE = НСтр("ru = 'Должно быть вызвано исключение.';en = 'Should raise an error.'");
	EVENT_MESSAGE = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю';en = 'Webhooks.Core.SendingFileReceiver'");
	MISSING_DELIVERY_MESSAGE = НСтр("ru = 'Отсутствуют параметры доставки файлов.';en = 'File delivery options are missing.'");
	
	// given
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации(EVENT_MESSAGE, "Ошибка");
	
	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;
	// when
	Попытка
		Receivers.SendFile(ИмяФайла, Данные, ПараметрыДоставки);
		ВызватьИсключение RAISE_MESSAGE;
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, MISSING_DELIVERY_MESSAGE);
	КонецПопытки;
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, MISSING_DELIVERY_MESSAGE);	
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFileWithoutSendParamsAndEventParamsExists(Фреймворк) Экспорт
	
	RAISE_MESSAGE = НСтр("ru = 'Должно быть вызвано исключение.';en = 'Should raise an error.'");
	EVENT_MESSAGE_500 = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.500';en = 'Webhooks.Core.SendingFileReceiver.500'");
	MISSING_DELIVERY_MESSAGE = НСтр("ru = 'Отсутствуют параметры доставки файлов.';en = 'File delivery options are missing.'");
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации(EVENT_MESSAGE_500, "Ошибка");
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "Webhook", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "0123456789abcdef" );
	
	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;
	// when
	Попытка
		Receivers.SendFile(ИмяФайла, Данные, ПараметрыДоставки, ПараметрыСобытия);
		ВызватьИсключение RAISE_MESSAGE;
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, MISSING_DELIVERY_MESSAGE);
	КонецПопытки;
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, "[ 0123456789abcdef ]: " + MISSING_DELIVERY_MESSAGE));
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFileError403ForbiddenWithoutEventParams(Фреймворк) Экспорт
	
	EVENT_MESSAGE = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю';en = 'Webhooks.Core.SendingFileReceiver'");
	ERROR_STATUS_CODE_MESSAGE = НСтр( "ru = '[ Ошибка ]: Код ответа: ';en = '[ Error ]: Response Code: '" );
	DELIVERED_MESSAGE = НСтр( "ru = 'адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; текст ответа:';
							|en = 'delivery address: http://mock-server:1080/update; file: ВнешняяОбработка1.epf; response message:'" );

	// given
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации(EVENT_MESSAGE, "Ошибка");
	
	URL = "http://mock-server:1080";
	
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""403""");
	Мок = Неопределено;

	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;
	ПараметрыДоставки.Вставить("URL", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Timeout", 5);

	// when	
	Попытка
		Receivers.SendFile(ИмяФайла, Данные, ПараметрыДоставки);
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, DELIVERED_MESSAGE);
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, ERROR_STATUS_CODE_MESSAGE + "403");
	КонецПопытки;
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, ERROR_STATUS_CODE_MESSAGE + "403");	
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, DELIVERED_MESSAGE));
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFileError403ForbiddenEventParamsExists(Фреймворк) Экспорт
	
	EVENT_MESSAGE_403 = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.403';en = 'Webhooks.Core.SendingFileReceiver.403'");
	ERROR_STATUS_CODE_MESSAGE = НСтр( "ru = '[ Ошибка ]: Код ответа: ';en = '[ Error ]: Response Code: '" );
	DELIVERED_MESSAGE = НСтр( "ru = 'адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; текст ответа:';
							|en = 'delivery address: http://mock-server:1080/update; file: ВнешняяОбработка1.epf; response message:'" );
	

	// given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации(EVENT_MESSAGE_403, "Ошибка");
	
	URL = "http://mock-server:1080";
	
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""403""");
	Мок = Неопределено;

	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;
	ПараметрыДоставки.Вставить("URL", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Timeout", 5);
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "Webhook", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "0123456789abcdef" );

	// when	
	Попытка
		Receivers.SendFile(ИмяФайла, Данные, ПараметрыДоставки, ПараметрыСобытия);
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, DELIVERED_MESSAGE);
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, ERROR_STATUS_CODE_MESSAGE + "403");
	КонецПопытки;
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, ERROR_STATUS_CODE_MESSAGE + "403");	
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, "[ 0123456789abcdef ]: " + DELIVERED_MESSAGE));
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFile200OkWithoutEventParams(Фреймворк) Экспорт
	
	EVENT_MESSAGE = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю';en = 'Webhooks.Core.SendingFileReceiver'");
	DELIVERED_MESSAGE = НСтр( "ru = 'адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; текст ответа:';
							|en = 'delivery address: http://mock-server:1080/update; file: ВнешняяОбработка1.epf; response message:'" );

	
	// given
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации(EVENT_MESSAGE);
	
	URL = "http://mock-server:1080";
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""200""");
	Мок = Неопределено;

	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;	
	ПараметрыДоставки.Вставить("URL", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Timeout", 5);
	
	// when
	Receivers.SendFile(ИмяФайла, Данные, ПараметрыДоставки);
	
	// then
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, DELIVERED_MESSAGE));
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, """message"" : ""Любое сообщение...""");
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFile200OkEventParamsExists(Фреймворк) Экспорт
	
	EVENT_MESSAGE_200 = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.200';en = 'Webhooks.Core.SendingFileReceiver.200'");
	DELIVERED_MESSAGE = НСтр( "ru = 'адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; текст ответа:';
							|en = 'delivery address: http://mock-server:1080/update; file: ВнешняяОбработка1.epf; response message:'" );
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации(EVENT_MESSAGE_200);
	
	URL = "http://mock-server:1080";
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""200""");
	Мок = Неопределено;

	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;	
	ПараметрыДоставки.Вставить("URL", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Timeout", 5);
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "Webhook", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "0123456789abcdef" );
	
	// when
	Receivers.SendFile(ИмяФайла, Данные, ПараметрыДоставки, ПараметрыСобытия);
	
	// then
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, "[ 0123456789abcdef ]: " + DELIVERED_MESSAGE);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, """message"" : ""Любое сообщение...""");
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFileWithoutSendParamsBackgroundJob(Фреймворк) Экспорт
	
	EVENT_MESSAGE_500 = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.500';en = 'Webhooks.Core.SendingFileReceiver.500'");
	MISSING_DELIVERY_MESSAGE = НСтр("ru = 'Отсутствуют параметры доставки файлов.';en = 'File delivery options are missing.'");
	
	//given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации(EVENT_MESSAGE_500, "Ошибка");
	
	ПараметрыДоставки = Новый Структура;
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "Webhook", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "0123456789abcdef" );
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить("ВнешняяОбработка1.epf");
	ПараметрыЗадания.Добавить(ПолучитьДвоичныеДанныеИзСтроки("Тест"));
	ПараметрыЗадания.Добавить(ПараметрыДоставки);
	ПараметрыЗадания.Добавить(ПараметрыСобытия);
	
	// when
	ЗаданиеОтправкаФайла = ФоновыеЗадания.Выполнить("Receivers.SendFile", ПараметрыЗадания);

	// then
	Результат = ЗаданиеОтправкаФайла.ОжидатьЗавершенияВыполнения();
	Фреймворк.ПроверитьРавенство(Результат.Состояние, СостояниеФоновогоЗадания.ЗавершеноАварийно);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(Результат.ИнформацияОбОшибке.Описание, "[ 0123456789abcdef ]: " + MISSING_DELIVERY_MESSAGE));
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, "[ 0123456789abcdef ]: " + MISSING_DELIVERY_MESSAGE));

КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFileBackgroundJobSingleFile200OkEventParamsExists(Фреймворк) Экспорт
	
	EVENT_MESSAGE_200 = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.200';en = 'Webhooks.Core.SendingFileReceiver.200'");
	DELIVERED_MESSAGE = НСтр( "ru = 'адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; текст ответа:';
							|en = 'delivery address: http://mock-server:1080/update; file: ВнешняяОбработка1.epf; response message:'" );
	
	//given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации(EVENT_MESSAGE_200);
	
	URL = "http://mock-server:1080";
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""200""");
	Мок = Неопределено;
	
	ПараметрыДоставки = Новый Структура;
	ПараметрыДоставки.Вставить("URL", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Timeout", 5);
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "Webhook", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "0123456789abcdef" );
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить("ВнешняяОбработка1.epf");
	ПараметрыЗадания.Добавить(ПолучитьДвоичныеДанныеИзСтроки("Тест"));
	ПараметрыЗадания.Добавить(ПараметрыДоставки);
	ПараметрыЗадания.Добавить(ПараметрыСобытия);	
		
	// when
	ЗаданиеОтправкаФайла = ФоновыеЗадания.Выполнить("Receivers.SendFile",	ПараметрыЗадания);
		
	// then
	Результат = ЗаданиеОтправкаФайла.ОжидатьЗавершенияВыполнения();
	Фреймворк.ПроверитьРавенство(Результат.Состояние, СостояниеФоновогоЗадания.Завершено);

	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, "[ 0123456789abcdef ]: " + DELIVERED_MESSAGE);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, """message"" : ""Любое сообщение...""");
		
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура SendFileBackgroundJobMultipleFiles200OkEventParamsExists(Фреймворк) Экспорт
	
	EVENT_MESSAGE_200 = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.200';en = 'Webhooks.Core.SendingFileReceiver.200'");
	EVENT_MESSAGE_500 = НСтр("ru = 'ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.500';en = 'Webhooks.Core.SendingFileReceiver.500'");
	MISSING_DELIVERY_MESSAGE = НСтр("ru = 'Отсутствуют параметры доставки файлов.';en = 'File delivery options are missing.'");
	DELIVERED_MESSAGE = НСтр( "ru = 'адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; текст ответа:';
							|en = 'delivery address: http://mock-server:1080/update; file: ВнешняяОбработка1.epf; response message:'" );
	
	// given
	// three files: two good, one bad
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрацииИнформация = ОтборЖурналаРегистрации(EVENT_MESSAGE_200);
	ОтборЖурналаРегистрацииОшибка = ОтборЖурналаРегистрации(EVENT_MESSAGE_500, "Ошибка");
	
	URL = "http://mock-server:1080";
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""200""");
	Мок = Неопределено;	
	
	ПараметрыДоставки = Новый Структура;
	ПараметрыДоставки.Вставить("URL", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Timeout", 5);
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "Webhook", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "0123456789abcdef" );
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить("ВнешняяОбработка1.epf");
	ПараметрыЗадания.Добавить(ПолучитьДвоичныеДанныеИзСтроки("Тест"));
	ПараметрыЗадания.Добавить(ПараметрыДоставки);
	ПараметрыЗадания.Добавить(ПараметрыСобытия);	

	// when
	МассивФоновыхЗаданий = Новый Массив;
	Для Индекс = 1 По 3 Цикл
		Если Индекс = 2 Тогда
			ПараметрыЗадания[2] = Новый Структура;
		Иначе
			ПараметрыЗадания[2] = ПараметрыДоставки;
		КонецЕсли;
		
		ЗаданиеОтправкаФайла = ФоновыеЗадания.Выполнить("Receivers.SendFile",
											ПараметрыЗадания,
											"Индекс" + Индекс,
											"Test.Receivers.SendFile." + Индекс);
		МассивФоновыхЗаданий.Добавить(ЗаданиеОтправкаФайла.ОжидатьЗавершенияВыполнения(10));
	КонецЦикла;

	// then
	Фреймворк.ПроверитьРавенство(МассивФоновыхЗаданий[0].Состояние, СостояниеФоновогоЗадания.Завершено);
	Фреймворк.ПроверитьРавенство(МассивФоновыхЗаданий[1].Состояние, СостояниеФоновогоЗадания.ЗавершеноАварийно);
	Фреймворк.ПроверитьРавенство(МассивФоновыхЗаданий[2].Состояние, СостояниеФоновогоЗадания.Завершено);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(МассивФоновыхЗаданий[1].ИнформацияОбОшибке.Описание, "[ 0123456789abcdef ]: " + MISSING_DELIVERY_MESSAGE));
	
	ЖурналРегистрацииИнформация = СобытияЖурналаРегистрации(ОтборЖурналаРегистрацииИнформация);
	Фреймворк.ПроверитьРавенство(ЖурналРегистрацииИнформация.Количество(), 2);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрацииИнформация[0].Comment, "[ 0123456789abcdef ]: " + DELIVERED_MESSAGE);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрацииИнформация[0].Comment, """message"" : ""Любое сообщение...""");
	Фреймворк.ПроверитьВхождение(ЖурналРегистрацииИнформация[1].Comment, "[ 0123456789abcdef ]: "  + DELIVERED_MESSAGE);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрацииИнформация[1].Comment, """message"" : ""Любое сообщение...""");	
	
	ЖурналРегистрацииОшибка = СобытияЖурналаРегистрации(ОтборЖурналаРегистрацииОшибка);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрацииОшибка[0].Comment, "[ 0123456789abcdef ]: " + MISSING_DELIVERY_MESSAGE));

КонецПроцедуры

#EndRegion

#Region Private

Процедура УдалитьВсеОбработчикиСобытий()
	
	Тест_ОбщийМодульСервер.СправочникиУдалитьВсеДанные("ОбработчикиСобытий");

КонецПроцедуры

Функция ОтборЖурналаРегистрации(Событие, Уровень = "Информация")
	
	Возврат Тест_ОбщийМодульСервер.ОтборЖурналаРегистрации(Событие, Уровень);
	
КонецФункции

Функция СобытияЖурналаРегистрации(Отбор, Секунд = 2)
	
	Возврат Тест_ОбщийМодульСервер.СобытияЖурналаРегистрации(Отбор, Секунд);
	
КонецФункции

#EndRegion