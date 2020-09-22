#Область СлужебныйПрограммныйИнтерфейс

// @unit-test
Процедура ТолькоСобытиеИнформация(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Информация, "ОбработчикиСобытий.Информация1.Информация2.Информация3");
	// when
	Логирование.Информация( "Информация1.Информация2.Информация3", "обушки-воробушки");
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");
	// then	
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Информация");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки", "Информация");
	
КонецПроцедуры

// @unit-test
Процедура ТолькоСобытиеПредупреждение(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Предупреждение, "ОбработчикиСобытий.Предупреждение1.Предупреждение2.Предупреждение3"); 
	// when
	Логирование.Предупреждение( "Предупреждение1.Предупреждение2.Предупреждение3", "обушки-воробушки2");
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");
	// then	
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Предупреждение");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки2", "Предупреждение");
	
КонецПроцедуры

// @unit-test
Процедура ТолькоСобытиеОшибка(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Ошибка, "ОбработчикиСобытий.Ошибка1.Ошибка2.Ошибка3");
	// when
	Логирование.Ошибка( "Ошибка1.Ошибка2.Ошибка3", "обушки-воробушки3");
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");
	// then	
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Ошибка");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки3", "Ошибка");
	
КонецПроцедуры

// @unit-test
Процедура СобытиеИнформацияСОбъектом(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Информация, "ОбработчикиСобытий.Информация11.Информация22.Информация33");
	Тест_ОбработчикиСобытийСервер.УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ТестЛогирование", "ТестЛогирование");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ОбработчикСобытия.Ссылка ); 
		
	// when
	Логирование.Информация( "Информация11.Информация22.Информация33", "обушки-воробушки", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then	
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Информация");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки", "Информация");
	Фреймворк.ПроверитьЛожь(ПустаяСтрока(Результат[0].ПредставлениеМетаданных), "Информация");
	
КонецПроцедуры

// @unit-test
Процедура СобытиеПредупреждениеСОбъектом(Фреймворк) Экспорт

	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Предупреждение, "ОбработчикиСобытий.Предупреждение11.Предупреждение22.Предупреждение33");	
	Тест_ОбработчикиСобытийСервер.УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ТестЛогирование", "ТестЛогирование");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ОбработчикСобытия.Ссылка ); 
	
	// when
	Логирование.Предупреждение( "Предупреждение11.Предупреждение22.Предупреждение33", "обушки-воробушки2", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");
	
	// then	
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Предупреждение");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки2", "Предупреждение");
	Фреймворк.ПроверитьЛожь(ПустаяСтрока(Результат[0].ПредставлениеМетаданных), "Предупреждение");
	
КонецПроцедуры

// @unit-test
Процедура СобытиеОшибкаСОбъектом(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Ошибка, "ОбработчикиСобытий.Ошибка11.Ошибка22.Ошибка33");
	Тест_ОбработчикиСобытийСервер.УдалитьВсеОбработчикиСобытий();
	ОбработчикСобытия = Тест_ОбработчикиСобытийСервер.ДобавитьОбработчикСобытий("ТестЛогирование", "ТестЛогирование");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ОбработчикСобытия.Ссылка );

	// when
	Логирование.Ошибка( "Ошибка11.Ошибка22.Ошибка33", "обушки-воробушки3", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then	
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Ошибка");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки3", "Ошибка");
	Фреймворк.ПроверитьЛожь(ПустаяСтрока(Результат[0].ПредставлениеМетаданных), "Ошибка");
	
КонецПроцедуры

// @unit-test
Процедура СобытиеИнформацияСОбъектомИHTTPСервисОтвет200(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Информация, "ОбработчикиСобытий.Информация111.Информация222.Информация333.200");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(200));

	// when
	Логирование.Информация( "Информация111.Информация222.Информация333", "обушки-воробушки", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then		
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Информация");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки", "Информация");
	
	Эталон = "{
		| ""type"": ""info"",
		| ""message"": ""обушки-воробушки""
		|}";	
	
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 200, "Информация");
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку(), Эталон, "Информация");
	
КонецПроцедуры

// @unit-test
Процедура СобытиеПредупреждениеСОбъектомИHTTPСервисОтвет200(Фреймворк) Экспорт

	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Предупреждение, "ОбработчикиСобытий.Предупреждение111.Предупреждение222.Предупреждение333.200");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(200));

	// when
	Логирование.Предупреждение( "Предупреждение111.Предупреждение222.Предупреждение333", "обушки-воробушки2", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then		
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Предупреждение");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки2", "Предупреждение");
	
	Эталон = "{
		| ""type"": ""warning"",
		| ""message"": ""обушки-воробушки2""
		|}";	

	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 200, "Предупреждение");
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку(), Эталон, "Предупреждение");

КонецПроцедуры

// @unit-test
Процедура СобытиеОшибкаСОбъектомИHTTPСервисОтвет200(Фреймворк) Экспорт

	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Ошибка, "ОбработчикиСобытий.Ошибка111.Ошибка222.Ошибка333.200"); 
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(200));

	// when
	Логирование.Ошибка( "Ошибка111.Ошибка222.Ошибка333", "обушки-воробушки3", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");
	
	// then
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Ошибка");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки3", "Ошибка");
	
	Эталон = "{
		| ""type"": ""error"",
		| ""message"": ""обушки-воробушки3""
		|}";	

	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 200, "Ошибка");
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку(), Эталон, "Ошибка");
	
КонецПроцедуры

// @unit-test
Процедура СобытиеИнформацияСОбъектомИHTTPСервисОтвет400(Фреймворк) Экспорт

	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Информация, "ОбработчикиСобытий.Информация1111.Информация2222.Информация3333.400");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(400));
	
	// when
	Логирование.Информация( "Информация1111.Информация2222.Информация3333", "обушки-воробушки", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then		
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Информация");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки", "Информация");
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 400, "Информация");
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку()), "Информация");
	
КонецПроцедуры

// @unit-test
Процедура СобытиеПредупреждениеСОбъектомИHTTPСервисОтвет400(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Предупреждение, "ОбработчикиСобытий.Предупреждение1111.Предупреждение2222.Предупреждение3333.400");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(400));
	
	// when
	Логирование.Предупреждение( "Предупреждение1111.Предупреждение2222.Предупреждение3333", "обушки-воробушки2", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then		
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Предупреждение");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки2", "Предупреждение");
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 400, "Предупреждение");
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку()), "Предупреждение");

КонецПроцедуры

// @unit-test
Процедура СобытиеОшибкаСОбъектомИHTTPСервисОтвет400(Фреймворк) Экспорт

	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Ошибка, "ОбработчикиСобытий.Ошибка1111.Ошибка2222.Ошибка3333.400"); 
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(400));

	// when
	Логирование.Ошибка( "Ошибка1111.Ошибка2222.Ошибка3333", "обушки-воробушки3", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");
	
	// then
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 1, "Ошибка");
	Фреймворк.ПроверитьРавенство(Результат[0].Комментарий, "обушки-воробушки3", "Ошибка");
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 400, "Ошибка");
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку()), "Ошибка");

КонецПроцедуры

// @unit-test
Процедура СобытиеИнформацияHTTPСервисОтветТелоОтвета200(Фреймворк) Экспорт

	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Информация, "Информация200.Информация200.Информация200.200");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(200));
	
	// when
	Логирование.Информация( "Информация200.Информация200.Информация200", "обушки-воробушки", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then		
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 200, "Информация200");
	ТелоОтвета = ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку();
	Фреймворк.ПроверитьВхождение(ТелоОтвета, "info", "Информация200");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, "обушки-воробушки", "Информация200");
	
КонецПроцедуры	

// @unit-test
Процедура СобытиеИнформацияHTTPСервисОтветТелоОтвета400(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Информация, "Информация400.Информация400.Информация400.400");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(400));
	
	// when
	Логирование.Информация( "Информация400.Информация400.Информация400", "обушки-воробушки2", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then			
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 400, "Информация400");
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку()), "Информация400");

КонецПроцедуры	

// @unit-test
Процедура СобытиеИнформацияHTTPСервисОтветТелоОтвета403(Фреймворк) Экспорт

	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Информация, "Информация403.Информация403.Информация403.403");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(403));

	// when
	Логирование.Информация( "Информация403.Информация403.Информация403", "обушки-воробушки3", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");

	// then		
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 403, "Информация403");
	ТелоОтвета = ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку();
	Фреймворк.ПроверитьВхождение(ТелоОтвета, "info", "Информация403");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, "обушки-воробушки3", "Информация403");

КонецПроцедуры	

// @unit-test
Процедура СобытиеИнформацияHTTPСервисОтветТелоОтвета423(Фреймворк) Экспорт
	
	// given
	ПараметрыОтбораЖурналаРегистрации = Новый Структура("ДатаНачала, Уровень, Событие", ТекущаяДата(), УровеньЖурналаРегистрации.Информация, "Информация423.Информация423.Информация423.423");
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( , Новый HTTPСервисОтвет(423));

	// when
	Логирование.Информация( "Информация423.Информация423.Информация423", "обушки-воробушки4", ПараметрыЛогирования );
	Тест_ОбщийМодульСервер.Пауза(2);
	Результат = Новый ТаблицаЗначений();
	ВыгрузитьЖурналРегистрации(Результат, ПараметрыОтбораЖурналаРегистрации, "Дата, ПредставлениеСобытия, ПредставлениеМетаданных, ПредставлениеДанных, Комментарий");
	
	// then		
	Фреймворк.ПроверитьРавенство(ПараметрыЛогирования.HTTPОтвет.КодСостояния, 423, "Информация423");
	ТелоОтвета = ПараметрыЛогирования.HTTPОтвет.ПолучитьТелоКакСтроку();
	Фреймворк.ПроверитьВхождение(ТелоОтвета, "info", "Информация423");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, "обушки-воробушки4", "Информация423");
	
КонецПроцедуры	

#КонецОбласти