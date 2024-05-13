﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ЗаполнитьТаблицуСервисов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоискАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание > 0 Тогда
		УстановитьОтборВСпискеРесурсов(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	УстановитьОтборВСпискеРесурсов(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискОчистка(Элемент, СтандартнаяОбработка)
	
	Элементы.СервисыИнтернетПоддержки.ОтборСтрок = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСервисыИнтернетПоддержки

&НаКлиенте
Процедура СервисыИнтернетПоддержкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.СервисыИнтернетПоддержкиНазвание Тогда
		ТекущиеДанные = СервисыИнтернетПоддержки.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные <> Неопределено Тогда
			ТекущиеДанные.РазрешенаРабота = Не ТекущиеДанные.РазрешенаРабота;
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	УстановитьПометкиСпискаРесурсов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСоВсех(Команда)
	
	УстановитьПометкиСпискаРесурсов(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьНаСервере();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Контекст) Экспорт
	
	СохранитьНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВСпискеРесурсов(Знач Текст)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Отбор = Новый ФиксированнаяСтруктура(Новый Структура("Название", Текст));
		Элементы.СервисыИнтернетПоддержки.ОтборСтрок = Отбор;
	Иначе
		Элементы.СервисыИнтернетПоддержки.ОтборСтрок = Неопределено;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкиСпискаРесурсов(Знач Пометка)
	
	// Устанавливаем пометки только для видимых строк.
	ЭлементТаблицы = Элементы.СервисыИнтернетПоддержки;
	Для Каждого СтрокаСервиса Из СервисыИнтернетПоддержки Цикл
		Если ЭлементТаблицы.ДанныеСтроки(СтрокаСервиса.ПолучитьИдентификатор()) <> Неопределено Тогда
			СтрокаСервиса.РазрешенаРабота = Пометка;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	
	Сервисы = Новый Массив;
	Для Каждого СтрокаСервиса Из СервисыИнтернетПоддержки Цикл
		
		Сервисы.Добавить(
			Новый Структура("Название, РазрешенаРабота",
				СтрокаСервиса.Название,
				СтрокаСервиса.РазрешенаРабота));
		
	КонецЦикла;
	
	ИнтернетПоддержкаПользователей.РазблокироватьРаботуССервисамиИнтернетПоддержки(Сервисы);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Поля = Элемент.Поля.Элементы;
	Поля.Добавить().Поле = Новый ПолеКомпоновкиДанных("СервисыИнтернетПоддержкиНазвание");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СервисыИнтернетПоддержки.РазрешенаРабота");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ШрифтВажногоЗаголовкаБИП);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСервисов()
	
	СервисыИнтернетПоддержки.Очистить();
	
	ПараметрыБлокировки = ИнтернетПоддержкаПользователей.ПараметрыБлокировкиССервисамиИнтернетПоддержки();
	
	Для Каждого Ресурс Из ПараметрыБлокировки.СервисыИнтернетПоддержки Цикл
		НовСтрока = СервисыИнтернетПоддержки.Добавить();
		НовСтрока.Название  = Ресурс.Ключ;
		НовСтрока.РазрешенаРабота = Ресурс.Значение.РазрешенаРабота;
	КонецЦикла;
	
	СервисыИнтернетПоддержки.Сортировать("Название");
	
КонецПроцедуры

#КонецОбласти