﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Ожидаем;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем ПропускатьОбъектыСПрефиксомУдалить;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдра) Экспорт
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыМетаданных = ОбъектыМетаданных(ПрефиксОбъектов, ОтборПоПрефиксу);
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		Если ОбъектМетаданных.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Ложь);
		Для Каждого Элемент Из ОбъектМетаданных.Значение Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьЧтоЕстьПраваНаЧтение", 
				НаборТестов.ПараметрыТеста(Элемент.ПолноеИмя), 
				Элемент.Имя);	
		КонецЦикла;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоПрефиксу = Ложь;
	ПрефиксОбъектов = "";
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("Параметры") И Настройки.Параметры.Свойство("Префикс") Тогда
		ПрефиксОбъектов = Настройки.Параметры.Префикс;		
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки[ИмяТеста()].ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство("Параметры") И Настройки.Параметры.Свойство("ПропускатьОбъектыСПрефиксомУдалить") Тогда
		ПропускатьОбъектыСПрефиксомУдалить = Настройки.Параметры.ПропускатьОбъектыСПрефиксомУдалить;
	КонецЕсли;
		
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ИсключенияИзпроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки[ИмяТеста()].ИсключенияИзпроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьЧтоЕстьПраваНаЧтение(ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	Право = ПравоДляПроверки(ПолноеИмяМетаданных);
	
	Результат = ПроверитьЧтоЕстьПраваНаЧтениеСервер(
					ПолноеИмяМетаданных, 
					Право, 
					ПрефиксОбъектов, 
					ОтборПоПрефиксу);
	
	
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения(ПолноеИмяМетаданных, Право));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЧтоЕстьПраваНаЧтениеСервер(ПолноеИмяМетаданных, Право, ПрефиксОбъектов, ОтборПоПрефиксу)

	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);	
	ЕстьПраво = Ложь;
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		
		Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(Роль.Имя, ПрефиксОбъектов) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Метаданные.ОсновныеРоли.Содержит(Роль) Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьПраво = ПравоДоступа(Право, ОбъектМетаданных, Роль);
		Если ЕстьПраво Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено Тогда
		Результат.ТекстСообщения = СтрШаблон(НСтр("ru = 'Объект ""%1"" исключен из проверки'"), ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Если ПропускатьОбъектыСПрефиксомУдалить = Истина И СтрНайти(ВРег(ПолноеИмяМетаданных), ".УДАЛИТЬ") > 0 Тогда
		ШаблонСообшения = НСтр("ru = 'Объект ""%1"" исключен из проверки, префикс ""Удалить""'");
		Результат.ТекстСообщения = СтрШаблон(ШаблонСообшения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
		
	Возврат Результат;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСообщения(ПолноеИмяМетаданных, Право)

	ШаблонСообщения = НСтр("ru = 'Нет роли с правом ""%1"", кроме основных ролей, на объект метаданныхх ""%2""'");
	ТекстСообщения = СтрШаблон(ШаблонСообщения, Право, ПолноеИмяМетаданных);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция ОбъектыМетаданных(ПрефиксОбъектов, ОтборПоПрефиксу)
	
	ОбъектыМетаданных = Новый Структура;
		
	ОбъектыМетаданных.Вставить("ПланыОбмена", Новый Массив);
	ОбъектыМетаданных.Вставить("Константы", Новый Массив);
	ОбъектыМетаданных.Вставить("Документы", Новый Массив);
	ОбъектыМетаданных.Вставить("Справочники", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовХарактеристик", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыСчетов", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовРасчета", Новый Массив);
	ОбъектыМетаданных.Вставить("Отчеты", Новый Массив);
	ОбъектыМетаданных.Вставить("Обработки", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыСведений", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыНакопления", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыБухгалтерии", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыРасчета", Новый Массив);
	ОбъектыМетаданных.Вставить("БизнесПроцессы", Новый Массив);
	ОбъектыМетаданных.Вставить("Задачи", Новый Массив);
	ОбъектыМетаданных.Вставить("ОбщиеФормы", Новый Массив);
	ОбъектыМетаданных.Вставить("ОбщиеКоманды", Новый Массив);
	
	Для Каждого Элемент Из ОбъектыМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[Элемент.Ключ] Цикл
			Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда
				Продолжить;
			КонецЕсли;
			СтруктураЭлемента = Новый Структура;
			СтруктураЭлемента.Вставить("Имя", ОбъектМетаданных.Имя);
			СтруктураЭлемента.Вставить("ПолноеИмя", ОбъектМетаданных.ПолноеИмя());
			ОбъектыМетаданных[Элемент.Ключ].Добавить(СтруктураЭлемента);	
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОбъектыМетаданных;

КонецФункции

&НаСервере
Функция ПравоДляПроверки(ПолноеИмяМетаданных)
	
	Если СтрНайти(ПолноеИмяМетаданных, "Обработка.") > 0
	 Или СтрНайти(ПолноеИмяМетаданных, "Отчет.") > 0 Тогда
		Право = "Использование";
	ИначеЕсли СтрНайти(ПолноеИмяМетаданных, "ОбщаяФорма.") > 0
	 Или СтрНайти(ПолноеИмяМетаданных, "ОбщаяКоманда.") > 0 Тогда
		Право = "Просмотр";
	Иначе
		Право = "Чтение";
	КонецЕсли;
	
	Возврат Право;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), ВРег(Префикс)) > 0;
	
КонецФункции

&НаСервере
Функция ИмяТеста()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Истина;
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") 
		И Настройки.Свойство("Параметры") 
		И Настройки.Параметры.Свойство(ИмяТеста()) Тогда
		ВыполнятьТест = Настройки.Параметры[ИмяТеста()];	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

#КонецОбласти