#Region Internal

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура НайтиПоСекретномуКлючуПустаяСсылкаЕслиПараметрЧисло(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	// when
	Результат = ОбработчикиСобытий.НайтиПоСекретномуКлючу(1);
	// then
	Фреймворк.ПроверитьНеЗаполненность(Результат);

КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура НайтиПоСекретномуКлючуПустаяСсылкаЕслиПараметрПустаяСтрока(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	// when
	Результат = ОбработчикиСобытий.НайтиПоСекретномуКлючу("");
	// then
	Фреймворк.ПроверитьНеЗаполненность(Результат);

КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура НайтиПоСекретномуКлючуПустаяСсылкаЕслиПараметрНеопределено(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	// when
	Результат = ОбработчикиСобытий.НайтиПоСекретномуКлючу(Неопределено);
	// then
	Фреймворк.ПроверитьНеЗаполненность(Результат);

КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура НайтиПоСекретномуКлючуПустаяСсылкаЕслиНеНайдено(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	// when
	Результат = ОбработчикиСобытий.НайтиПоСекретномуКлючу("блаблаблаблака");
	// then
	Фреймворк.ПроверитьНеЗаполненность(Результат);

КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура НайтиПоСекретномуКлючу(Фреймворк) Экспорт
	
	// given
	СекретныйКлюч = "ЮнитТест";
	УдалитьВсеОбработчикиСобытий();
	// Создаем три записи с одинаковым ключом, первая и третья помечены на удаление.
	ОбработчикСобытия1 = ДобавитьОбработчикСобытий("ЮнитТест1", СекретныйКлюч);
	ОбработчикСобытия1.ПометкаУдаления = Истина;
	ОбработчикСобытия1.Записать();
	ОбработчикСобытия2 = ДобавитьОбработчикСобытий("ЮнитТест2", СекретныйКлюч);
	ОбработчикСобытия2.ПометкаУдаления = Истина;
	ОбработчикСобытия2.Записать();
	Код = ОбработчикСобытия2.Ссылка.Код;
	ОбработчикСобытия3 = ДобавитьОбработчикСобытий("ЮнитТест3", СекретныйКлюч);
	ОбработчикСобытия3.ПометкаУдаления = Истина;
	ОбработчикСобытия3.Записать();
	ОбработчикСобытия2.ПометкаУдаления = Ложь;
	ОбработчикСобытия2.Записать();
	// Еще запись, но уже с другим ключом.
	ДобавитьОбработчикСобытий("ЮнитТест4", СекретныйКлюч + "Бадабумс");
	// when	
	Результат = ОбработчикиСобытий.НайтиПоСекретномуКлючу(СекретныйКлюч);
	// then
	Фреймворк.Что(Результат.Код).Равно(Код);
	
КонецПроцедуры

// @unit-test:dev
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ЗагрузитьИсториюСобытий(Фреймворк) Экспорт
	
	//given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	ОбработчикСобытия = ДобавитьОбработчикСобытий("ЮнитТест1", "ЮнитТест");
	ЗаписьЖурналаРегистрации("ОбработчикиСобытий.Операция.Что", УровеньЖурналаРегистрации.Информация );
	ЗаписьЖурналаРегистрации("ОбработчикиСобытий.Операция.Что.Что", УровеньЖурналаРегистрации.Информация, Метаданные.НайтиПоТипу(ТипЗнч(ОбработчикСобытия)), ОбработчикСобытия.Ссылка );
	ЗаписьЖурналаРегистрации("ОбработчикиСобытий.Операция.Что.Что.200", УровеньЖурналаРегистрации.Информация, Метаданные.НайтиПоТипу(ТипЗнч(ОбработчикСобытия)), ОбработчикСобытия.Ссылка );
	Тест_ОбщийМодульСервер.Пауза(2);
	Filter = Новый Структура;
	Filter.Insert("StartDate", НачалоДня(ТекущаяДата()));
	Filter.Insert("EndDate", КонецДня(ТекущаяДата()));
	RecordsLoaded = 0;
	// when	
	ОбработчикиСобытий.ЗагрузитьИсториюСобытий( ОбработчикСобытия, "EventsHistory", Filter, RecordsLoaded );
	// then
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory.Количество(), 2);
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[0].Action, "Операция");
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[1].Action, "Операция");
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[0].Level, "Информация");
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[1].Level, "Информация");
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[0].Event, "ОбработчикиСобытий.Операция.Что.Что");
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[1].Event, "ОбработчикиСобытий.Операция.Что.Что.200");
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[0].EventPresentation, "Что.Что");
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[1].EventPresentation, "Что.Что");
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[0].HTTPStatusCode, 0);
	Фреймворк.ПроверитьРавенство(ОбработчикСобытия.EventsHistory[1].HTTPStatusCode, 200);
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура СохранитьДанныеЗапросаУспешно(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	СекретныйКлюч = "ЮнитТест";
	ОбработчикСобытия = ДобавитьОбработчикСобытий("ЮнитТест1", СекретныйКлюч);
	Данные = "Тест";
	// when	
	ОбработчикиСобытий.СохранитьДанныеЗапроса(ОбработчикСобытия.Ссылка, "Ключ", Данные);
	// then
	НаборЗаписей = РегистрыСведений[ "ДанныеЗапросов" ].СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбработчикСобытия.Установить( ОбработчикСобытия.Ссылка );
	НаборЗаписей.Отбор.Ключ.Установить( "Ключ" );
	НаборЗаписей.Прочитать();
	Фреймворк.ПроверитьРавенство(НаборЗаписей.Количество(), 1);
	Фреймворк.ПроверитьРавенство(НаборЗаписей[0].Данные.Получить(), "Тест");
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура СохранитьДанныеЗапросаЗаписьОшибкаЗаписи(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	Данные = "Тест";
	// when
	Попытка
		ОбработчикиСобытий.СохранитьДанныеЗапроса(Справочники.ОбработчикиСобытий.ПустаяСсылка(), "Ключ", Данные);
		ВызватьИсключение НСтр("ru = 'Должно быть вызвано исключение.';en = 'Should raise an error.'");
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, НСтр("ru = 'Ошибка при вызове метода контекста (Записать)';en = 'Ошибка при вызове метода контекста (Write)'"));
	КонецПопытки;
	
КонецПроцедуры

// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура СохранитьВнешниеФайлыУспешно(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	СекретныйКлюч = "ЮнитТест";
	ОбработчикСобытия = ДобавитьОбработчикСобытий("ЮнитТест1", СекретныйКлюч);
	Данные = "Тест";
	// when	
	ОбработчикиСобытий.СохранитьВнешниеФайлы(ОбработчикСобытия.Ссылка, "Ключ", Данные);
	// then
	НаборЗаписей = РегистрыСведений[ "ВнешниеФайлы" ].СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбработчикСобытия.Установить( ОбработчикСобытия.Ссылка );
	НаборЗаписей.Отбор.Ключ.Установить( "Ключ" );
	НаборЗаписей.Прочитать();
	Фреймворк.ПроверитьРавенство(НаборЗаписей.Количество(), 1);
	Фреймворк.ПроверитьРавенство(НаборЗаписей[0].Данные.Получить(), "Тест");
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура СохранитьВнешниеФайлыЗаписьОшибкаЗаписи(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	Данные = "Тест";
	// when
	Попытка
		ОбработчикиСобытий.СохранитьВнешниеФайлы(Справочники.ОбработчикиСобытий.ПустаяСсылка(), "Ключ", Данные);
		ВызватьИсключение НСтр("ru = 'Должно быть вызвано исключение.';en = 'Should raise an error.'");
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(ИнформацияОбОшибке.Описание, НСтр("ru = 'Ошибка при вызове метода контекста (Записать)';en = 'Ошибка при вызове метода контекста (Write)'"));
	КонецПопытки;
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ЗагрузитьВнешниеФайлы(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	СекретныйКлюч = "ЮнитТест";
	ОбработчикСобытия = ДобавитьОбработчикСобытий("ЮнитТест1", СекретныйКлюч);
	
	Данные = Новый ТаблицаЗначений;
	Данные.Колонки.Добавить("Колонка");
	НоваяСтрока = Данные.Добавить();
	НоваяСтрока.Колонка = "Тест";
	
	МенеджерЗаписи = РегистрыСведений.ВнешниеФайлы.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОбработчикСобытия = ОбработчикСобытия.Ссылка;
	МенеджерЗаписи.Ключ = "Ключ";
	МенеджерЗаписи.Данные = Новый ХранилищеЗначения(Данные);
	МенеджерЗаписи.Записать();
	
	// when	
	Результат = ОбработчикиСобытий.ЗагрузитьВнешниеФайлы( ОбработчикСобытия.Ссылка, "Ключ" );
	// then
	Фреймворк.ПроверитьТип(Результат, "ТаблицаЗначений");
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1);
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ЗагрузитьВнешниеФайлыОтсутствуютДанные(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	СекретныйКлюч = "ЮнитТест";
	ОбработчикСобытия = ДобавитьОбработчикСобытий("ЮнитТест1", СекретныйКлюч);
	// when	
	Результат = ОбработчикиСобытий.ЗагрузитьВнешниеФайлы( ОбработчикСобытия.Ссылка, "Ключ" );
	// then
	Фреймворк.ПроверитьТип(Результат, "ТаблицаЗначений");
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 0);
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ЗагрузитьДанныеЗапроса(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	СекретныйКлюч = "ЮнитТест";
	ОбработчикСобытия = ДобавитьОбработчикСобытий("ЮнитТест1", СекретныйКлюч);
	
	Данные = Новый Соответствие();
	Данные.Вставить("Ключ", "Значение");
	
	МенеджерЗаписи = РегистрыСведений.ДанныеЗапросов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОбработчикСобытия = ОбработчикСобытия.Ссылка;
	МенеджерЗаписи.Ключ = "Ключ";
	МенеджерЗаписи.Данные = Новый ХранилищеЗначения(Данные);
	МенеджерЗаписи.Записать();
	
	// when	
	Результат = ОбработчикиСобытий.ЗагрузитьДанныеЗапроса( ОбработчикСобытия.Ссылка, "Ключ" );
	// then
	Фреймворк.ПроверитьТип(Результат, "Соответствие");
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1);
	Фреймворк.ПроверитьРавенство(Результат.Получить("Ключ"), "Значение");
	
КонецПроцедуры

// @unit-test
// Параметры:
// 	Фреймворк - ФреймворкТестирования - Фреймворк тестирования
//
Процедура ЗагрузитьДанныеЗапросаОтсутствуютДанные(Фреймворк) Экспорт
	
	// given
	УдалитьВсеОбработчикиСобытий();
	ОчиститьРегистрыСведений();
	СекретныйКлюч = "ЮнитТест";
	ОбработчикСобытия = ДобавитьОбработчикСобытий("ЮнитТест1", СекретныйКлюч);
	// when	
	Результат = ОбработчикиСобытий.ЗагрузитьДанныеЗапроса( ОбработчикСобытия.Ссылка, "Ключ" );
	// then
	Фреймворк.ПроверитьТип(Результат, "Соответствие");
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 0);
	
КонецПроцедуры

#EndRegion

#Region Private

Функция ДобавитьОбработчикСобытий(Знач Наименование = "", Знач СекретныйКлюч = "") Экспорт
	
		ОбработчикСобытия = Справочники.ОбработчикиСобытий.СоздатьЭлемент();
		ОбработчикСобытия.Наименование = Наименование;
		ОбработчикСобытия.SecretToken = СекретныйКлюч;
		ОбработчикСобытия.Записать();
		
		Возврат ОбработчикСобытия;
	
КонецФункции

Процедура УдалитьВсеОбработчикиСобытий()
	
	Тест_ОбщийМодульСервер.СправочникиУдалитьВсеДанные("ОбработчикиСобытий");

КонецПроцедуры

Процедура ОчиститьРегистрыСведений()
	
	Тест_ОбщийМодульСервер.РегистрыСведенийУдалитьВсеДанные("ДанныеЗапросов,ВнешниеФайлы");

КонецПроцедуры

Функция ОтборЖурналаРегистрации(Событие, Уровень = "Информация")
	
	Возврат Тест_ОбщийМодульСервер.ОтборЖурналаРегистрации(Событие, Уровень);
	
КонецФункции

Функция СобытияЖурналаРегистрации(Отбор, Секунд = 2)
	
	Возврат Тест_ОбщийМодульСервер.СобытияЖурналаРегистрации(Отбор, Секунд);
	
КонецФункции
	
#EndRegion