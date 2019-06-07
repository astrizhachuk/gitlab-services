#Область ПрограммныйИнтерфейс

// Поиск последнего элемента справочника у которого секретный токен равен переданному в функцию значению.
// 
// Параметры:
// 	СекретныйТокен - Строка - значение секретного токена (ключа).
// Возвращаемое значение:
// 	Неопределено, СправочникСсылка.Webhooks - ссылка на элемент справочника; если не найдено, то - Неопределено. 
Функция НайтиПоСекретномуТокену(Знач СекретныйТокен) Экспорт
	
	Перем Запрос;
	Перем РезультатЗапроса;
	Перем Результат;
	
	Результат = Неопределено;
	
	Если ТипЗнч(СекретныйТокен) <> Тип("Строка") ИЛИ ПустаяСтрока(СекретныйТокен) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СекретныйТокен", СекретныйТокен);
	Запрос.Текст = 	"ВЫБРАТЬ ПЕРВЫЕ 1
					|	Webhooks.Ссылка КАК Ссылка
					|ИЗ
					|	Справочник.Webhooks КАК Webhooks
					|ГДЕ
					|	НЕ Webhooks.ПометкаУдаления
					|	И Webhooks.СекретныйТокен = &СекретныйТокен
					|УПОРЯДОЧИТЬ ПО
					|	Webhooks.Код УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Результат = Выборка.Ссылка;
	
	Возврат Результат;
	
КонецФункции

// Загружает историю событий из журнала регистрации в табличную часть элемента справочника.
// Записи в журнале отбираются по параметрам отбора (См. глобальный контекст ЗагрузитьИсториюСобытийВходящихПараметров).
// Данные дописываются (!), т.е. проверок на дубли не осуществляется.
// 
// Параметры:
// 	Ссылка - СправочникСсылка.Webhooks - ссылка на элемент справочника, куда необхоимо загрузить данные;
// 	ПараметрыОтбора - Структура - (См. глобальный контекст ЗагрузитьИсториюСобытийВходящихПараметров);
// 	ДобавленоЗаписей - Число - возвращаемый параметр, количество добавленных записей;
Процедура ЗагрузитьИсториюСобытий(Знач Ссылка, Знач ПараметрыОтбора, ДобавленоЗаписей) Экспорт
	
	Перем ДанныеЖурналаРегистрации;
	
	ЗагрузитьИсториюСобытийВходящихПараметров(Ссылка, ПараметрыОтбора);
	
	ДанныеЖурналаРегистрации = Новый ТаблицаЗначений;
	ВыгрузитьЖурналРегистрации(ДанныеЖурналаРегистрации, ПараметрыОтбора);
	
	Если ДанныеЖурналаРегистрации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	// Заблокировать() не используем, так как операция загрузки истории
	// в приоритете над остальными интерактивными действиями пользователя.	
	Webhook = Ссылка.ПолучитьОбъект();
	
	ДобавленоЗаписей = 0;
	Webhook.ИсторияСобытий.Очистить();
	Для каждого ЗаписьЖурналаРегистрации Из ДанныеЖурналаРегистрации Цикл
		
		Событие = СервисыGitLab.ПреобразоватьСтрокуСобытияВСтруктуру(ЗаписьЖурналаРегистрации.Событие);

		Если Событие.Объект <> "Webhooks" Тогда
			Продолжить;
		КонецЕсли;

		НоваяЗаписьИстории = Webhook.ИсторияСобытий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗаписьИстории, ЗаписьЖурналаРегистрации);
		ЗаполнитьЗначенияСвойств(НоваяЗаписьИстории, Событие);
		НоваяЗаписьИстории.Уровень = Перечисления.УровеньЖурналаРегистрации[Строка(ЗаписьЖурналаРегистрации.Уровень)];
		
		ДобавленоЗаписей = ДобавленоЗаписей + 1;

	КонецЦикла;
	
	Попытка
		Webhook.Записать();
	Исключение
		СервисыGitLab.ЗалогироватьОшибку("System", "ИсторияСобытий", Ссылка, НСтр("ru = 'Ошибка переноса истории событий из журнала регистрации.'"));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Ручной запуск отправки обработанных данных в фоне.
// 
// Параметры:
// 	Ссылка - СправочникСсылка.Webhooks - ссылка на элемент справочника, для которого запускается обработка данных;
// 	КлючЗапроса - РегистрСведенийКлючЗаписи.Webhooks - ключ записи на данные, которые должны быть отправлены;
Процедура ЗапуститьОбработкуДанныхВручную(Знач Ссылка, Знач КлючЗапроса) Экспорт
	
	Перем ДанныеТелаЗапроса;
	
	ДанныеТелаЗапроса = РегистрыСведений.Webhooks.ПолучитьДанныеТелаЗапроса(КлючЗапроса);
	СервисыGitLab.ЗапуститьОбработкуДанныхВФоне(Ссылка, ДанныеТелаЗапроса, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиПроведения

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗагрузитьИсториюСобытийВходящихПараметров(Знач Ссылка, Знач ПараметрыОтбора)
													
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"Справочники.Webhooks",
		"Ссылка",
		Ссылка,
		Тип("СправочникСсылка.Webhooks"));
		
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"Справочники.Webhooks",
		"ПараметрыОтбора",
		ПараметрыОтбора,
		Тип("Структура"));
	
КонецПроцедуры

#КонецОбласти