# language: ru

@tree
@classname=ModuleExceptionPath

Функционал: GitLabServices.Tests.Тест_ЛогированиеСервер
	Как Разработчик
	Я Хочу чтобы возвращаемое значение метода совпадало с эталонным
	Чтобы я мог гарантировать работоспособность метода

@OnServer
Сценарий: ДополнительныеДанные
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.ДополнительныеДанные(Контекст());' |

@OnServer
Сценарий: ТолькоСобытиеИнформация
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.ТолькоСобытиеИнформация(Контекст());' |

@OnServer
Сценарий: ТолькоСобытиеПредупреждение
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.ТолькоСобытиеПредупреждение(Контекст());' |

@OnServer
Сценарий: ТолькоСобытиеОшибка
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.ТолькоСобытиеОшибка(Контекст());' |

@OnServer
Сценарий: СобытиеИнформацияСОбъектом
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеИнформацияСОбъектом(Контекст());' |

@OnServer
Сценарий: СобытиеПредупреждениеСОбъектом
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеПредупреждениеСОбъектом(Контекст());' |

@OnServer
Сценарий: СобытиеОшибкаСОбъектом
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеОшибкаСОбъектом(Контекст());' |

@OnServer
Сценарий: СобытиеИнформацияСОбъектомИHTTPСервисОтвет200
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеИнформацияСОбъектомИHTTPСервисОтвет200(Контекст());' |

@OnServer
Сценарий: СобытиеПредупреждениеСОбъектомИHTTPСервисОтвет200
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеПредупреждениеСОбъектомИHTTPСервисОтвет200(Контекст());' |

@OnServer
Сценарий: СобытиеОшибкаСОбъектомИHTTPСервисОтвет200
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеОшибкаСОбъектомИHTTPСервисОтвет200(Контекст());' |

@OnServer
Сценарий: СобытиеИнформацияСОбъектомИHTTPСервисОтвет400
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеИнформацияСОбъектомИHTTPСервисОтвет400(Контекст());' |

@OnServer
Сценарий: СобытиеПредупреждениеСОбъектомИHTTPСервисОтвет400
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеПредупреждениеСОбъектомИHTTPСервисОтвет400(Контекст());' |

@OnServer
Сценарий: СобытиеОшибкаСОбъектомИHTTPСервисОтвет400
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеОшибкаСОбъектомИHTTPСервисОтвет400(Контекст());' |

@OnServer
Сценарий: СобытиеИнформацияHTTPСервисОтветТелоОтвета200
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеИнформацияHTTPСервисОтветТелоОтвета200(Контекст());' |

@OnServer
Сценарий: СобытиеИнформацияHTTPСервисОтветТелоОтвета400
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеИнформацияHTTPСервисОтветТелоОтвета400(Контекст());' |

@OnServer
Сценарий: СобытиеИнформацияHTTPСервисОтветТелоОтвета403
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеИнформацияHTTPСервисОтветТелоОтвета403(Контекст());' |

@OnServer
Сценарий: СобытиеИнформацияHTTPСервисОтветТелоОтвета423
	И я выполняю код встроенного языка на сервере
	| 'Тест_ЛогированиеСервер.СобытиеИнформацияHTTPСервисОтветТелоОтвета423(Контекст());' |