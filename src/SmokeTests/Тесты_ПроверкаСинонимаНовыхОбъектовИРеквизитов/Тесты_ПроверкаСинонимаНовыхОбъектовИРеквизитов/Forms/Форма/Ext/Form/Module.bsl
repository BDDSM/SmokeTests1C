﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем ИсключенияИзПроверок;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдра) Экспорт
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	Инициализация(КонтекстЯдра);
	
	Если Не ЗначениеЗаполнено(ПрефиксОбъектов) Тогда
		Возврат;
	КонецЕсли;
		
	СтруктураОбъектовМетаданных = СтруктураОбъектовМетаданных(ПрефиксОбъектов);
	
	Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураОбъектовМетаданных Цикл
		Если ЭлементСтруктурыОбъектовМетаданных.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(ЭлементСтруктурыОбъектовМетаданных.Ключ, Ложь);
		Для Каждого ЭлементКоллекции Из ЭлементСтруктурыОбъектовМетаданных.Значение Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьСинонимОбъектаИлиРеквизитов", 
				НаборТестов.ПараметрыТеста(ЭлементКоллекции.ПолноеИмя, ЭлементКоллекции.Синоним), 
				СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]", ЭлементКоллекции.Имя, ЭлементКоллекции.Синоним));	
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
	
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
		
	Если Настройки.Свойство("Параметры") И Настройки.Параметры.Свойство("Префикс") Тогда
		ПрефиксОбъектов = ВРег(Настройки.Параметры.Префикс);
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки[ИмяТеста()].ИсключенияИзПроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ТекстИсключения = ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок);
			ИсключенияИзПроверок.Вставить(ТекстИсключения, Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьСинонимОбъектаИлиРеквизитов(ПолноеИмяМетаданных, Синоним) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);	
	мПрефиксОбъектов = ВРег(СтрЗаменить(ПрефиксОбъектов, "_", ""));
	ДлинаПрефикса = СтрДлина(мПрефиксОбъектов);
	
	Результат = (ВРег(Лев(Синоним, ДлинаПрефикса)) <> ВРег(мПрефиксОбъектов));
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения(ПолноеИмяМетаданных));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ТекстСообщения(ПолноеИмяМетаданных)

	ШаблонСообщения = НСтр("ru = 'Синоним объекта ""%1"" содержит префикс.'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), ВРег(Префикс)) > 0;	
КонецФункции

&НаСервереБезКонтекста
Функция СтруктураОбъектовМетаданных(ПрефиксОбъектов)
	
	МассивИменОбъектовМетаданных = МассивИменОбъектовМетаданных();
	СтроковыеУтилиты = СтроковыеУтилиты();
		
	СтруктураОбъектовМетаданных = Новый Структура;
	Для Каждого ЭлементМассива Из МассивИменОбъектовМетаданных Цикл
		СтруктураОбъектовМетаданных.Вставить(ЭлементМассива, Новый Массив);
	КонецЦикла;
	
	Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураОбъектовМетаданных Цикл
		
		Для Каждого ОбъектМетаданных Из Метаданные[ЭлементСтруктурыОбъектовМетаданных.Ключ] Цикл
			
			Если ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда 
				
				ДобавитьЭлементКоллекцииОбъектовМетаданных(
					СтруктураОбъектовМетаданных[ЭлементСтруктурыОбъектовМетаданных.Ключ], 
					ОбъектМетаданных.Имя, 
					ОбъектМетаданных.ПолноеИмя(),
					ОбъектМетаданных.Синоним);
					
			КонецЕсли;
							
			Параметры = Новый Структура;
			Параметры.Вставить("ОбъектМетаданных", ОбъектМетаданных);
			Параметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
			Параметры.Вставить("ИмяМетаданных", ЭлементСтруктурыОбъектовМетаданных.Ключ);
			Параметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
			Параметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);
			
			ОбработатьЭлементыОбъекта(Параметры, "Подсистемы", "Подсистема");
			ОбработатьЭлементыОбъекта(Параметры, "ЗначенияПеречисления", "ЗначениеПеречисления");
			ОбработатьЭлементыОбъекта(Параметры, "Измерения", "Измерение");
			ОбработатьЭлементыОбъекта(Параметры, "Ресурсы", "Ресурс");
			ОбработатьЭлементыОбъекта(Параметры, "Реквизиты", "Реквизит");
			ОбработатьЭлементыОбъекта(Параметры, "РеквизитыАдресации", "РеквизитАдресации");
			ОбработатьЭлементыОбъекта(Параметры, "Перерасчеты", "Перерасчет");
			ОбработатьЭлементыОбъекта(Параметры, "ПризнакиУчета", "ПризнакУчета");
			ОбработатьЭлементыОбъекта(Параметры, "ПризнакиУчетаСубконто", "ПризнакУчетаСубконто");
			ОбработатьТабличныеЧастиОбъекта(Параметры, "ТабличныеЧасти", "ТабличнаяЧасть");
			ОбработатьЭлементыОбъекта(Параметры, "Графы", "Граф");
			ОбработатьЭлементыОбъекта(Параметры, "Формы", "Форма");
			ОбработатьЭлементыОбъекта(Параметры, "Команды", "Команда");
			ОбработатьЭлементыОбъекта(Параметры, "Макеты", "Макет");
													
		КонецЦикла;
			
	КонецЦикла;
	
	Возврат СтруктураОбъектовМетаданных;

КонецФункции 

&НаСервереБезКонтекста
Процедура ОбработатьТабличныеЧастиОбъекта(Параметры, ИмяКоллекции, ИмяЭлемента)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонПоиска = "%1.%2.%3";
	ШаблонРеквизит = "%1.%2.%3.Реквизит.%4";
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		ИмяОбъекта = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
						ШаблонПоиска, 
						ОбъектМетаданных.Имя, 
						ИмяЭлемента, 
						ЭлементКоллекции.Имя);
		
		Если ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов) Тогда
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				СтруктураОбъектовМетаданных[ИмяМетаданных], 
				ИмяОбъекта, 
				ЭлементКоллекции.ПолноеИмя(),
				ЭлементКоллекции.Синоним);
		КонецЕсли;
		
		Для Каждого Реквизит Из ЭлементКоллекции.Реквизиты Цикл
			
			ИмяОбъекта = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
							ШаблонРеквизит, 
							ОбъектМетаданных.Имя, 
							ИмяЭлемента, 
							ЭлементКоллекции.Имя, 
							Реквизит.Имя);
			
			Если ИмяСодержитПрефикс(Реквизит.Имя, ПрефиксОбъектов) Тогда
				ДобавитьЭлементКоллекцииОбъектовМетаданных(
					СтруктураОбъектовМетаданных[ИмяМетаданных], 
					ИмяОбъекта, 
					Реквизит.ПолноеИмя(),
					Реквизит.Синоним);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ОбработатьЭлементыОбъекта(Параметры, ИмяКоллекции, ИмяЭлемента, ИмяРодителя = "")

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		мИмяОбъекта = ?(ЗначениеЗаполнено(ИмяРодителя), ИмяРодителя, ОбъектМетаданных.Имя);
		ИмяОбъекта = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.%2.%3", мИмяОбъекта, ИмяЭлемента, ЭлементКоллекции.Имя);
		
		Если ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов) Тогда
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				СтруктураОбъектовМетаданных[ИмяМетаданных], 
				ИмяОбъекта, 
				ЭлементКоллекции.ПолноеИмя(),
				ЭлементКоллекции.Синоним);
		КонецЕсли;
		
		Если Не ЕстьРеквизитИлиСвойствоОбъекта(ЭлементКоллекции, ИмяКоллекции) Тогда
			мПараметры = Новый Структура;
			мПараметры.Вставить("ОбъектМетаданных", ЭлементКоллекции);
			мПараметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
			мПараметры.Вставить("ИмяМетаданных", ИмяМетаданных);
			мПараметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
			мПараметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);
			ОбработатьЭлементыОбъекта(мПараметры, ИмяКоллекции, ИмяЭлемента, ИмяОбъекта);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(Коллекция, Имя, ПолноеИмя, Синоним)

	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("Имя", Имя);
	СтруктураЭлемента.Вставить("ПолноеИмя", ПолноеИмя);
	СтруктураЭлемента.Вставить("Синоним", Синоним);
	Коллекция.Добавить(СтруктураЭлемента);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция МассивИменОбъектовМетаданных()

	МассивИменОбъектовМетаданных = Новый Массив;
	                                 
	МассивИменОбъектовМетаданных.Добавить("Подсистемы");    
	МассивИменОбъектовМетаданных.Добавить("ОбщиеМодули");
	МассивИменОбъектовМетаданных.Добавить("ПараметрыСеанса");
	МассивИменОбъектовМетаданных.Добавить("Роли");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеРеквизиты");
	МассивИменОбъектовМетаданных.Добавить("ПланыОбмена");
	МассивИменОбъектовМетаданных.Добавить("КритерииОтбора");
	МассивИменОбъектовМетаданных.Добавить("ПодпискиНаСобытия");
	МассивИменОбъектовМетаданных.Добавить("РегламентныеЗадания");
	МассивИменОбъектовМетаданных.Добавить("ФункциональныеОпции");	
	МассивИменОбъектовМетаданных.Добавить("ПараметрыФункциональныхОпций");
	МассивИменОбъектовМетаданных.Добавить("ОпределяемыеТипы");
	МассивИменОбъектовМетаданных.Добавить("ХранилищаНастроек");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеФормы");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеКоманды");
	МассивИменОбъектовМетаданных.Добавить("ГруппыКоманд");
	МассивИменОбъектовМетаданных.Добавить("Интерфейсы");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеМакеты");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеКартинки");
	МассивИменОбъектовМетаданных.Добавить("ПакетыXDTO");
	МассивИменОбъектовМетаданных.Добавить("WebСервисы");
	МассивИменОбъектовМетаданных.Добавить("HTTPСервисы");  
	МассивИменОбъектовМетаданных.Добавить("WSСсылки");
	МассивИменОбъектовМетаданных.Добавить("ЭлементыСтиля");
	МассивИменОбъектовМетаданных.Добавить("Стили");
	МассивИменОбъектовМетаданных.Добавить("Языки");    
	МассивИменОбъектовМетаданных.Добавить("Константы");
	МассивИменОбъектовМетаданных.Добавить("Справочники");
	МассивИменОбъектовМетаданных.Добавить("Документы");
	МассивИменОбъектовМетаданных.Добавить("ЖурналыДокументов");
	МассивИменОбъектовМетаданных.Добавить("Перечисления");
	МассивИменОбъектовМетаданных.Добавить("Отчеты");
	МассивИменОбъектовМетаданных.Добавить("Обработки");
	МассивИменОбъектовМетаданных.Добавить("ПланыВидовХарактеристик");
	МассивИменОбъектовМетаданных.Добавить("ПланыСчетов");
	МассивИменОбъектовМетаданных.Добавить("ПланыВидовРасчета");
	МассивИменОбъектовМетаданных.Добавить("РегистрыСведений");
	МассивИменОбъектовМетаданных.Добавить("РегистрыНакопления");
	МассивИменОбъектовМетаданных.Добавить("РегистрыБухгалтерии");
	МассивИменОбъектовМетаданных.Добавить("РегистрыРасчета");
	МассивИменОбъектовМетаданных.Добавить("БизнесПроцессы");
	МассивИменОбъектовМетаданных.Добавить("Задачи");
	МассивИменОбъектовМетаданных.Добавить("ВнешниеИсточникиДанных");
	
	Возврат МассивИменОбъектовМетаданных;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
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