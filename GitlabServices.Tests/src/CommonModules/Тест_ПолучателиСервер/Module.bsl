#Region Internal

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанныхБезПараметровДоставкиОтсутствуютПараметрыСобытия(Фреймворк) Экспорт
	
	// given
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю", "Ошибка");
	
	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;
	// when
	Попытка
		Получатели.ОтправитьФайл(ИмяФайла, Данные, ПараметрыДоставки);
		ВызватьИсключение НСтр("ru = 'Должно быть вызвано исключение.';en = 'Should raise an error.'");
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, НСтр( "ru = 'Отсутствуют параметры доставки файлов';en = 'File delivery options are missing'"));
	КонецПопытки;
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, НСтр( "ru = 'Отсутствуют параметры доставки файлов';en = 'File delivery options are missing'"));	
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанныхБезПараметровДоставкиЕстьПараметрыСобытия(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.500", "Ошибка");
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "ОбработчикСобытия", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "какой-то коммит..." );
	
	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;
	// when
	Попытка
		Получатели.ОтправитьФайл(ИмяФайла, Данные, ПараметрыДоставки, ПараметрыСобытия);
		ВызватьИсключение НСтр("ru = 'Должно быть вызвано исключение.';en = 'Should raise an error.'");
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, НСтр( "ru = 'Отсутствуют параметры доставки файлов';en = 'File delivery options are missing'"));
	КонецПопытки;
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, "[ какой-то коммит... ]: " + НСтр( "ru = 'Отсутствуют параметры доставки файлов';en = 'File delivery options are missing'")));
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанныхОшибка403ForbiddenОтсутствуютПараметрыСобытия(Фреймворк) Экспорт

	// given
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю", "Ошибка");
	
	URL = "http://mock-server:1080";
	
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""403""");
	Мок = Неопределено;

	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;
	ПараметрыДоставки.Вставить("Адрес", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Таймаут", 5);

	// when	
	Попытка
		Получатели.ОтправитьФайл(ИмяФайла, Данные, ПараметрыДоставки);
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, "адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; сообщение");
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, "[ Error ]: Response Code: 403");
	КонецПопытки;
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, "[ Error ]: Response Code: 403");	
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, "адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; сообщение"));
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанныхОшибка403ForbiddenЕстьПараметрыСобытия(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.403", "Ошибка");
	
	URL = "http://mock-server:1080";
	
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""403""");
	Мок = Неопределено;

	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;
	ПараметрыДоставки.Вставить("Адрес", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Таймаут", 5);
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "ОбработчикСобытия", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "какой-то коммит..." );

	// when	
	Попытка
		Получатели.ОтправитьФайл(ИмяФайла, Данные, ПараметрыДоставки, ПараметрыСобытия);
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, "адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; сообщение");
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, "[ Error ]: Response Code: 403");
	КонецПопытки;
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, "[ Error ]: Response Code: 403");	
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, "[ какой-то коммит... ]: адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf; сообщение"));
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанных200OkОтсутствуютПараметрыСобытия(Фреймворк) Экспорт
	
	// given
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю");
	
	URL = "http://mock-server:1080";
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""200""");
	Мок = Неопределено;

	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;	
	ПараметрыДоставки.Вставить("Адрес", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Таймаут", 5);
	
	// when
	Получатели.ОтправитьФайл(ИмяФайла, Данные, ПараметрыДоставки);
	
	// then
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, "адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf"));
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, """message"" : ""Любое сообщение...""");
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанных200OkЕстьПараметрыСобытия(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.200");
	
	URL = "http://mock-server:1080";
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""200""");
	Мок = Неопределено;

	ИмяФайла = "ВнешняяОбработка1.epf";
	Данные = ПолучитьДвоичныеДанныеИзСтроки("Тест");
	ПараметрыДоставки = Новый Структура;	
	ПараметрыДоставки.Вставить("Адрес", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Таймаут", 5);
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "ОбработчикСобытия", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "какой-то коммит..." );
	
	// when
	Получатели.ОтправитьФайл(ИмяФайла, Данные, ПараметрыДоставки, ПараметрыСобытия);
	
	// then
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, "[ какой-то коммит... ]: адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf");
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, """message"" : ""Любое сообщение...""");
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанныхБезПараметровДоставкиВФоне(Фреймворк) Экспорт
	
	//given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.500", "Ошибка");
	
	ПараметрыДоставки = Новый Структура;
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "ОбработчикСобытия", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "какой-то коммит..." );
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить("ВнешняяОбработка1.epf");
	ПараметрыЗадания.Добавить(ПолучитьДвоичныеДанныеИзСтроки("Тест"));
	ПараметрыЗадания.Добавить(ПараметрыДоставки);
	ПараметрыЗадания.Добавить(ПараметрыСобытия);
	
	// when
	ЗаданиеОтправкаФайла = ФоновыеЗадания.Выполнить("Получатели.ОтправитьФайл", ПараметрыЗадания);

	// then
	Результат = ЗаданиеОтправкаФайла.ОжидатьЗавершенияВыполнения();
	Фреймворк.ПроверитьРавенство(Результат.Состояние, СостояниеФоновогоЗадания.ЗавершеноАварийно);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(Результат.ИнформацияОбОшибке.Описание, "[ какой-то коммит... ]: " + НСтр( "ru = 'Отсутствуют параметры доставки файлов';en = 'File delivery options are missing'")));
	
	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрации[0].Comment, "[ какой-то коммит... ]: " + НСтр( "ru = 'Отсутствуют параметры доставки файлов';en = 'File delivery options are missing'")));

КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанныхВФонеОдинФайл200OkЕстьПараметрыСобытия(Фреймворк) Экспорт
	
	//given
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.200");
	
	URL = "http://mock-server:1080";
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""200""");
	Мок = Неопределено;
	
	ПараметрыДоставки = Новый Структура;
	ПараметрыДоставки.Вставить("Адрес", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Таймаут", 5);
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "ОбработчикСобытия", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "какой-то коммит..." );
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить("ВнешняяОбработка1.epf");
	ПараметрыЗадания.Добавить(ПолучитьДвоичныеДанныеИзСтроки("Тест"));
	ПараметрыЗадания.Добавить(ПараметрыДоставки);
	ПараметрыЗадания.Добавить(ПараметрыСобытия);	
		
	// when
	ЗаданиеОтправкаФайла = ФоновыеЗадания.Выполнить("Получатели.ОтправитьФайл",	ПараметрыЗадания);
		
	// then
	Результат = ЗаданиеОтправкаФайла.ОжидатьЗавершенияВыполнения();
	Фреймворк.ПроверитьРавенство(Результат.Состояние, СостояниеФоновогоЗадания.Завершено);

	ЖурналРегистрации = СобытияЖурналаРегистрации(ОтборЖурналаРегистрации);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, "[ какой-то коммит... ]: адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf");
	Фреймворк.ПроверитьВхождение(ЖурналРегистрации[0].Comment, """message"" : ""Любое сообщение...""");
		
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ПередачаДвоичныхДанныхВФонеТриФайла200OkЕстьПараметрыСобытия(Фреймворк) Экспорт
	
	// given
	// three files: two good, one bad
	УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ЮнитТест1", "Webhook");
	
	ОтборЖурналаРегистрацииИнформация = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.200");
	ОтборЖурналаРегистрацииОшибка = ОтборЖурналаРегистрации("ОбработчикиСобытий.Core.ОтправкаДанныхПолучателю.500", "Ошибка");
	
	URL = "http://mock-server:1080";
	Мок = Обработки.MockServerClient.Создать();
	Мок.Сервер(URL, , Истина).ОжидатьOpenAPI("file:/tmp/receiver.yaml", """update"": ""200""");
	Мок = Неопределено;	
	
	ПараметрыДоставки = Новый Структура;
	ПараметрыДоставки.Вставить("Адрес", URL + "/update");
	ПараметрыДоставки.Вставить("Token", "12345678901234567890");
	ПараметрыДоставки.Вставить("Таймаут", 5);
	
	ПараметрыСобытия = Новый Структура();
	ПараметрыСобытия.Вставить( "ОбработчикСобытия", ОбработчикСобытия.Ссылка );
	ПараметрыСобытия.Вставить( "CheckoutSHA", "какой-то коммит..." );
	
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
		
		ЗаданиеОтправкаФайла = ФоновыеЗадания.Выполнить("Получатели.ОтправитьФайл",
											ПараметрыЗадания,
											"Индекс" + Индекс,
											"Тест.Получатели.ОтправитьФайл." + Индекс);
		МассивФоновыхЗаданий.Добавить(ЗаданиеОтправкаФайла.ОжидатьЗавершенияВыполнения(10));
	КонецЦикла;

	// then
	Фреймворк.ПроверитьРавенство(МассивФоновыхЗаданий[0].Состояние, СостояниеФоновогоЗадания.Завершено);
	Фреймворк.ПроверитьРавенство(МассивФоновыхЗаданий[1].Состояние, СостояниеФоновогоЗадания.ЗавершеноАварийно);
	Фреймворк.ПроверитьРавенство(МассивФоновыхЗаданий[2].Состояние, СостояниеФоновогоЗадания.Завершено);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(МассивФоновыхЗаданий[1].ИнформацияОбОшибке.Описание, "[ какой-то коммит... ]: Отсутствуют параметры доставки файлов"));
	
	ЖурналРегистрацииИнформация = СобытияЖурналаРегистрации(ОтборЖурналаРегистрацииИнформация);
	Фреймворк.ПроверитьРавенство(ЖурналРегистрацииИнформация.Количество(), 2);
	Фреймворк.ПроверитьВхождение(ЖурналРегистрацииИнформация[0].Comment, "[ какой-то коммит... ]: адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf");
	Фреймворк.ПроверитьВхождение(ЖурналРегистрацииИнформация[0].Comment, """message"" : ""Любое сообщение...""");
	Фреймворк.ПроверитьВхождение(ЖурналРегистрацииИнформация[1].Comment, "[ какой-то коммит... ]: адрес доставки: http://mock-server:1080/update; файл: ВнешняяОбработка1.epf");
	Фреймворк.ПроверитьВхождение(ЖурналРегистрацииИнформация[1].Comment, """message"" : ""Любое сообщение...""");	
	
	ЖурналРегистрацииОшибка = СобытияЖурналаРегистрации(ОтборЖурналаРегистрацииОшибка);
	Фреймворк.ПроверитьИстину(СтрНачинаетсяС(ЖурналРегистрацииОшибка[0].Comment, "[ какой-то коммит... ]: " + НСтр( "ru = 'Отсутствуют параметры доставки файлов';en = 'File delivery options are missing'")));

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
