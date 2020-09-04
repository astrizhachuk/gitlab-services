#Область СлужебныйПрограммныйИнтерфейс

// @unit-test
Процедура Тест_ДополнитьКоллекциюТекстомИзПотока(Фреймворк) Экспорт
	
	Поток = Новый ПотокВПамяти();
	ЗаписьТекста = Новый ЗаписьТекста(Поток);
	Значение = "Туточки текст потока";
	ЗаписьТекста.Записать(Значение);
   	ЗаписьТекста.Закрыть();

	Коллекция = Новый Структура("Ключ1", "Значение1");
	ОбщегоНазначения.ДополнитьКоллекциюТекстомИзПотока(Поток, "Ключ2", Коллекция);
   	Поток.Закрыть();

   	Фреймворк.ПроверитьРавенство( Значение, Коллекция.Ключ2 );

КонецПроцедуры





// TODO актуальные методы??

// @unit-test
Процедура Тест_МетодьПотокВКоллекциюКакJSON(Фреймворк) Экспорт
	
	Поток = Новый ПотокВПамяти();
	ЗаписьТекста = Новый ЗаписьТекста(Поток);
	ЭталонJSON = "{
				 |""Сообщение"": ""ТекстСообщения""
				 |}";
	ЗаписьТекста.Записать(ЭталонJSON);
   	ЗаписьТекста.Закрыть();

	Коллекция1 = Неопределено;
	ОбщегоНазначения.ПотокВКоллекциюКакJSON(Поток, Истина, Истина, Коллекция1);
	
	Коллекция2 = Неопределено;
	ОбщегоНазначения.ПотокВКоллекциюКакJSON(Поток, Ложь, Истина, Коллекция2);
	
	Коллекция3 = Неопределено;
	ОбщегоНазначения.ПотокВКоллекциюКакJSON(Поток, Ложь, Ложь, Коллекция3);

   	Поток.Закрыть();

   	Фреймворк.ПроверитьТип( Коллекция1, "Соответствие" );
   	Фреймворк.ПроверитьТип( Коллекция2, "Структура" );
   	Фреймворк.ПроверитьРавенство( Коллекция1.Получить("json"), ЭталонJSON );
   	Фреймворк.ПроверитьРавенство( Коллекция2.json, ЭталонJSON );
   	Фреймворк.ПроверитьЛожь( Коллекция3.Свойство("json") );
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура Пауза(Знач Ждать) Экспорт
	ОкончаниеПаузы = ТекущаяДата() + Ждать;
	Пока (Истина) Цикл
		Если ТекущаяДата() >= ОкончаниеПаузы Тогда
			Возврат;
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры

Функция КакТекст(Знач Ответ, Знач Кодировка = Неопределено) Экспорт
	
	Возврат КоннекторHTTP.КакТекст(Ответ, Кодировка);

КонецФункции

#КонецОбласти