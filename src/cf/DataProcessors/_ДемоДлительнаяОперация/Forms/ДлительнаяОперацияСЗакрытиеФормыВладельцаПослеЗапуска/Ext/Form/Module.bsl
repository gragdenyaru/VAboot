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
	
	СекундПередЗакрытием            = Параметры.СекундПередЗакрытием;
	ПоказатьОповещение              = Параметры.ПоказатьОповещение;
	НеопределеноВместоВладелецФормы = Параметры.НеопределеноВместоВладелецФормы;
	
	Если Не ЗначениеЗаполнено(СекундПередЗакрытием) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина; // Всегда выполняется в фоне для демонстрации длительной операции.
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	ДополнительныеПараметры = Обработки._ДемоДлительнаяОперация.НовыеДополнительныеПараметрыВыполнения();
	Если Не Параметры.ОжидатьЗавершенияЗадания Тогда
		ДополнительныеПараметры.ДлительностьРасчета = Параметры.СекундВыполненияЗадания;
	КонецЕсли;
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"Обработки._ДемоДлительнаяОперация.РассчитатьЗначение", 0, ДополнительныеПараметры);
	
	Если Параметры.ОжидатьЗавершенияЗадания Тогда
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ДлительнаяОперация.ИдентификаторЗадания);
		ФоновоеЗадание.ОжидатьЗавершенияВыполнения(60);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(СекундПередЗакрытием) Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПослеОткрытияФормы", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеОткрытияФормы()
	
	ФормаВладелец = ?(НеопределеноВместоВладелецФормы, Неопределено, ЭтотОбъект);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ФормаВладелец);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	Если ПоказатьОповещение Тогда
		ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
		ПараметрыОжидания.ОповещениеПользователя.Текст = НСтр("ru = 'Операция завершена'");
	КонецЕсли;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультат", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
	Если СекундПередЗакрытием >= 0.1 Тогда
		ПодключитьОбработчикОжидания("ЗакрытьФорму", СекундПередЗакрытием, Истина);
	Иначе
		ЗакрытьФорму();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультат(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		ТекстРезультата = НСтр("ru = 'Ошибка: длительная операция отменена'");
		
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ТекстРезультата = Результат.КраткоеПредставлениеОшибки;
		
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ТекстРезультата =
			НСтр("ru = 'Успех: длительная операция выполнена после закрытия формы
			           |владельца и автоматического закрытия формы ожидания'");
	Иначе
		ТекстРезультата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка: неизвестный статус ""%1""'"),
			Результат.Статус);
	КонецЕсли;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.ИдентификаторНазначения = ВладелецФормы.УникальныйИдентификатор;
	Сообщение.Текст = ТекстРезультата;
	Сообщение.Сообщить();
	
	ВсеОкна = ПолучитьОкна();
	Для Каждого ТекущееОкно Из ВсеОкна Цикл
		Если ТекущееОкно.Основное Тогда
			ТекущееОкно.Активизировать();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
