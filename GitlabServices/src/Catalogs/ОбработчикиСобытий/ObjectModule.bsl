

Процедура ПередЗаписью(Отказ)
	
	ОбработчикиСобытийПоКлючу = Справочники.ОбработчикиСобытий.НайтиПоСекретномуКлючу( ЭтотОбъект.СекретныйКлюч );
	
	Для Каждого ОбработчикСобытий Из ОбработчикиСобытийПоКлючу Цикл
		
		Если ЭтотОбъект.Ссылка = ОбработчикСобытий Тогда

			Продолжить;
			
		КонецЕсли;
		
		Отказ = Истина;
		
	КонецЦикла;

КонецПроцедуры
