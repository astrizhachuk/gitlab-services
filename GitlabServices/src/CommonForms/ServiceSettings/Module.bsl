#Region FormEventHandlers

&НаСервере
Процедура ПриСозданииНаСервере( Отказ, СтандартнаяОбработка )
	
	Var Настройки;
	
	Настройки = НастройкаСервисов.ТекущиеНастройки();
	ЗаполнитьЗначенияСвойств( ЭтотОбъект, Настройки );

КонецПроцедуры

#EndRegion

#Region FormCommandsEventHandlers

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть( Команда )
	
	Если ( ЗаписатьДанныеФормы() ) Тогда
		
		Закрыть();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура TestConnections( Команда )
	
	ОткрытьФорму( "ОбщаяФорма.TestConnections", , , , , , , РежимОткрытияОкнаФормы.Независимый );

КонецПроцедуры

#EndRegion

#Region Private

&НаКлиенте
Функция ЗаписатьДанныеФормы()
	
	Var Результат;

	Результат = Ложь;
	
	Если ( ПроверитьЗаполнение() ) Тогда
		
		ЗаписатьНаСервере();
		ОбновитьИнтерфейс();
		
		Результат = Истина;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаписатьНаСервере()
	
	УстановитьПривилегированныйРежим( Истина );
	
	Константы.ОбрабатыватьЗапросыВнешнегоХранилища.Установить( ЭтотОбъект.ОбрабатыватьЗапросыВнешнегоХранилища );
	Константы.GitLabUserPrivateToken.Установить( ЭтотОбъект.GitLabUserPrivateToken );
	Константы.ИмяФайлаНастроекМаршрутизации.Установить( ЭтотОбъект.ИмяФайлаНастроекМаршрутизации );
	Константы.AccessTokenReceiver.Установить( ЭтотОбъект.AccessTokenReceiver );
	Константы.ТаймаутGitLab.Установить( ЭтотОбъект.ТаймаутGitLab );
	Константы.ТаймаутДоставкиФайла.Установить( ЭтотОбъект.ТаймаутДоставкиФайла );
	
	УстановитьПривилегированныйРежим( Ложь );
	
КонецПроцедуры

#EndRegion
