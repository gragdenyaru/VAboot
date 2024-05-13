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
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ЗаписатьИЗакрыть.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.СервисПереводаТекста");
	
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого Параметр Из ПараметрыАвторизации Цикл
		Если Параметр.Представление <> Строка(УникальныйИдентификатор) Тогда
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, Параметр.Представление, Параметр.Значение);
		КонецЕсли;
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Не ЗначениеЗаполнено(НаборКонстант.СервисПереводаТекста) Тогда
		НаборКонстант.СервисПереводаТекста = Перечисления.СервисыПереводаТекста.ЯндексПереводчик;
	КонецЕсли;
	
	ЗаполнитьНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СервисПереводаТекстаПриИзменении(Элемент)
	
	ЗаполнитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПараметрАвторизацииИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Элемент.КнопкаВыбора = Истина;
КонецПроцедуры

// Параметры:
//  Элемент - ПолеФормы
//
&НаКлиенте
Процедура Подключаемый_ПараметрАвторизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Индекс = ПараметрыАвторизации.Индекс(ПараметрыАвторизации.НайтиПоЗначению(Элемент.Имя));
	ПереключитьРежимПароля(Элемент, ПараметрыАвторизации[Индекс].Представление, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Записать();
	Закрыть(НаборКонстант.СервисПереводаТекста);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНастройки()
	
	СервисПереводаТекста = НаборКонстант.СервисПереводаТекста;
	
	Для Каждого Параметр Из ПараметрыАвторизации Цикл
		Элементы.Удалить(Элементы[Параметр.Значение]);
	КонецЦикла;
	ПараметрыАвторизации.Очистить();
	
	Элементы.Инструкция.Заголовок = "";
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиАвторизации = ПереводТекстаНаДругиеЯзыки.НастройкиАвторизации(СервисПереводаТекста);
	Если НастройкиАвторизации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиСервисаПереводаТекста = ПереводТекстаНаДругиеЯзыки.НастройкиСервисаПереводаТекста(СервисПереводаТекста);
	Элементы.Инструкция.Заголовок = НастройкиСервисаПереводаТекста.ИнструкцияПоПодключению;
	
	Для Индекс = 0 По НастройкиСервисаПереводаТекста.ПараметрыАвторизации.Количество() - 1  Цикл
		ОписаниеПараметра = НастройкиСервисаПереводаТекста.ПараметрыАвторизации[Индекс];
		ЗначениеПараметра = НастройкиАвторизации[ОписаниеПараметра.Имя];
		ПараметрыАвторизации.Добавить(ОписаниеПараметра.Имя, ?(ЗначениеЗаполнено(ЗначениеПараметра), УникальныйИдентификатор, ""));
		
		ПолеВвода = Элементы.Добавить(ОписаниеПараметра.Имя, Тип("ПолеФормы"), Элементы.ПараметрыАвторизации);
		ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
		ПолеВвода.Заголовок = ОписаниеПараметра.Представление;
		ПолеВвода.ПутьКДанным = "ПараметрыАвторизации[" + Индекс + "].Представление";
		ПолеВвода.ОтображениеПодсказки = ОписаниеПараметра.ОтображениеПодсказки;
		ПолеВвода.РасширеннаяПодсказка.Заголовок = ОписаниеПараметра.Подсказка;
		ПолеВвода.УстановитьДействие("НачалоВыбора", "Подключаемый_ПараметрАвторизацииНачалоВыбора");
		ПолеВвода.УстановитьДействие("ИзменениеТекстаРедактирования", "Подключаемый_ПараметрАвторизацииИзменениеТекстаРедактирования");
		ПолеВвода.РежимПароля = Истина;
		ПолеВвода.КнопкаВыбора = Не ЗначениеЗаполнено(ЗначениеПараметра);
		ПолеВвода.КартинкаКнопкиВыбора = БиблиотекаКартинок.ВводимыеСимволыВидны;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьРежимПароля(Элемент, Реквизит, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Реквизит = Элемент.ТекстРедактирования;
	Элемент.РежимПароля = Не Элемент.РежимПароля;
	Если Элемент.РежимПароля Тогда
		Элемент.КартинкаКнопкиВыбора = БиблиотекаКартинок.ВводимыеСимволыВидны;
	Иначе
		Элемент.КартинкаКнопкиВыбора = БиблиотекаКартинок.ВводимыеСимволыСкрыты;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

