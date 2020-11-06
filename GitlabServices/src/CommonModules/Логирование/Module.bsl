#Region Public

// Возвращает дополнительные параметры записи журнала регистрации.
// 
// Returns:
// Структура - описание:
//   * Объект - ЛюбаяСсылка - ссылка на объект, метаданные которого необходимо добавить в журнал регистрации;
//   * HTTPОтвет - HTTPОтвет, HTTPСервисОтвет - HTTP-ответ сервера или веб-сервиса;
//
Функция ДополнительныеПараметры( Знач ЛогируемыйОбъект = Неопределено, Знач HTTPОтвет = Неопределено ) Экспорт
	
	Var Результат;
	
	Результат = Новый Структура();
	Результат.Вставить( "ЛогируемыйОбъект", ЛогируемыйОбъект );
	Результат.Вставить( "HTTPОтвет", HTTPОтвет );
	
	Возврат Результат;
	
КонецФункции

// Логирует информационное событие. Если в дополнительных данных передать HTTPОтвет или HTTPСервисОтвет, то в событие
// логируемого сообдения будет добавлен код события, а в случае HTTPСервисОтвет данный объект будет дозаполнен данными
// логируемого сообщения (для кода 200).  
// 
// Параметры:
// 	Событие - Строка - логируемое событие в формате "ГруппаСобытий.Событие.Дополнительно";
// 	Сообщение - Строка - текст сообщения;
// 	ДополнительныеДанные - Структура - описание:
//   * Объект - ЛюбаяСсылка - ссылка на объект, метаданные которого необходимо добавить в журнал регистрации;
//   * HTTPОтвет - HTTPОтвет, HTTPСервисОтвет - HTTP-ответ сервера или веб-сервиса;
//
Процедура Информация(Знач Событие, Знач Сообщение, ДополнительныеДанные = Неопределено) Экспорт

	ПодготовитьHTTPСервисОтвет( ДополнительныеДанные, УровеньЖурналаРегистрации.Информация, Сообщение);
	Записать( Событие, УровеньЖурналаРегистрации.Информация, Сообщение, ДополнительныеДанные);

КонецПроцедуры

// Логирует предупреждение. Если в дополнительных данных передать HTTPОтвет или HTTPСервисОтвет, то в событие
// логируемого сообдения будет добавлен код события, а в случае HTTPСервисОтвет данный объект будет дозаполнен данными
// логируемого сообщения (для кода 200).
// 
// Параметры:
// 	Событие - Строка - логируемое событие в формате "ГруппаСобытий.Событие.Дополнительно";
// 	Сообщение - Строка - текст сообщения;
// 	ДополнительныеДанные - Структура - описание:
//   * Объект - ЛюбаяСсылка - ссылка на объект, метаданные которого необходимо добавить в журнал регистрации;
//   * HTTPОтвет - HTTPОтвет, HTTPСервисОтвет - HTTP-ответ сервера или веб-сервиса;
//
Процедура Предупреждение(Знач Событие, Знач Сообщение, Знач ДополнительныеДанные = Неопределено) Экспорт

	ПодготовитьHTTPСервисОтвет( ДополнительныеДанные, УровеньЖурналаРегистрации.Предупреждение,	Сообщение);
	Записать( Событие, УровеньЖурналаРегистрации.Предупреждение, Сообщение, ДополнительныеДанные);

КонецПроцедуры

// Логирует ошибку. Если в дополнительных данных передать HTTPОтвет или HTTPСервисОтвет, то в событие
// логируемого сообдения будет добавлен код события, а в случае HTTPСервисОтвет данный объект будет дозаполнен данными
// логируемого сообщения (для кода 200).
// 
// Параметры:
// 	Событие - Строка - логируемое событие в формате "ГруппаСобытий.Событие.Дополнительно";
// 	Сообщение - Строка - текст сообщения;
// 	ДополнительныеДанные - Структура - описание:
//   * Объект - ЛюбаяСсылка - ссылка на объект, метаданные которого необходимо добавить в журнал регистрации;
//   * HTTPОтвет - HTTPОтвет, HTTPСервисОтвет - HTTP-ответ сервера или веб-сервиса;
//
Процедура Ошибка(Знач Событие, Знач Сообщение, Знач ДополнительныеДанные = Неопределено) Экспорт

	ПодготовитьHTTPСервисОтвет( ДополнительныеДанные, УровеньЖурналаРегистрации.Ошибка, Сообщение);
	Записать( Событие, УровеньЖурналаРегистрации.Ошибка, Сообщение, ДополнительныеДанные);

КонецПроцедуры

// Возвращает дополненный текст сообщения префиксом в формате: "[ префикс ]: сообщение"
// 
// Параметры:
// 	Сообщение - строка - текст сообщения;
// 	Префикс - Строка - префикс;
// 	
// Returns:
// 	Строка - текст сообщения с префиксом;
//
Функция ДополнитьСообщениеПрефиксом( Сообщение, Знач Префикс ) Экспорт

	Возврат "[ " + Префикс + " ]: " + Сообщение;

КонецФункции

#EndRegion

#Region Private

Функция СоответствиеТиповСообщенийСхемеОтвета()
	
	Var Результат;
	
	Результат = Новый Соответствие();
	Результат.Вставить( НСтр("ru = 'Информация';en = 'Information'"), "info" );
	Результат.Вставить( НСтр("ru = 'Предупреждение';en = 'Warning'"), "warning" );
	Результат.Вставить( НСтр("ru = 'Ошибка';en = 'Error'"), "error" );
	
	Возврат Результат;
		
КонецФункции

Процедура ДополнитьТекстСобытияКодомСостояния( Событие, Знач ДополнительныеДанные = Неопределено)
	
	Var HTTPОбъект;
	
	HTTPОбъект = CommonUseClientServer.StructureProperty( ДополнительныеДанные, "HTTPОтвет" );

	Если ( HTTPОбъект <> Неопределено ) Тогда
			
		Событие = Событие + "." + Строка( HTTPОбъект.КодСостояния );
		
	КонецЕсли;

КонецПроцедуры

Процедура ПодготовитьHTTPСервисОтвет( ДополнительныеДанные, Знач Тип, Знач Сообщение )
	
	Var HTTPОтвет;
	Var ТелоОтвета;
	Var СформироватьТелоЗапроса;
	
	HTTPОтвет = CommonUseClientServer.StructureProperty( ДополнительныеДанные, "HTTPОтвет" );
	
	Если ( HTTPОтвет = Неопределено ) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СформироватьТелоЗапроса = HTTPStatusCodesClientServerCached.isOk(HTTPОтвет.КодСостояния)
			ИЛИ HTTPStatusCodesClientServerCached.isForbidden(HTTPОтвет.КодСостояния)
			ИЛИ HTTPStatusCodesClientServerCached.isLocked(HTTPОтвет.КодСостояния);

	Если ( СформироватьТелоЗапроса ) Тогда

		HTTPОтвет.Заголовки.Вставить("Content-Type", "application/json");
		
		ТелоОтвета = HTTPСервисы.СтруктураОтвета();
		ТелоОтвета.message = Сообщение;
		ТелоОтвета.type = СоответствиеТиповСообщенийСхемеОтвета().Получить( Строка(Тип) );
		
		HTTPОтвет.УстановитьТелоИзСтроки( HTTPConnector.ОбъектВJson(ТелоОтвета) );

	КонецЕсли;
	
КонецПроцедуры

Процедура Записать( Знач Событие, Знач Тип, Знач Сообщение, Знач ДополнительныеДанные = Неопределено )
	
	Var Объект;
	
	EVENT_CONTEXT = НСтр( "ru = 'ОбработчикиСобытий';en = 'Webhooks'" ); 
	
	ДополнитьТекстСобытияКодомСостояния( Событие, ДополнительныеДанные );

	Событие = EVENT_CONTEXT + "." + Событие;
	Объект = CommonUseClientServer.StructureProperty( ДополнительныеДанные, "ЛогируемыйОбъект") ;

	Если (Объект = Неопределено) Тогда

		ЗаписьЖурналаРегистрации( Событие, Тип, , , Сообщение);

	Иначе

		ЗаписьЖурналаРегистрации( Событие, Тип, Метаданные.НайтиПоТипу(ТипЗнч(Объект)), Объект, Сообщение );

	КонецЕсли;

КонецПроцедуры

#EndRegion