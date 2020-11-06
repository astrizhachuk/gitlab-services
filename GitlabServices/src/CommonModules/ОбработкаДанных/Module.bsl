#Region Public

// Запускает задание по обработке данных, полученных из запроса сервера GitLab, либо запускает задание по ранее
// сохраненным данным из полученных ранее запросов.
// 
// Параметры:
// 	ОбработчикСобытия - СправочникСсылка.ОбработчикиСобытий - ссылка на элемент справочника с обработчиками событий;
// 	ОбрабатываемыеДанные - Соответствие, Строка - десериализованное из JSON тело запроса или "checkout_sha" ранее
// 													сохраненного запроса;
//
// Returns:
// 	Неопределено, ФоновоеЗадание - созданное ФоновоеЗадание или Неопределено, если были ошибки;
//
Функция НачатьЗапускОбработкиДанных( Знач ОбработчикСобытия, Знач ОбрабатываемыеДанные ) Экспорт
	
	Var CheckoutSHA;
	Var ПараметрыЗадания;
	Var ПараметрыЛогирования;
	Var Сообщение;
	Var Результат;
	
	EVENT_MESSAGE = НСтр( "ru = 'Core.ОбработкаДанных';en = 'Core.DataProcessing'" );
	CHECKOUT_SHA_MISSING_MESSAGE = НСтр( "ru = 'отсутствует ""checkout_sha"".';
										|en = '""checkout_sha"" is missing.'" );
	UNSUPPORTED_FORMAT_MESSAGE = НСтр( "ru = 'неподдерживаемый формат данных.';en = 'unsupported data format.'" );
	
	JOB_WAS_STARTED_MESSAGE = НСтр( "ru = 'фоновое задание уже запущено.';en = 'background job is already running.'" );
	JOB_RUNNING_ERROR_MESSAGE = НСтр( "ru = 'ошибка запуска задания обработки данных:';
										|en = 'an error occurred while starting the job:'" );									
	
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
			
			Сообщение = CHECKOUT_SHA_MISSING_MESSAGE;
			
		КонецЕсли;

	Иначе
		
		Сообщение = UNSUPPORTED_FORMAT_MESSAGE;
		
	КонецЕсли;
	
	Если ( НЕ ПустаяСтрока(Сообщение) ) Тогда
	
		Логирование.Ошибка( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
		
		Возврат Результат;
	
	КонецЕсли;
	
	Если ( ЕстьАктивноеЗадание(CheckoutSHA) ) Тогда
		
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( JOB_WAS_STARTED_MESSAGE, CheckoutSHA );
		Логирование.Предупреждение( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
		
		Возврат Результат;
		
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив();
	ПараметрыЗадания.Добавить( ПараметрыСобытия( ОбработчикСобытия, CheckoutSHA ) );
	ПараметрыЗадания.Добавить( ДанныеЗапроса );

	Попытка
		
		Результат = ФоновыеЗадания.Выполнить( "ОбработкаДанных.ОбработатьДанные", ПараметрыЗадания, CheckoutSHA );
		
	Исключение
		
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( JOB_RUNNING_ERROR_MESSAGE, CheckoutSHA );
		Сообщение = Сообщение + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки( ИнформацияОбОшибке() );
		Логирование.Ошибка( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
		
	КонецПопытки;
 
	Возврат Результат;
											
КонецФункции

#EndRegion

#Region Internal

Процедура ОбработатьДанные( Знач ПараметрыСобытия, Знач ДанныеЗапроса ) Экспорт
	
	Var ОтправляемыеДанные;
	Var ПараметрыЛогирования;
	Var Сообщение;
	
	EVENT_MESSAGE_BEGIN = НСтр( "ru = 'Core.ОбработкаДанных.Начало';en = 'Core.DataProcessing.Begin'" );
	EVENT_MESSAGE_END = НСтр( "ru = 'Core.ОбработкаДанных.Окончание';en = 'Core.DataProcessing.End'" );
	
	DATA_PROCESSING_MESSAGE = НСтр( "ru = 'обработка данных...';en = 'data processing...'" );
	NO_DATA_MESSAGE = НСтр( "ru = 'нет данных для отправки.';en = 'no data to send.'" );
	
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ПараметрыСобытия.Webhook );

	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( DATA_PROCESSING_MESSAGE, ПараметрыСобытия.CheckoutSHA );
	Логирование.Информация( EVENT_MESSAGE_BEGIN, Сообщение, ПараметрыЛогирования );	
	
	ОтправляемыеДанные = Неопределено;
	ПодготовитьДанные( ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные );
	
	Если ( НЕ ЗначениеЗаполнено(ДанныеЗапроса) ИЛИ НЕ ЗначениеЗаполнено(ОтправляемыеДанные) ) Тогда

		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( NO_DATA_MESSAGE, ПараметрыСобытия.CheckoutSHA );
		Логирование.Информация( EVENT_MESSAGE_END, Сообщение, ПараметрыЛогирования );
		
		Возврат;
		
	КонецЕсли;
	
	ОтправляемыеДанные = Маршрутизация.РаспределитьОтправляемыеДанныеПоМаршрутам( ОтправляемыеДанные, ДанныеЗапроса );		
	ОтправитьДанныеПоМаршрутам( ПараметрыСобытия, ОтправляемыеДанные );

	Логирование.Информация( EVENT_MESSAGE_END, Сообщение, ПараметрыЛогирования );	
	
КонецПроцедуры

#EndRegion

#Region Private

Функция ПараметрыСобытия( Знач ОбработчикСобытия, Знач CheckoutSHA )
	
	Var Результат;
	
	Результат = Новый Структура();
	Результат.Вставить( "Webhook", ОбработчикСобытия );
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
	
	EVENT_MESSAGE_BEGIN = НСтр( "ru = 'Core.ПодготовкаДанных.Начало';en = 'Core.DataPreparation.Begin'" );
	EVENT_MESSAGE = НСтр( "ru = 'Core.ПодготовкаДанных';en = 'Core.DataPreparation'" );
	EVENT_MESSAGE_END = НСтр( "ru = 'Core.ПодготовкаДанных.Окончание';en = 'Core.DataPreparation.End'" );
	
	PREPARING_DATA_MESSAGE = НСтр( "ru = 'подготовка данных к отправке.';en = 'preparing data for sending.'" );
	LOADING_DATA_MESSAGE = НСтр( "ru = 'загрузка ранее сохраненных данных.';en = 'loading previously saved data.'" );
	
	ОбработчикСобытия = ПараметрыСобытия.Webhook;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;

	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ОбработчикСобытия );
	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( PREPARING_DATA_MESSAGE, CheckoutSHA );
	Логирование.Информация( EVENT_MESSAGE_BEGIN, Сообщение, ПараметрыЛогирования );

	Если ( ДанныеЗапроса <> Неопределено ) Тогда
		
		ОтправляемыеДанные = GitLab.ПолучитьФайлыКОтправкеПоДаннымЗапроса( ОбработчикСобытия, ДанныеЗапроса );
		Маршрутизация.ДополнитьЗапросНастройкамиМаршрутизации(ДанныеЗапроса, ОтправляемыеДанные );
		
		СохранитьДанные( ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные );
		
	Иначе
		
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( LOADING_DATA_MESSAGE, CheckoutSHA );
		Логирование.Информация( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
				
		ЗагрузитьДанные( ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные );
		
	КонецЕсли;

	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( PREPARING_DATA_MESSAGE, CheckoutSHA );
	Логирование.Информация( EVENT_MESSAGE_END, Сообщение, ПараметрыЛогирования );
	
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
	
	EVENT_MESSAGE = НСтр( "ru = 'Core.ОбработкаДанных';en = 'Core.DataProcessing'" );
	GET_FILE_ERROR_MESSAGE = НСтр( "ru = 'ошибка получения файла:';en = 'failed to get the file:'" );
	JOB_WAS_STARTED_MESSAGE = НСтр( "ru = 'фоновое задание уже запущено.';en = 'background job is already running.'" );
	KEY_MESSAGE = НСтр( "ru = 'Ключ: ';en = 'Key: '" );
	FILES_SENT_MESSAGE = НСтр( "ru = 'отправляемых файлов: ';en = 'files sent: '" );
	RUNNING_JOBS_MESSAGE = НСтр( "ru = 'запущенных заданий: ';en = 'running jobs: '" );
	
	ОбработчикСобытия = ПараметрыСобытия.Webhook;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ОбработчикСобытия );
	ПараметрыДоставки = Receivers.ConnectionParams();
	
	ОтправляемыхФайлов = 0;
	ЗапущенныхЗаданий = 0; 
	
	Для каждого ОтправляемыйФайл Из ОтправляемыеДанные Цикл
		
		Если ( НЕ ПустаяСтрока(ОтправляемыйФайл.ErrorInfo) ) Тогда
			
			Сообщение = Логирование.ДополнитьСообщениеПрефиксом( GET_FILE_ERROR_MESSAGE, CheckoutSHA );
			Сообщение = Сообщение + Символы.ПС + ОтправляемыйФайл.ErrorInfo;
			Логирование.Предупреждение( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
			
			Продолжить;
			
		КонецЕсли;

		ОтправляемыхФайлов = ОтправляемыхФайлов + 1;
		
		Для Каждого Адрес Из ОтправляемыйФайл.АдресаДоставки Цикл
			
			ПараметрыДоставки.URL = Адрес;
			
			КлючФоновогоЗадания = CheckoutSHA + "|" + Адрес + "|" + ОтправляемыйФайл.FileName;
				
			Если ( ЕстьАктивноеЗадание(КлючФоновогоЗадания) ) Тогда
				
				Сообщение = Логирование.ДополнитьСообщениеПрефиксом( JOB_WAS_STARTED_MESSAGE, CheckoutSHA );
				Сообщение = Сообщение + Символы.ПС + KEY_MESSAGE + КлючФоновогоЗадания;
				Логирование.Предупреждение( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
				
				Продолжить;
				
			КонецЕсли;
			
			ПараметрыЗадания = Новый Массив();
			ПараметрыЗадания.Добавить( ОтправляемыйФайл.FileName );
			ПараметрыЗадания.Добавить( ОтправляемыйФайл.BinaryData );
			ПараметрыЗадания.Добавить( ПараметрыДоставки );
			ПараметрыЗадания.Добавить( ПараметрыСобытия );
			
			ФоновыеЗадания.Выполнить( "Receivers.SendFile", ПараметрыЗадания, КлючФоновогоЗадания, CheckoutSHA );
															
			ЗапущенныхЗаданий = ЗапущенныхЗаданий + 1;
				
		КонецЦикла;
		
	КонецЦикла;
	
	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( FILES_SENT_MESSAGE + ОтправляемыхФайлов, CheckoutSHA );
	Логирование.Информация( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
	
	Сообщение = Логирование.ДополнитьСообщениеПрефиксом( RUNNING_JOBS_MESSAGE + ЗапущенныхЗаданий, CheckoutSHA );
	Логирование.Информация( EVENT_MESSAGE, Сообщение, ПараметрыЛогирования );
	
КонецПроцедуры

Процедура ЛогироватьРезультатОперации( Знач ПараметрыСобытия, Знач Action, Знач Результат = Неопределено )
	
	Var ПараметрыЛогирования;
	Var Сообщение;
	
	EVENT_MESSAGE = НСтр( "ru = 'Core';en = 'Core'" );
	OPERATION_SUCCEEDED_MESSAGE = НСтр( "ru = 'операция выполнена успешно.';en = 'the operation was successful.'" );
	OPERATION_FAILED_MESSAGE = НСтр( "ru = 'операция не выполнена.';en = 'operation failed.'" );
	
	ПараметрыЛогирования = Логирование.ДополнительныеПараметры( ПараметрыСобытия.Webhook );
	
	Если ( Результат = Неопределено ИЛИ ЗначениеЗаполнено(Результат) ) Тогда
		
		Сообщение = "[" + Action + "]: " + OPERATION_SUCCEEDED_MESSAGE;
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( Сообщение, ПараметрыСобытия.CheckoutSHA );
		Логирование.Информация( "Core." + Action, Сообщение, ПараметрыЛогирования );
		
	Иначе

		Сообщение = "[" + Action + "]: " + OPERATION_FAILED_MESSAGE;		
		Сообщение = Логирование.ДополнитьСообщениеПрефиксом( Сообщение, ПараметрыСобытия.CheckoutSHA );
		
		Если ( ТипЗнч(Результат) = Тип("ИнформацияОбОшибке") ) Тогда
			
			Сообщение = Сообщение + Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки( Результат );
			
		КонецЕсли;
					
		Логирование.Предупреждение( EVENT_MESSAGE + "." + Action, Сообщение, ПараметрыЛогирования );
			
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗагрузитьДанные( Знач ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные )
	
	Var ОбработчикСобытия;
	Var CheckoutSHA;
	
	LOAD_QUERY_MESSAGE = НСтр( "ru = 'ЗагрузкаЗапросаИзБазыДанных';en = 'LoadingRequestFromDatabase'" );
	LOAD_FILES_MESSAGE = НСтр( "ru = 'ЗагрузкаВнешнихФайловИзБазыДанных';en = 'LoadingFilesFromDatabase'" );
	
	ОбработчикСобытия = ПараметрыСобытия.Webhook;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;

	ДанныеЗапроса = ОбработчикиСобытий.ЗагрузитьДанныеЗапроса( ОбработчикСобытия, CheckoutSHA );
	ЛогироватьРезультатОперации( ПараметрыСобытия, LOAD_QUERY_MESSAGE, ДанныеЗапроса );

	ОтправляемыеДанные = ОбработчикиСобытий.ЗагрузитьВнешниеФайлы( ОбработчикСобытия, CheckoutSHA );
	ЛогироватьРезультатОперации( ПараметрыСобытия, LOAD_FILES_MESSAGE, ОтправляемыеДанные );
	
КонецПроцедуры

Процедура СохранитьДанныеЗапроса( Знач ПараметрыСобытия, Знач ДанныеЗапроса )
	
	Var ОбработчикСобытия;
	Var CheckoutSHA;
	Var ИнформацияОбОшибке;
	
	SAVE_QUERY_MESSAGE = НСтр( "ru = 'СохранениеЗапросаВБазуДанных';en = 'SaveRequestToDatabase'" );
	
	ОбработчикСобытия = ПараметрыСобытия.Webhook;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;
	
	ИнформацияОбОшибке = Неопределено;
	
	Попытка
		
		ОбработчикиСобытий.СохранитьДанныеЗапроса( ОбработчикСобытия, CheckoutSHA, ДанныеЗапроса );
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();

	КонецПопытки;
	
	ЛогироватьРезультатОперации( ПараметрыСобытия, SAVE_QUERY_MESSAGE, ИнформацияОбОшибке );
	
КонецПроцедуры

Процедура СохранитьВнешниеФайлы( Знач ПараметрыСобытия, Знач ОтправляемыеДанные )
	
	Var ОбработчикСобытия;
	Var CheckoutSHA;
	Var ИнформацияОбОшибке;
	
	SAVE_FILES_MESSAGE = НСтр( "ru = 'СохранениеВнешнихФайловВБазуДанных';en = 'SaveFilesToDatabase'" );
	
	ОбработчикСобытия = ПараметрыСобытия.Webhook;
	CheckoutSHA = ПараметрыСобытия.CheckoutSHA;
	
	ИнформацияОбОшибке = Неопределено;
	
	Попытка
		
		ОбработчикиСобытий.СохранитьВнешниеФайлы( ОбработчикСобытия, CheckoutSHA, ОтправляемыеДанные );
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();

	КонецПопытки;
	
	ЛогироватьРезультатОперации( ПараметрыСобытия, SAVE_FILES_MESSAGE, ИнформацияОбОшибке );
	
КонецПроцедуры

Процедура СохранитьДанные( Знач ПараметрыСобытия, ДанныеЗапроса, ОтправляемыеДанные )

	СохранитьДанныеЗапроса( ПараметрыСобытия, ДанныеЗапроса );
	СохранитьВнешниеФайлы( ПараметрыСобытия, ОтправляемыеДанные );
	
КонецПроцедуры

#EndRegion
