#Область ПрограммныйИнтерфейс

// Запускает задание по обработке данных, полученных из запроса сервера GitLab, либо запускает задание по ранее
// сохраненным данным из полученных ранее запросов.
// 
// Параметры:
// 	ОбработчикСобытия - СправочникСсылка.ОбработчикиСобытий - ссылка на элемент справочника с обработчиками событий;
// 	ОбрабатываемыеДанные - Соответствие, Строка - десериализованное из JSON тело запроса или "checkout_sha" ранее
// 													сохраненного запроса;
//
// Возвращаемое значение:
// 	Неопределено, ФоновоеЗадание - созданное ФоновоеЗадание или Неопределено, если были ошибки;
//
Функция НачатьЗапускОбработкиДанных( Знач ОбработчикСобытия, Знач ОбрабатываемыеДанные ) Экспорт
	
	Var CheckoutSHA;
	Var ПараметрыЗадания;
	Var ПараметрыЛогирования;
	Var Сообщение;
	Var Результат;
	
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ОбработчикСобытия );

	Сообщение = "";
	Результат = Неопределено;
	
	Если ( ТипЗнч(ОбрабатываемыеДанные) = Тип("Строка") ) Тогда
		
		CheckoutSHA = ОбрабатываемыеДанные;
		ДанныеЗапроса = Неопределено;
	
	ИначеЕсли ( ТипЗнч(ОбрабатываемыеДанные) = Тип("Соответствие") ) Тогда
		
		CheckoutSHA = ОбрабатываемыеДанные.Получить( "checkout_sha" );
		ДанныеЗапроса = ОбрабатываемыеДанные;
		
		Если ( CheckoutSHA = Неопределено ) Тогда
			
			Сообщение = НСтр( "ru = 'В обрабатываемых данных отсутствует checkout_sha.'" );
			
		КонецЕсли;

	Иначе
		
		Сообщение = НСтр( "ru = 'Неподдерживаемый формат обрабатываемых данных.'" );
		
	КонецЕсли;
	
	Если ( НЕ ПустаяСтрока(Сообщение) ) Тогда
	
		Логирование.Ошибка( "Core.ОбработкаДанных", Сообщение, ПараметрыЛогирования );
		
		Возврат Результат;
	
	КонецЕсли;
	
	Если ( ЕстьАктивноеЗадание(CheckoutSHA) ) Тогда
		
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "фоновое задание уже запущено.", CheckoutSHA );
		Логирование.Предупреждение( "Core.ОбработкаДанных", Сообщение, ПараметрыЛогирования );
		
		Возврат Результат;
		
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив();
	ПараметрыЗадания.Добавить( ПараметрыСобытия( ОбработчикСобытия, CheckoutSHA ) );
	ПараметрыЗадания.Добавить( ДанныеЗапроса );

	Попытка
		
		Результат = ФоновыеЗадания.Выполнить( "ОбработкаДанных.ОбработатьДанные", ПараметрыЗадания, CheckoutSHA );
		
	Исключение
		
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "запуск задания обработки данных.", CheckoutSHA );
		Сообщение = Сообщение + Символы.ПС + ПодробноеПредставлениеОшибки( ИнформацияОбОшибке() );
		Логирование.Ошибка( "Core.ОбработкаДанных", Сообщение, ПараметрыЛогирования );
		
	КонецПопытки;
 
	Возврат Результат;
											
КонецФункции

#EndRegion

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбработатьДанные( Знач ПараметрыСобытия, Знач ДанныеЗапроса ) Экспорт
	
	Var ОтправляемыеДанные;
	Var ПараметрыЛогирования;
	Var Сообщение;
	
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ПараметрыСобытия.ОбработчикСобытия );

	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "обработка данных...", ПараметрыСобытия.CheckoutSHA );
	Логирование.Информация( "Core.ОбработкаДанных.Начало", Сообщение, ПараметрыЛогирования );	
	
	ОтправляемыеДанные = Неопределено;
	ПодготовитьДанные( ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные );
	
	Если ( НЕ ЗначениеЗаполнено(ДанныеЗапроса) ИЛИ НЕ ЗначениеЗаполнено(ОтправляемыеДанные) ) Тогда
		
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "нет данных для отправки.", ПараметрыСобытия.CheckoutSHA );
		Логирование.Информация( "Core.ОбработкаДанных.Окончание", Сообщение, ПараметрыЛогирования );
		
		Возврат;
		
	КонецЕсли;
	
	ОтправляемыеДанные = Маршрутизация.РаспределитьОтправляемыеДанныеПоМаршрутам( ОтправляемыеДанные, ДанныеЗапроса );		
	ОтправитьДанныеПоМаршрутам( ПараметрыСобытия, ОтправляемыеДанные );

	Логирование.Информация( "Core.ОбработкаДанных.Окончание", Сообщение, ПараметрыЛогирования );	
	
КонецПроцедуры

#EndRegion

#Region Private

Функция ПараметрыСобытия( Знач ОбработчикСобытия, Знач CheckoutSHA )
	
	Var Результат;
	
	Результат = Новый Структура();
	Результат.Вставить( "ОбработчикСобытия", ОбработчикСобытия );
	Результат.Вставить( "CheckoutSHA", CheckoutSHA );
	
	Возврат Результат;
	
КонецФункции

Функция АктивныеЗадания( Знач Ключ )
	
	Var ПараметрыОтбора;
	
	ПараметрыОтбора = Новый Структура( "Ключ, Состояние", Ключ, СостояниеФоновогоЗадания.Активно );

	Возврат ФоновыеЗадания.ПолучитьФоновыеЗадания( ПараметрыОтбора );
	
КонецФункции

Функция ЕстьАктивноеЗадание( Знач Ключ )
	
	Возврат ЗначениеЗаполнено( АктивныеЗадания(Ключ) );
	
КонецФункции

Процедура ПодготовитьДанные( Знач ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные )

	Var ОбработчикСобытия;
	Var CheckoutSHA;
	Var ПараметрыЛогирования;	
	Var Сообщение;
	
	ОбработчикСобытия = ПараметрыСобытия.ОбработчикСобытия;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;

	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ОбработчикСобытия );
	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "подготовка данных к отправке.", CheckoutSHA );
	
	Логирование.Информация( "Core.ПодготовкаДанных.Начало", Сообщение, ПараметрыЛогирования );

	Если ( ДанныеЗапроса <> Неопределено ) Тогда
		
		ОтправляемыеДанные = Gitlab.ПолучитьФайлыКОтправкеПоДаннымЗапроса( ОбработчикСобытия, ДанныеЗапроса );
		Маршрутизация.ДополнитьЗапросНастройкамиМаршрутизации(ДанныеЗапроса, ОтправляемыеДанные );
		
		СохранитьДанные( ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные );
		
	Иначе

		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "загрузка ранее сохраненных данных.", CheckoutSHA );
		Логирование.Информация( "Core.ПодготовкаДанных", Сообщение, ПараметрыЛогирования );
				
		ЗагрузитьДанные( ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные );
		
	КонецЕсли;

	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "подготовка данных к отправке.", CheckoutSHA );
	Логирование.Информация( "Core.ПодготовкаДанных.Окончание", Сообщение, ПараметрыЛогирования );
	
КонецПроцедуры

Процедура ОтправитьДанныеПоМаршрутам( Знач ПараметрыСобытия, Знач ОтправляемыеДанные )
	
	Var ОбработчикСобытия;
	Var CheckoutSHA;
	Var ПараметрыЛогирования;
	Var ПараметрыДоставки;
	Var КлючФоновогоЗадания;
	Var Сообщение;
	Var ОтправляемыхФайлов;
	Var ЗапущенныхЗаданий;
	
	ОбработчикСобытия = ПараметрыСобытия.ОбработчикСобытия;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ОбработчикСобытия );
	ПараметрыДоставки = НастройкаСервисов.ПараметрыПолучателя();
	
	ОтправляемыхФайлов = 0;
	ЗапущенныхЗаданий = 0; 
	
	Для каждого ОтправляемыйФайл Из ОтправляемыеДанные Цикл
		
		Если ( НЕ ПустаяСтрока(ОтправляемыйФайл.ОписаниеОшибки) ) Тогда
			
			Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "ошибка получения файла:", CheckoutSHA );
			Сообщение = Сообщение + Символы.ПС + ОтправляемыйФайл.ОписаниеОшибки;
			Логирование.Предупреждение( "Core.ОбработкаДанных", Сообщение, ПараметрыЛогирования );
			
			Продолжить;
			
		КонецЕсли;

		ОтправляемыхФайлов = ОтправляемыхФайлов + 1;
		
		Для Каждого Адрес Из ОтправляемыйФайл.АдресаДоставки Цикл
			
			ПараметрыДоставки.Адрес = Адрес;
			
			КлючФоновогоЗадания = CheckoutSHA + "|" + Адрес + "|" + ОтправляемыйФайл.ИмяФайла;
				
			Если ( ЕстьАктивноеЗадание(КлючФоновогоЗадания) ) Тогда
				
				Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "фоновое задание уже запущено.", CheckoutSHA );
				Сообщение = Сообщение + Символы.ПС + "Ключ задания: " + КлючФоновогоЗадания;
				Логирование.Предупреждение( "Core.ОбработкаДанных", Сообщение, ПараметрыЛогирования );
				
				Продолжить;
				
			КонецЕсли;
			
			ПараметрыЗадания = Новый Массив();
			ПараметрыЗадания.Добавить( ОтправляемыйФайл.ИмяФайла );
			ПараметрыЗадания.Добавить( ОтправляемыйФайл.ДвоичныеДанные );
			ПараметрыЗадания.Добавить( ПараметрыДоставки );
			ПараметрыЗадания.Добавить( ПараметрыСобытия );
			
			ФоновыеЗадания.Выполнить( "Получатели.ОтправитьФайл", ПараметрыЗадания, КлючФоновогоЗадания, CheckoutSHA );
															
			ЗапущенныхЗаданий = ЗапущенныхЗаданий + 1;
				
		КонецЦикла;
		
	КонецЦикла;
	
	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "отправляемых файлов: " + ОтправляемыхФайлов, CheckoutSHA );
	Логирование.Информация("Core.ОбработкаДанных", Сообщение, ПараметрыЛогирования );
	
	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( "запущенных заданий: " + ЗапущенныхЗаданий, CheckoutSHA );
	Логирование.Информация("Core.ОбработкаДанных", Сообщение, ПараметрыЛогирования );
	
КонецПроцедуры

Процедура ЛогироватьРезультатОперации( Знач ПараметрыСобытия, Знач Операция, Знач Результат = Неопределено )
	
	Var ПараметрыЛогирования;
	Var Сообщение;
	
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ПараметрыСобытия.ОбработчикСобытия );
	
	Если ( Результат = Неопределено ИЛИ ЗначениеЗаполнено(Результат) ) Тогда
		
		Сообщение = "[" + Операция +"]: операция выполнена успешно.";
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( Сообщение, ПараметрыСобытия.CheckoutSHA );
		Логирование.Информация( "Core." + Операция, Сообщение, ПараметрыЛогирования );
		
	Иначе
		
		Сообщение = "[" + Операция +"]: операция не выполнена.";
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( Сообщение, ПараметрыСобытия.CheckoutSHA );
		
		Если ( ТипЗнч(Результат) = Тип("ИнформацияОбОшибке") ) Тогда
			
			Сообщение = Сообщение + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки( Результат );
			
		КонецЕсли;
					
		Логирование.Предупреждение( "Core." + Операция, Сообщение, ПараметрыЛогирования );
			
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗагрузитьДанные( Знач ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные )
	
	Var ОбработчикСобытия;
	Var CheckoutSHA;
	
	ОбработчикСобытия = ПараметрыСобытия.ОбработчикСобытия;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;

	ДанныеЗапроса = ОбработчикиСобытий.ЗагрузитьДанныеЗапроса( ОбработчикСобытия, CheckoutSHA );
	ЛогироватьРезультатОперации( ПараметрыСобытия, "ЗагрузкаДанныхЗапросаИзБазыДанных", ДанныеЗапроса );

	ОтправляемыеДанные = ОбработчикиСобытий.ЗагрузитьВнешниеФайлы( ОбработчикСобытия, CheckoutSHA );
	ЛогироватьРезультатОперации( ПараметрыСобытия, "ЗагрузкаВнешнихФайловИзБазыДанных", ОтправляемыеДанные );
	
КонецПроцедуры

Процедура СохранитьДанныеЗапроса( Знач ПараметрыСобытия, Знач ДанныеЗапроса )
	
	Var ОбработчикСобытия;
	Var CheckoutSHA;
	Var ИнформацияОбОшибке;
	
	ОбработчикСобытия = ПараметрыСобытия.ОбработчикСобытия;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;
	
	ИнформацияОбОшибке = Неопределено;
	
	Попытка
		
		ОбработчикиСобытий.СохранитьДанныеЗапроса( ОбработчикСобытия, CheckoutSHA, ДанныеЗапроса );
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();

	КонецПопытки;
	
	ЛогироватьРезультатОперации( ПараметрыСобытия, "СохранениеДанныхЗапросаВБазуДанных", ИнформацияОбОшибке );
	
КонецПроцедуры

Процедура СохранитьВнешниеФайлы( Знач ПараметрыСобытия, Знач ОтправляемыеДанные )
	
	Var ОбработчикСобытия;
	Var CheckoutSHA;
	Var ИнформацияОбОшибке;
	
	ОбработчикСобытия = ПараметрыСобытия.ОбработчикСобытия;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;
	
	ИнформацияОбОшибке = Неопределено;
	
	Попытка
		
		ОбработчикиСобытий.СохранитьВнешниеФайлы( ОбработчикСобытия, CheckoutSHA, ОтправляемыеДанные );
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();

	КонецПопытки;
	
	ЛогироватьРезультатОперации( ПараметрыСобытия, "СохранениеВнешнихФайловВБазуДанных", ИнформацияОбОшибке );
	
КонецПроцедуры

Процедура СохранитьДанные( Знач ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные )

	СохранитьДанныеЗапроса( ПараметрыСобытия, ДанныеЗапроса );
	СохранитьВнешниеФайлы( ПараметрыСобытия, ОтправляемыеДанные );
	
КонецПроцедуры

#EndRegion