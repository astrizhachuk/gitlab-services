// BSLLS-выкл.
#Region Internal

// @unit-test
Процедура ResponseTemplate(Фреймворк) Экспорт

	// when
	Результат = HTTPServices.ResponseTemplate();
	// then
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 2);
	Фреймворк.ПроверитьИстину(Результат.Свойство("type"));
	Фреймворк.ПроверитьИстину(Результат.Свойство("message"));
	
КонецПроцедуры

//@unit-test
Процедура ServiceDescriptionByNameServiceNotExists(Фреймворк) Экспорт

	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "фэйк";
	// when
	ОписаниеСервиса = HTTPServices.ServiceDescriptionByName(URL);
	// then
	Фреймворк.ПроверитьРавенство(ОписаниеСервиса, Неопределено);

КонецПроцедуры

//@unit-test
Процедура ServiceDescriptionByNameServiceExists(Фреймворк) Экспорт

	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "gitlab";
	// when
	ОписаниеСервиса = HTTPServices.ServiceDescriptionByName(URL);
	// then
	ОписаниеСервиса = HTTPServices.ServiceDescriptionByName("gitlab");
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.Свойство("name"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.Свойство("desc"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.Свойство("enabled"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.Свойство("templates"));
	Фреймворк.ПроверитьРавенство(ОписаниеСервиса.templates.Количество(), 2);
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].Свойство("name"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].Свойство("desc"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].Свойство("template"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].Свойство("methods"));
	Фреймворк.ПроверитьРавенство(ОписаниеСервиса.templates[0].methods.Количество(), 1);
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].methods[0].Свойство("name"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].methods[0].Свойство("desc"));
	Фреймворк.ПроверитьИстину(ОписаниеСервиса.templates[0].methods[0].Свойство("method"));

КонецПроцедуры

// @unit-test
Процедура ServiceDescriptionByURLBadURL(Фреймворк) Экспорт
	
	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "йохохо";
	// when
	Попытка
		HTTPServices.ServiceDescriptionByURL(URL);
		ВызватьИсключение НСтр("ru = 'Должна быть ошибка при вызове метода, но это не так.'");
	Исключение
		// then
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Фреймворк.ПроверитьВхождение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке),
		 							"Couldn't resolve host name");
	КонецПопытки;		

КонецПроцедуры

// @unit-test
Процедура ServiceDescriptionByURLEmptyURL(Фреймворк) Экспорт
	
	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "";
	// when
	Результат = HTTPServices.ServiceDescriptionByURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Пустой адрес");

КонецПроцедуры

// @unit-test
Процедура ServiceDescriptionByURLURLBadType(Фреймворк) Экспорт
	
	// given
	Константы.HandleRequests.Установить(Истина);
	URL = Новый Массив;
	// when
	Результат = HTTPServices.ServiceDescriptionByURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Неверный тип");

КонецПроцедуры

// @unit-test
Процедура ServiceDescriptionByURLBadServiceName(Фреймворк) Экспорт
	
	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "http://transmitter/api/hs/gitlab";
	URL = URL + "йохохо";
	// when
	Результат = HTTPServices.ServiceDescriptionByURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Ошибка в имени сервиса");

КонецПроцедуры

// @unit-test
Процедура ServiceDescriptionByURLDeserializationError(Фреймворк) Экспорт
	
	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "http://www.example.com";
	// when
	Результат = HTTPServices.ServiceDescriptionByURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Ошибка преобразования тела ответа в коллекцию");

КонецПроцедуры

// @unit-test
Процедура ServiceDescriptionByURL404NotFound(Фреймворк) Экспорт
	
	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "http://www.example.com/NotFound";
	// when
	Результат = HTTPServices.ServiceDescriptionByURL(URL);
	//then
	Фреймворк.ПроверитьТип(Результат, "Неопределено", "Страница не найдена");

КонецПроцедуры

// @unit-test
Процедура ServiceDescriptionByURL(Фреймворк) Экспорт
	
	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "http://transmitter/api/hs/gitlab";
	URL = URL + "/services";
	// when
	Результат = HTTPServices.ServiceDescriptionByURL(URL);
	// then
	Фреймворк.ПроверитьИстину(Результат.Свойство("Response"));
	Фреймворк.ПроверитьТип(Результат.Response, "Структура", "Веб-сервис не отвечает.");
	Фреймворк.ПроверитьЗаполненность(Результат.Response, "Ответ веб-сервиса не должен быть пустым.");
	Фреймворк.ПроверитьРавенство(Результат.Response.КодСостояния, 200, "Веб-сервис отвечает, но с ошибкой.");
	Фреймворк.ПроверитьРавенство(Результат.Количество(), 3);
	Фреймворк.ПроверитьИстину(Результат.Свойство("Response"));
	Фреймворк.ПроверитьИстину(Результат.Свойство("Data"));
	Фреймворк.ПроверитьИстину(Результат.Свойство("JSON"));
	Фреймворк.ПроверитьВхождение(Результат.JSON, """version""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """services""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """enabled""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """templates""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """template""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """methods""");
	Фреймворк.ПроверитьВхождение(Результат.JSON, """method""");	

КонецПроцедуры

// @unit-test:fast
Процедура ServicesGET(Фреймворк) Экспорт
	
	// given
	Константы.HandleRequests.Установить(Истина);
	URL = "http://transmitter/api/hs/gitlab";
	URL = URL + "/services";
	// when
	Результат = HTTPConnector.Get(URL);
	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 200);
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """version""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """services""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """enabled""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """templates""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """template""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """methods""");
	Фреймворк.ПроверитьВхождение(ТелоОтвета, """method""");	

КонецПроцедуры

// @unit-test:fast
Процедура WebhooksPOST(Фреймворк) Экспорт
	
	PROCESSED_REQUEST_MESSAGE = НСтр( "ru = 'Запрос с сервера GitLab обработан.';
									|en = 'The request from the GitLab server has been processed.'" );	

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	ЭталонWebHookGitLab = "/home/usr1cv8/test/request-epf-push.json";
	Текст = Новый ЧтениеТекста(ЭталонWebHookGitLab, КодировкаТекста.UTF8);
	JSON = Текст.Прочитать();

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 200);
	ТелоОтвета = TestsCommonUseServer.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьВхождение(ТелоОтвета, PROCESSED_REQUEST_MESSAGE);

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST403Forbidden(Фреймворк) Экспорт
	
	KEY_NOT_FOUND_MESSAGE = НСтр( "ru = 'Секретный ключ не найден.';
									|en = 'The Secret Key is not found.'" );
	
	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Ложь);

	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{}";
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Gitlab-Event", "Push Hook");
	Заголовки.Вставить("X-Gitlab-Token", "ФэйковыйСекретныйКлюч");
	Дополнительно = Новый Структура;
	Дополнительно.Вставить("Заголовки", Заголовки);
	Дополнительно.Вставить("Таймаут", 5);

	// when
	Результат = HTTPConnector.Post(URL, JSON, Дополнительно);
	
	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 403);
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьВхождение(ТелоОтвета, KEY_NOT_FOUND_MESSAGE);
	
КонецПроцедуры

// @unit-test
Процедура WebhooksPOST423Locked(Фреймворк) Экспорт
	
	LOADING_DISABLED_MESSAGE = НСтр( "ru = 'Загрузка из внешнего хранилища отключена.';
									|en = 'Loading of the files is disabled.'" );

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Ложь);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{}";
	
	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 423);
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьВхождение(ТелоОтвета, LOADING_DISABLED_MESSAGE);

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestXGitlabEvent(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{}";
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Gitlab-Event", "Push Hook2");
	Заголовки.Вставить("X-Gitlab-Token", "блаблаблаюниттест");
	Дополнительно = Новый Структура;
	Дополнительно.Вставить("Заголовки", Заголовки);
	Дополнительно.Вставить("Таймаут", 5);

	// when
	Результат = HTTPConnector.Post(URL, JSON, Дополнительно);

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 Push Hook2");
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 Push Hook2");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestBadURLEpf(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf3/push";
	JSON = "{}";

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 BadURLEpf");
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 BadURLEpf");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestBadURLPush(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push3";
	JSON = "{}";
	
	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 BadURLPush");
	ТелоОтвета = HTTPConnector.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 BadURLPush");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestCheckoutSHA(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
	   |  ""object_kind"": ""push"",
	   |  ""project_id"": 178,
	   |  ""project"": {
	   |    ""id"": 178,
	   |    ""name"": ""TestEpf"",
	   |    ""web_url"": ""http://git.a/a.strizhachuk/testepf"",
	   |    ""description"": """"
	   |  },
	   |  ""commits"": [
	   |    {
	   |      ""id"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
	   |      ""message"": ""Merge branch ''ttt'' into ''master''\n\nTtt\n\nSee merge request a.strizhachuk/testepf!2""
	   |    },
	   |    {
	   |      ""id"": ""bb8c1e02e420afffe601ada9f1171991d0404e68"",
	   |      ""message"": ""test\n""
	   |    },
	   |    {
	   |      ""id"": ""2fb9499926026288d1e9b9c6586338fff4ec996b"",
	   |      ""message"": ""test\n""
	   |    }
	   |  ],
	   |  ""total_commits_count"": 3
	   |  }
	   |}";

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 checkout_sha");
	ТелоОтвета = TestsCommonUseServer.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 checkout_sha");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestProject(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
		   |  ""object_kind"": ""push"",
		   |  ""checkout_sha"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |  ""project_id"": 178,
		   |  ""commits"": [
		   |    {
		   |      ""id"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |      ""message"": ""Merge branch ''ttt'' into ''master''\n\nTtt\n\nSee merge request a.strizhachuk/testepf!2""
		   |    },
		   |    {
		   |      ""id"": ""bb8c1e02e420afffe601ada9f1171991d0404e68"",
		   |      ""message"": ""test\n""
		   |    },
		   |    {
		   |      ""id"": ""2fb9499926026288d1e9b9c6586338fff4ec996b"",
		   |      ""message"": ""test\n""
		   |    }
		   |  ],
		   |  ""total_commits_count"": 3
		   |  }
		   |}";

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 project");
	ТелоОтвета = TestsCommonUseServer.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 project");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestProjectWebURL(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
		   |  ""object_kind"": ""push"",
		   |  ""checkout_sha"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |  ""project_id"": 178,
		   |  ""project"": {
		   |    ""id"": 178,
		   |    ""name"": ""TestEpf"",
		   |    ""description"": """"
		   |  },
		   |  ""commits"": [
		   |    {
		   |      ""id"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |      ""message"": ""Merge branch ''ttt'' into ''master''\n\nTtt\n\nSee merge request a.strizhachuk/testepf!2""
		   |    },
		   |    {
		   |      ""id"": ""bb8c1e02e420afffe601ada9f1171991d0404e68"",
		   |      ""message"": ""test\n""
		   |    },
		   |    {
		   |      ""id"": ""2fb9499926026288d1e9b9c6586338fff4ec996b"",
		   |      ""message"": ""test\n""
		   |    }
		   |  ],
		   |  ""total_commits_count"": 3
		   |  }
		   |}";
	
	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 project/web_url");
	ТелоОтвета = TestsCommonUseServer.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 project/web_url");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestCommits(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
		   |  ""object_kind"": ""push"",
		   |  ""checkout_sha"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |  ""project_id"": 178,
		   |  ""project"": {
		   |    ""id"": 178,
		   |    ""name"": ""TestEpf"",
		   |    ""web_url"": ""http://git.a/a.strizhachuk/testepf"",
		   |    ""description"": """"
		   |  },
		   |  ""total_commits_count"": 3
		   |  }
		   |}";
	
	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 commits");
	ТелоОтвета = TestsCommonUseServer.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 commits");

КонецПроцедуры

// @unit-test
Процедура WebhooksPOST400BadRequestCommitsId(Фреймворк) Экспорт

	// given
	УдалитьВсеОбработчикиСобытий();
	TestsWebhooksServer.ДобавитьОбработчикСобытий("ЮнитТест1", "блаблаблаюниттест");
	Константы.HandleRequests.Установить(Истина);
	
	URL = "http://transmitter/api/" + CurrentLanguage().LanguageCode + "/hs/gitlab";
	URL = URL + "/webhooks/epf/push";
	JSON = "{
		   |  ""object_kind"": ""push"",
		   |  ""checkout_sha"": ""87fc6b2782f1bcadce980cb52941e2bd90974c0f"",
		   |  ""project_id"": 178,
		   |  ""project"": {
		   |    ""id"": 178,
		   |    ""name"": ""TestEpf"",
		   |    ""web_url"": ""http://git.a/a.strizhachuk/testepf"",
		   |    ""description"": """"
		   |  },
		   |  ""commits"": [
		   |    {
		   |      ""message"": ""Merge branch ''ttt'' into ''master''\n\nTtt\n\nSee merge request a.strizhachuk/testepf!2""
		   |    },
		   |    {
		   |      ""id"": ""bb8c1e02e420afffe601ada9f1171991d0404e68"",
		   |      ""message"": ""test\n""
		   |    },
		   |    {
		   |      ""id"": ""2fb9499926026288d1e9b9c6586338fff4ec996b"",
		   |      ""message"": ""test\n""
		   |    }
		   |  ],
		   |  ""total_commits_count"": 3
		   |  }
		   |}";

	// when
	Результат = HTTPConnector.Post(URL, JSON, ДополнительныеПараметрыУспешногоЗапроса());

	// then
	Фреймворк.ПроверитьРавенство(Результат.КодСостояния, 400, "400 commits/id");
	ТелоОтвета = TestsCommonUseServer.КакТекст(Результат, КодировкаТекста.UTF8);
	Фреймворк.ПроверитьИстину(ПустаяСтрока(ТелоОтвета), "400 commits/id");

КонецПроцедуры

#EndRegion

#Region Private

Функция ДополнительныеПараметрыУспешногоЗапроса()
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Gitlab-Event", "Push Hook");
	Заголовки.Вставить("X-Gitlab-Token", "блаблаблаюниттест");
	Дополнительно = Новый Структура;
	Дополнительно.Вставить("Заголовки", Заголовки);
	Дополнительно.Вставить("Таймаут", 5);
	
	Возврат Дополнительно;
	 
КонецФункции


Процедура УдалитьВсеОбработчикиСобытий()
	
	TestsCommonUseServer.СправочникиУдалитьВсеДанные("Webhooks");

КонецПроцедуры

#EndRegion