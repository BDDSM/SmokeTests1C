﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Ожидаем;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем КонфигурацияПоставщика;

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
		
	Если Не ЗначениеЗаполнено(КонфигурацияПоставщика) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОбъектовМетаданных = СтруктураОбъектовМетаданных(КонфигурацияПоставщика);
	
	Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураОбъектовМетаданных Цикл
		Если ЭлементСтруктурыОбъектовМетаданных.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		ИмяТеста = ЭлементСтруктурыОбъектовМетаданных.Ключ;
		МассивОбъектовМетаданных = ЭлементСтруктурыОбъектовМетаданных.Значение;
		НаборТестов.Добавить(
			"ТестДолжен_ПроверитьОбъектМетаданныхКонфигурацииПоставщика", 
			НаборТестов.ПараметрыТеста(МассивОбъектовМетаданных), 
			СтрШаблон("%1 [%2]", ИмяТеста, МассивОбъектовМетаданных.Количество()));	
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(мКонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = мКонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
				
	Если Настройки.Свойство("Параметры") И Настройки.Параметры.Свойство("КонфигурацияПоставщика") Тогда
		ПрочитатьФайлКонфигурацииПоставщика(мКонтекстЯдра, Настройки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлКонфигурацииПоставщика(мКонтекстЯдра, Настройки)
	
	#Если Не ВебКлиент Тогда
	ПутьФайлаКонфигурацииПоставщика = Настройки.Параметры.КонфигурацияПоставщика;
	ПутьФайлаКонфигурацииПоставщика = ОбработатьОтносительныйПуть(ПутьФайлаКонфигурацииПоставщика, мКонтекстЯдра);
		
	Файл = Новый Файл(ПутьФайлаКонфигурацииПоставщика);
	Если Не Файл.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	ЧтениеJson = Новый ЧтениеJSON;
	ЧтениеJson.ОткрытьФайл(ПутьФайлаКонфигурацииПоставщика);	
	КонфигурацияПоставщика = ПрочитатьJSON(ЧтениеJson);
	ЧтениеJson.Закрыть();
		
	Файл = Неопределено;
	#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьОбъектМетаданныхКонфигурацииПоставщика(МассивОбъектовМетаданных) Экспорт
	
	Результат = ПроверитьОбъектМетаданныхКонфигурацииПоставщика(МассивОбъектовМетаданных);	
	Утверждения.Проверить(Результат = "", ТекстСообщения(Результат));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьОбъектМетаданныхКонфигурацииПоставщика(МассивОбъектовМетаданных)

	Результат = "";
	
	Для Каждого ОбъектМетаданных Из МассивОбъектовМетаданных Цикл
		Если Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных.ПолноеИмя) = Неопределено Тогда		
			Разделитель = ?(ЗначениеЗаполнено(Результат), Символы.ПС, "");
			Результат = СтрШаблон("%1%2%3", Результат, Разделитель, ОбъектМетаданных.ПолноеИмя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСообщения(Результат)

	ШаблонСообщения = НСтр("ru = 'Не удалось найти объекты конфигурации поставщика: %1%2'");
	ТекстСообщения = СтрШаблон(ШаблонСообщения, Символы.ПС, Результат);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция СтруктураОбъектовМетаданных(КонфигурацияПоставщика)
	
	СоответствиеИменОбъектовМетаданных = СоответствиеИменОбъектовМетаданных();
	СтруктураОбъектовМетаданных = Новый Структура;
	
	Для Каждого КоллекцияОбъектовМетаданных Из КонфигурацияПоставщика Цикл
		
		ИмяКоллекции = СоответствиеИменОбъектовМетаданных.Получить(КоллекцияОбъектовМетаданных.Ключ);
		
		СтруктураОбъектовМетаданных.Вставить(КоллекцияОбъектовМетаданных.Ключ, Новый Массив);
		
		Для Каждого ОбъектаМетаданных Из КоллекцияОбъектовМетаданных.Значение Цикл
			
			ИмяОбъектаМетаданных = ИмяОбъектаМетаданных(ОбъектаМетаданных);
			
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				СтруктураОбъектовМетаданных[КоллекцияОбъектовМетаданных.Ключ], 
				ИмяОбъектаМетаданных, 
				СтрШаблон("%1.%2", ИмяКоллекции, ИмяОбъектаМетаданных));

		КонецЦикла;
			
	КонецЦикла;
		
	Возврат СтруктураОбъектовМетаданных;

КонецФункции 

&НаСервереБезКонтекста
Функция СоответствиеИменОбъектовМетаданных()
	
	СоответствиеИменОбъектовМетаданных = Новый Соответствие;
	
	СоответствиеИменОбъектовМетаданных.Вставить("Подсистемы", "Подсистема");    
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеМодули", "ОбщийМодуль");
	СоответствиеИменОбъектовМетаданных.Вставить("ПараметрыСеанса", "ПараметрСеанса");
	СоответствиеИменОбъектовМетаданных.Вставить("Роли", "Роль");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеРеквизиты", "ОбщиеРеквизит");
	СоответствиеИменОбъектовМетаданных.Вставить("ПланыОбмена", "ПланОбмена");
	СоответствиеИменОбъектовМетаданных.Вставить("КритерииОтбора", "КритерийОтбора");
	СоответствиеИменОбъектовМетаданных.Вставить("ПодпискиНаСобытия", "ПодпискаНаСобытие");
	СоответствиеИменОбъектовМетаданных.Вставить("РегламентныеЗадания", "РегламентноеЗадание");
	СоответствиеИменОбъектовМетаданных.Вставить("ФункциональныеОпции", "ФункциональнаяОпция");	
	СоответствиеИменОбъектовМетаданных.Вставить("ПараметрыФункциональныхОпций", "ПараметрФункциональныхОпций");
	СоответствиеИменОбъектовМетаданных.Вставить("ОпределяемыеТипы", "ОпределяемыйТип");
	СоответствиеИменОбъектовМетаданных.Вставить("ХранилищаНастроек", "ХранилищеНастроек");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеФормы", "ОбщаяФорма");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеКоманды", "ОбщаяКоманда");
	СоответствиеИменОбъектовМетаданных.Вставить("ГруппыКоманд", "ГруппаКоманд");
	СоответствиеИменОбъектовМетаданных.Вставить("Интерфейсы", "Интерфейс");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеМакеты", "ОбщийМакет");
	СоответствиеИменОбъектовМетаданных.Вставить("ОбщиеКартинки", "ОбщаяКартинка");
	СоответствиеИменОбъектовМетаданных.Вставить("ПакетыXDTO", "ПакетXDTO");
	СоответствиеИменОбъектовМетаданных.Вставить("WebСервисы", "WebСервис");
	СоответствиеИменОбъектовМетаданных.Вставить("HTTPСервисы", "HTTPСервис");  
	СоответствиеИменОбъектовМетаданных.Вставить("WSСсылки", "WSСсылка");
	СоответствиеИменОбъектовМетаданных.Вставить("ЭлементыСтиля", "ЭлементСтиля");
	СоответствиеИменОбъектовМетаданных.Вставить("Стили", "Стиль");
	СоответствиеИменОбъектовМетаданных.Вставить("Языки", "Язык");    
	СоответствиеИменОбъектовМетаданных.Вставить("Константы", "Константа");
	СоответствиеИменОбъектовМетаданных.Вставить("Справочники", "Справочник");
	СоответствиеИменОбъектовМетаданных.Вставить("Документы", "Документ");
	СоответствиеИменОбъектовМетаданных.Вставить("ЖурналыДокументов", "ЖурналДокументов");
	СоответствиеИменОбъектовМетаданных.Вставить("Перечисления", "Перечисление");
	СоответствиеИменОбъектовМетаданных.Вставить("Отчеты", "Отчет");
	СоответствиеИменОбъектовМетаданных.Вставить("Обработки", "Обработка");
	СоответствиеИменОбъектовМетаданных.Вставить("ПланыВидовХарактеристик", "ПланВидовХарактеристик");
	СоответствиеИменОбъектовМетаданных.Вставить("ПланыСчетов", "ПланСчетов");
	СоответствиеИменОбъектовМетаданных.Вставить("ПланыВидовРасчета", "ПланВидовРасчета");
	СоответствиеИменОбъектовМетаданных.Вставить("РегистрыСведений", "РегистрСведений");
	СоответствиеИменОбъектовМетаданных.Вставить("РегистрыНакопления", "РегистрНакопления");
	СоответствиеИменОбъектовМетаданных.Вставить("РегистрыБухгалтерии", "РегистрБухгалтерии");
	СоответствиеИменОбъектовМетаданных.Вставить("РегистрыРасчета", "РегистрРасчета");
	СоответствиеИменОбъектовМетаданных.Вставить("БизнесПроцессы", "БизнесПроцесс");
	СоответствиеИменОбъектовМетаданных.Вставить("Задачи", "Задача");
	СоответствиеИменОбъектовМетаданных.Вставить("ВнешниеИсточникиДанных", "ВнешнийИсточникиДанных");
	
	Возврат СоответствиеИменОбъектовМетаданных;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяОбъектаМетаданных(ОбъектаМетаданных)
	
	МассивСтрок = СтрРазделить(ОбъектаМетаданных, ".");
	СоответствиеИменСвойств = СоответствиеИменСвойств();
	ШагОбходаСтрок = 2;
	ИндексСтроки = 1;
	
	Пока ИндексСтроки <= МассивСтрок.Количество() - 1 Цикл
		ЗначениеСтроки = МассивСтрок.Получить(ИндексСтроки);
		Если СоответствиеИменСвойств.Получить(ЗначениеСтроки) <> Неопределено Тогда
			МассивСтрок.Установить(ИндексСтроки, СоответствиеИменСвойств.Получить(ЗначениеСтроки));
		КонецЕсли;
		ИндексСтроки = ИндексСтроки + ШагОбходаСтрок;
	КонецЦикла;
	
	ИмяОбъектаМетаданных = СтрСоединить(МассивСтрок, ".");	
	
	Возврат ИмяОбъектаМетаданных;
	
КонецФункции

&НаСервереБезКонтекста
Функция СоответствиеИменСвойств()
	
	СоответствиеИменСвойств = Новый Соответствие;
	
	СоответствиеИменСвойств.Вставить("Подсистемы", "Подсистема");
	СоответствиеИменСвойств.Вставить("Реквизиты", "Реквизит");
	СоответствиеИменСвойств.Вставить("Формы", "Форма");
	СоответствиеИменСвойств.Вставить("ТабличныеЧасти", "ТабличнаяЧасть");
	СоответствиеИменСвойств.Вставить("Макеты", "Макет");
	СоответствиеИменСвойств.Вставить("Команды", "Команда");
	СоответствиеИменСвойств.Вставить("ЗначенияПеречисления", "ЗначениеПеречисления");
	СоответствиеИменСвойств.Вставить("Измерения", "Измерение");
	СоответствиеИменСвойств.Вставить("Ресурсы", "Ресурс");
	СоответствиеИменСвойств.Вставить("РеквизитыАдресации", "РеквизитАдресации");
	СоответствиеИменСвойств.Вставить("Графы", "Графа");
	СоответствиеИменСвойств.Вставить("Операции", "Операция");
	СоответствиеИменСвойств.Вставить("Параметры", "Параметр");
		
	Возврат СоответствиеИменСвойств;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(Коллекция, Имя, ПолноеИмя)

	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("Имя", Имя);
	СтруктураЭлемента.Вставить("ПолноеИмя", ПолноеИмя);
	Коллекция.Добавить(СтруктураЭлемента);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ОбработатьОтносительныйПуть(Знач ОтносительныйПуть, КонтекстЯдра)

	Если Лев(ОтносительныйПуть, 1) = "." И ЗначениеЗаполнено(КонтекстЯдра.Объект.КаталогПроекта) Тогда
		ОтносительныйПуть = СтрШаблон("%1%2", КонтекстЯдра.Объект.КаталогПроекта, Сред(ОтносительныйПуть, 2));
	КонецЕсли;
	
	Результат = СтрЗаменить(ОтносительныйПуть, "\\", "\");
		
	Возврат Результат;

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