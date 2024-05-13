﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "3.1.9.231";
		Обработчик.Процедура = "РегистрыСведений.КлассификаторыМЧД.УстановитьРасписаниеРегламентногоЗадания";
		Обработчик.РежимВыполнения = "Оперативно";
		Обработчик.НачальноеЗаполнение = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция КлассификаторПолномочий() Экспорт
	
	ТекстовыйДокумент = ПолучитьМакет("Полномочия");
	КлассификаторJSON = ТекстовыйДокумент.ПолучитьТекст();
	
	ДанныеКлассификатора = ОбщегоНазначения.JSONВЗначение(КлассификаторJSON);
	
	Классификатор = Новый ДеревоЗначений;
	Классификатор.Колонки.Добавить("Код", Новый ОписаниеТипов("Строка"));
	Классификатор.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	
	Для Каждого Элемент Из ДанныеКлассификатора Цикл
		Группа = Классификатор;
		ОписаниеГруппы = Элемент["group"];
		КодПолномочия = Элемент["code"];
		
		Если ОписаниеГруппы <> Неопределено Тогда
			КодГруппы = ОписаниеГруппы["code"];
			НаименованиеГруппы = ОписаниеГруппы["description"];
			
			Если КодПолномочия = "BRREPTG_RSPND_BRSTATREPORTINGNFOGNRL" Тогда
				НаименованиеГруппы = НаименованиеГруппыДляВзаимодействияСБанкомРоссии();
			КонецЕсли;
			
			Если ЗначениеЗаполнено(НаименованиеГруппы) Тогда
				Если НаименованиеГруппы = НаименованиеГруппыДляВзаимодействияСБанкомРоссии() Тогда
					КодГруппы = НаименованиеГруппы;
				КонецЕсли;
		
				Группа = Классификатор.Строки.Найти(КодГруппы, "Код", Ложь);
			
				Если Группа = Неопределено Тогда
					Группа = Классификатор.Строки.Добавить();
					Группа.Код = КодГруппы;
					Группа.Наименование = НаименованиеГруппы;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Полномочие = Группа.Строки.Добавить();
		Полномочие.Код = КодПолномочия;
		Полномочие.Наименование = Элемент["description"];
	КонецЦикла;
	
	ДобавитьПолномочияФТС(Классификатор);
	
	Классификатор.Строки.Сортировать("Наименование, Код", Ложь);
	Возврат Классификатор;
	
КонецФункции

Функция КлассификаторОграничений() Экспорт
	
	ДанныеКлассификатора = ДанныеФайла(ИдентификаторКлассификатораОграничений());
	
	Если ДанныеКлассификатора = Неопределено Тогда
		ТекстовыйДокумент = ПолучитьМакет("ОграниченияПолномочий");
		ДанныеКлассификатора = ТекстовыйДокумент.ПолучитьТекст();
	КонецЕсли;
	
	Классификатор = ПрочитатьCSV(ДанныеКлассификатора);
	
	ИменаКолонок = Новый Соответствие;
	ИменаКолонок.Вставить("CODE", "Код");
	ИменаКолонок.Вставить("NAME", "Наименование");
	ИменаКолонок.Вставить("DESCRIPTION", "Описание");
	
	Для Каждого ИмяКолонки Из ИменаКолонок Цикл
		Классификатор.Колонки[ИмяКолонки.Ключ].Имя = ИмяКолонки.Значение;
	КонецЦикла;
	
	Классификатор.Колонки.Добавить("ОписаниеТипа", Новый ОписаниеТипов("ОписаниеТипов"));
	Классификатор.Колонки.Добавить("ДействуетС", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	Классификатор.Колонки.Добавить("ОтозваноС", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	Классификатор.Колонки.Добавить("Отозвано", Новый ОписаниеТипов("Булево"));
	Классификатор.Колонки.Добавить("ЭтоТекстовоеЗначение", Новый ОписаниеТипов("Булево"));
	
	Для Каждого СтрокаТаблицы Из Классификатор Цикл
		СтрокаТаблицы.ОписаниеТипа = ПрочитатьОписаниеТипа(СтрокаТаблицы["FORMAT"]);
		СтрокаТаблицы.ЭтоТекстовоеЗначение = Не ПрочитатьБулево(СтрокаТаблицы["SPR_VALUE"]);
		СтрокаТаблицы.ДействуетС = ПрочитатьДату(СтрокаТаблицы["STARTED"]);
		СтрокаТаблицы.ОтозваноС = ПрочитатьДату(СтрокаТаблицы["REVOKED"]);
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.ОтозваноС) Тогда
			СтрокаТаблицы.Отозвано = СтрокаТаблицы.ОтозваноС < ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЦикла;
	
	УдаляемыеКолонки = Новый Массив;
	УдаляемыеКолонки.Добавить("STARTED");
	УдаляемыеКолонки.Добавить("REVOKED");
	УдаляемыеКолонки.Добавить("FORMAT");
	УдаляемыеКолонки.Добавить("SPR_VALUE");
	УдаляемыеКолонки.Добавить("FLC");
	УдаляемыеКолонки.Добавить("autokey");
	
	Для Каждого ИмяКолонки Из УдаляемыеКолонки Цикл
		ИндексКолонки = Классификатор.Колонки.Индекс(Классификатор.Колонки[ИмяКолонки]);
		Классификатор.Колонки.Удалить(ИндексКолонки);
	КонецЦикла;
	
	Возврат Классификатор;
	
КонецФункции

Функция КлассификаторЗначенийОграничений() Экспорт
	
	ДанныеКлассификатора = ДанныеФайла(ИдентификаторКлассификатораЗначенийОграничений());
	
	Если ДанныеКлассификатора = Неопределено Тогда
		ТекстовыйДокумент = ПолучитьМакет("ЗначенияОграниченийПолномочий");
		ДанныеКлассификатора = ТекстовыйДокумент.ПолучитьТекст();
	КонецЕсли;	
	
	Классификатор = ПрочитатьCSV(ДанныеКлассификатора);
	
	ИменаКолонок = Новый Соответствие;
	ИменаКолонок.Вставить("CODE_VALUE", "Код");
	ИменаКолонок.Вставить("NAME_VALUE", "Наименование");
	ИменаКолонок.Вставить("CODE", "КодОграничения");
	
	Для Каждого ИмяКолонки Из ИменаКолонок Цикл
		Классификатор.Колонки[ИмяКолонки.Ключ].Имя = ИмяКолонки.Значение;
	КонецЦикла;
	
	Классификатор.Колонки.Добавить("ДействуетС", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	Классификатор.Колонки.Добавить("ОтозваноС", Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	Классификатор.Колонки.Добавить("Отозвано", Новый ОписаниеТипов("Булево"));
	
	Для Каждого СтрокаТаблицы Из Классификатор Цикл
		СтрокаТаблицы.ДействуетС = ПрочитатьДату(СтрокаТаблицы["STARTED"]);
		СтрокаТаблицы.ОтозваноС = ПрочитатьДату(СтрокаТаблицы["REVOKED"]);
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.ОтозваноС) Тогда
			СтрокаТаблицы.Отозвано = СтрокаТаблицы.ОтозваноС < ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЦикла;
	
	УдаляемыеКолонки = Новый Массив;
	УдаляемыеКолонки.Добавить("STARTED");
	УдаляемыеКолонки.Добавить("REVOKED");
	УдаляемыеКолонки.Добавить("autokey");
	
	Для Каждого ИмяКолонки Из УдаляемыеКолонки Цикл
		ИндексКолонки = Классификатор.Колонки.Индекс(Классификатор.Колонки[ИмяКолонки]);
		Классификатор.Колонки.Удалить(ИндексКолонки);
	КонецЦикла;
	
	Возврат Классификатор;
	
КонецФункции

Процедура ОбновитьКлассификаторы() Экспорт
	
	ОбновляемыеФайлы = Новый СписокЗначений();
	ОбновляемыеФайлы.Добавить(ИдентификаторКлассификатораОграничений(), АдресСервисаКлассификатораОграничений(), Истина);
	ОбновляемыеФайлы.Добавить(ИдентификаторКлассификатораЗначенийОграничений(), АдресСервисаКлассификатораЗначенийОграничений(), Истина);
	
	ОбновлениеВыполнено = Истина;
	РезультатыОбновленияФайлов = ОбновитьФайлы(ОбновляемыеФайлы);
	СписокОшибок = Новый Массив;
	
	Для Каждого ОбновляемыйФайл Из ОбновляемыеФайлы Цикл
		ИдентификаторФайла = ОбновляемыйФайл.Значение;
		РезультатОбновленияФайла = РезультатыОбновленияФайлов[ИдентификаторФайла];
		ОбновлениеВыполнено = ОбновлениеВыполнено И РезультатОбновленияФайла.ОбновлениеВыполнено;
		Если Не РезультатОбновленияФайла.ОбновлениеВыполнено Тогда
			СписокОшибок.Добавить(РезультатОбновленияФайла.ТекстОшибки);
		КонецЕсли;
	КонецЦикла;
	
	ТекстОшибки = СтрСоединить(СписокОшибок, Символы.ПС);
	Если Не ОбновлениеВыполнено Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

Функция ОбновитьФайлы(ОбновляемыеФайлы)
	
	ИдентификаторыФайлов = ОбновляемыеФайлы.ВыгрузитьЗначения();
	ДатыИзмененияФайлов = ДатыИзмененияФайлов(ИдентификаторыФайлов);
	РезультатыОбновленияФайлов = Новый Соответствие;
	
	Для Каждого ОбновляемыйФайл Из ОбновляемыеФайлы Цикл
		ИдентификаторФайла = ОбновляемыйФайл.Значение;
		АдресФайла = ОбновляемыйФайл.Представление;
		РаспаковатьИзАрхива = ОбновляемыйФайл.Пометка;
		ДатаИзмененияФайла = ДатыИзмененияФайлов[ИдентификаторФайла];
		РезультатОбновленияФайла = ОбновитьФайл(ИдентификаторФайла, АдресФайла, ДатаИзмененияФайла, РаспаковатьИзАрхива);
		РезультатыОбновленияФайлов.Вставить(ИдентификаторФайла, РезультатОбновленияФайла);
	КонецЦикла;
	
	Возврат РезультатыОбновленияФайлов;
	
КонецФункции

Функция ОбновитьФайл(Знач ИдентификаторФайла, Знач АдресФайла, Знач ДатаИзмененияФайла, РаспаковатьИзАрхива = Ложь)
	
	РезультатОбновления = Новый Структура;
	РезультатОбновления.Вставить("ОбновлениеВыполнено", Истина);
	РезультатОбновления.Вставить("ТекстОшибки", "");
	
	ПараметрыПолучения = ПолучениеФайловИзИнтернетаКлиентСервер.ПараметрыПолученияФайла();
	ПараметрыПолучения.Заголовки.Вставить("If-Modified-Since", ДатаИзмененияФайла);
	ПараметрыПолучения.Заголовки.Вставить("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36");
	
	РезультатЗагрузки = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(АдресФайла, ПараметрыПолучения, Ложь);
	
	Если Не РезультатЗагрузки.Статус И РезультатЗагрузки.КодСостояния = 304 Тогда // Файл не изменился на сервере.
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файл %1 актуален.'"),
			Строка(ИдентификаторФайла));
		ЗаписатьВЖурналРегистрации(Комментарий);
		Возврат РезультатОбновления;
	КонецЕсли;
	
	Если РезультатЗагрузки.Статус Тогда
		ЗагруженныйФайл = ПолучитьИзВременногоХранилища(РезультатЗагрузки.Путь); // ДвоичныеДанные
		Если РаспаковатьИзАрхива Тогда
			Данные = Неопределено;
			РазмерФайла = ЗагруженныйФайл.Размер();

			Если РазмерФайла > 0 Тогда
				Данные = РаспаковатьФайлИзАрхива(ЗагруженныйФайл);
			КонецЕсли;
			
			Если Данные = Неопределено Тогда
				РезультатЗагрузки.Статус = Ложь;
				
				Если РазмерФайла > 0 Тогда
					ОписаниеСодержимогоФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Содержимое файла:
						|%1'"), Base64Строка(ЗагруженныйФайл));
				Иначе
					ОписаниеСодержимогоФайла = НСтр("ru = 'Файл пустой.'");
				КонецЕсли;
				
				СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось распаковать загруженный файл
						|%1
						|
						|%2'"),
					АдресФайла,
					ОписаниеСодержимогоФайла);
				
				РезультатЗагрузки.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
			КонецЕсли;
		Иначе
			Данные = ЗагруженныйФайл;
		КонецЕсли;
	КонецЕсли;
	
	Если Не РезультатЗагрузки.Статус Тогда
		РезультатОбновления.ОбновлениеВыполнено = Ложь;
		РезультатОбновления.ТекстОшибки = РезультатЗагрузки.СообщениеОбОшибке;
		Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обновить файл %1 по причине:
			|%2'"),
			Строка(ИдентификаторФайла),
			РезультатОбновления.ТекстОшибки);
		ЗаписатьВЖурналРегистрации(Комментарий, УровеньЖурналаРегистрации.Ошибка);
		Возврат РезультатОбновления;
	КонецЕсли;
	Данные = ПолучитьСтрокуИзДвоичныхДанных(Данные, "UTF-8");
	
	ДатаИзмененияФайла = РезультатЗагрузки.Заголовки["Last-Modified"];

	Если Не ЗначениеЗаполнено(ДатаИзмененияФайла) Тогда
		ДатаИзмененияФайла = ТекущаяДатаСеанса();
	КонецЕсли;
	
	БлокировкаДанных = Новый БлокировкаДанных();
	ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.КлассификаторыМЧД");
	ЭлементБлокировкиДанных.УстановитьЗначение("Идентификатор", ИдентификаторФайла);
	
	НаборЗаписей = РегистрыСведений.КлассификаторыМЧД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Идентификатор.Установить(ИдентификаторФайла);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Идентификатор = ИдентификаторФайла;
	Запись.Данные = Новый ХранилищеЗначения(Данные, Новый СжатиеДанных(9));
	Запись.ДатаИзменения = ДатаИзмененияФайла;	
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных.Заблокировать();
		НаборЗаписей.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Файл %1 обновлен.'"),
		Строка(ИдентификаторФайла));
	ЗаписатьВЖурналРегистрации(Комментарий);
	
	Возврат РезультатОбновления;
	
КонецФункции

Функция РаспаковатьФайлИзАрхива(ДвоичныеДанныеАрхива)
	
	ПотокВПамяти = ДвоичныеДанныеАрхива.ОткрытьПотокДляЧтения();
	
	Попытка
		ЧтениеZipФайла = Новый ЧтениеZipФайла(ПотокВПамяти);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	ВременныйКаталог = ФайловаяСистема.СоздатьВременныйКаталог();
	ДвоичныеДанныеФайла = Неопределено;
	
	Для Каждого ЭлементАрхива Из ЧтениеZipФайла.Элементы Цикл
		ИмяФайла = ЭлементАрхива.Имя;
		ЧтениеZipФайла.Извлечь(ЭлементАрхива, ВременныйКаталог);
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ВременныйКаталог + ИмяФайла);
		Прервать;
	КонецЦикла;

	ЧтениеZipФайла.Закрыть();
	ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции

Функция ДанныеФайла(Знач ИдентификаторФайла)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторыМЧД.Данные
	|ИЗ
	|	РегистрСведений.КлассификаторыМЧД КАК КлассификаторыМЧД
	|ГДЕ
	|	КлассификаторыМЧД.Идентификатор = &Идентификатор";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторФайла);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Данные.Получить()
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ДатыИзмененияФайлов(ИдентификаторыФайлов)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторыМЧД.Идентификатор,
	|	КлассификаторыМЧД.ДатаИзменения
	|ИЗ
	|	РегистрСведений.КлассификаторыМЧД КАК КлассификаторыМЧД
	|ГДЕ
	|	КлассификаторыМЧД.Идентификатор В (&Идентификаторы)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Идентификаторы", ИдентификаторыФайлов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДатыИзмененияФайлов = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		ДатыИзмененияФайлов.Вставить(Выборка.Идентификатор, Выборка.ДатаИзменения);
	КонецЦикла;
	
	Для Каждого ИдентификаторФайла Из ИдентификаторыФайлов Цикл
		Если ДатыИзмененияФайлов[ИдентификаторФайла] = Неопределено Тогда
			ДатыИзмененияФайлов[ИдентификаторФайла] = '00010101';
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДатыИзмененияФайлов;
	
КонецФункции

Функция ИдентификаторКлассификатораОграничений()
	Возврат Новый УникальныйИдентификатор("ae908b89-f44c-495f-a733-4cd6a5d96692");
КонецФункции

Функция АдресСервисаКлассификатораОграничений()
	Возврат "https://esnsi.gosuslugi.ru/rest/ext/v1/classifiers/11366/file?extension=CSV&encoding=UTF_8";
КонецФункции

Функция ИдентификаторКлассификатораЗначенийОграничений()
	Возврат Новый УникальныйИдентификатор("af31952b-b262-4c8e-b049-2eed00782193");
КонецФункции

Функция АдресСервисаКлассификатораЗначенийОграничений()
	Возврат "https://esnsi.gosuslugi.ru/rest/ext/v1/classifiers/11367/file?extension=CSV&encoding=UTF_8";
КонецФункции

Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Обновление классификаторов МЧД'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Процедура ЗаписатьВЖурналРегистрации(Комментарий, Уровень = Неопределено)
	
	Если Уровень = Неопределено Тогда
		Уровень = УровеньЖурналаРегистрации.Информация;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(), Уровень,
		Метаданные.РегистрыСведений.КлассификаторыМЧД, , Комментарий);
	
КонецПроцедуры

Функция ПрочитатьCSV(Текст)
	
	Строки = СтрРазделитьСУчетомСтрок(Текст, Символы.ПС, Ложь);
	ТаблицаЗначений = Новый ТаблицаЗначений;

	Для Каждого Строка Из Строки Цикл
		Значения = СтрРазделитьСУчетомСтрок(Строка, ";", Истина);
		
		Если ТаблицаЗначений.Колонки.Количество() = 0 Тогда
			Для Каждого Значение Из Значения Цикл
				ТаблицаЗначений.Колонки.Добавить(Значение, Новый ОписаниеТипов("Строка"));
			КонецЦикла;
			Продолжить;
		КонецЕсли;
		
		КоличествоКолонок = ТаблицаЗначений.Колонки.Количество();
		СтрокаТаблицы = ТаблицаЗначений.Добавить();
		
		Для Индекс = 0 По Значения.ВГраница() Цикл
			Если Индекс + 1 > КоличествоКолонок Тогда
				ИмяКолонки = "Колонка" + XMLСтрока(Индекс+1);
				ТаблицаЗначений.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Строка"));
				КоличествоКолонок = КоличествоКолонок + 1;
			КонецЕсли;
			Значение = ОчиститьКавычки(Значения[Индекс]);
			СтрокаТаблицы[Индекс] = Значение;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
	
КонецФункции

Функция СтрРазделитьСУчетомСтрок(ИсходнаяСтрока, Разделитель, ВключатьПустые = Истина)
	
	Результат = Новый Массив;
	СтрокиМеждуКавычками = СтрРазделить(ИсходнаяСтрока, """", Истина);
	
	Если СтрокиМеждуКавычками.Количество() = 0 Тогда
		Возврат СтрРазделить(ИсходнаяСтрока, Разделитель, ВключатьПустые);
	КонецЕсли;
	
	Для Индекс = 0 По СтрокиМеждуКавычками.ВГраница() Цикл
		Если Индекс % 2 = 1 Тогда
			Результат[Результат.ВГраница()] = Результат[Результат.ВГраница()] + """" + СтрокиМеждуКавычками[Индекс] + ?(Индекс = СтрокиМеждуКавычками.ВГраница(), "", """");
			Продолжить;
		КонецЕсли;
		
		Если СтрокиМеждуКавычками[Индекс] = "" Тогда
			Продолжить;
		КонецЕсли;
		
		ЧастиСтроки = СтрРазделить(СтрокиМеждуКавычками[Индекс], Разделитель, Истина);
		Для ИндексЭлемента = 0 По ЧастиСтроки.ВГраница() Цикл
			ЧастьСтроки = ЧастиСтроки[ИндексЭлемента];
			Если Индекс > 0 И ИндексЭлемента = 0 Тогда
				Результат[Результат.ВГраница()] = Результат[Результат.ВГраница()] + ЧастьСтроки;
			Иначе
				Результат.Добавить(ЧастьСтроки);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Не ВключатьПустые Тогда
		Для Индекс = -Результат.Количество() + 1 По 0 Цикл
			Если ПустаяСтрока(Результат[-Индекс]) Тогда
				Результат.Удалить(-Индекс);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОчиститьКавычки(Знач Строка)
	
	Если СтрНачинаетсяС(Строка, """") И СтрЗаканчиваетсяНа(Строка, """") Тогда
		Строка = Сред(Строка, 2, СтрДлина(Строка) - 2);
		Строка = СтрЗаменить(Строка, """""", """");
	КонецЕсли;
	
	Возврат Строка;
	
КонецФункции

Функция ПрочитатьОписаниеТипа(Знач Строка)
	
	ИмяТипа = Строка;
	Позиция = СтрНайти(Строка, "(");
	
	Если Позиция > 0 Тогда
		ИмяТипа = Лев(Строка, Позиция - 1);
		Строка = Сред(Строка, Позиция + 1);
	КонецЕсли;
	
	Если СтрЗаканчиваетсяНа(Строка, ")") Тогда
		Строка = Лев(Строка, СтрДлина(Строка) - 1);
		Длина = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Строка);
	КонецЕсли;
	
	Тип = "Строка";
	ДопустимаяДлинаСтроки = ДопустимаяДлина.Переменная;
	
	Если ИмяТипа = "integer" Тогда
		Тип = "Число";
	ИначеЕсли ИмяТипа = "char" Тогда
		ДопустимаяДлинаСтроки = ДопустимаяДлина.Фиксированная;
	КонецЕсли;
	
	КвалификаторыСтроки = Неопределено;
	Если Длина <> Неопределено Тогда
		КвалификаторыСтроки = Новый КвалификаторыСтроки(Длина, ДопустимаяДлинаСтроки);
	КонецЕсли;
	
	Возврат Новый ОписаниеТипов(Тип, , КвалификаторыСтроки);
	
КонецФункции

Функция ПрочитатьДату(Знач Строка)
	
	ЧастиСтроки = СтрРазделить(Строка, ".", Ложь);
	Если ЧастиСтроки.Количество() <> 3 Тогда
		Возврат '00010101';
	КонецЕсли;
	
	Возврат Дата(ЧастиСтроки[2], ЧастиСтроки[1], ЧастиСтроки[0]);
	
КонецФункции

Функция ПрочитатьБулево(Знач Строка)
	
	Возврат ТРег(Строка) = "Да";
	
КонецФункции

Процедура ДобавитьПолномочияФТС(Классификатор)
	
	// АПК:1297-выкл - не локализуется, добавляется в классификатор полномочий.
	
	НаименованиеГруппы = "Федеральная таможенная служба";
	
	ПолномочияФТС = Новый СписокЗначений;
	ПолномочияФТС.Добавить("FTS_10001", "Подписание таможенных документов, предоставляемых в ФТС России заинтересованными лицами в рамках таможенного декларирования и таможенных операций, связанных с подачей, регистрацией, отзывом и изменением сведений, заявленных в таможенной декларации");
	ПолномочияФТС.Добавить("FTS_10002", "Подписание иных электронных документов, предоставляемых заинтересованными лицами в таможенные органы, несвязанных с таможенным декларированием товаров, транспортных средств и выпуском товаров");
	
	// АПК:1297-вкл
	
	ДобавитьПолномочияВКлассификатор(Классификатор, ПолномочияФТС, НаименованиеГруппы);
	
КонецПроцедуры

Процедура ДобавитьПолномочияВКлассификатор(Классификатор, ДобавляемыеПолномочия, НаименованиеГруппы)
	
	Для Каждого ДобавляемоеПолномочие Из ДобавляемыеПолномочия Цикл
		Код = ДобавляемоеПолномочие.Значение;
		Наименование = ДобавляемоеПолномочие.Представление;
		
		Если Классификатор.Строки.Найти(Код, "Код", Истина) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
	
		Группа = Классификатор.Строки.Найти(НаименованиеГруппы, "Наименование", Ложь);
		
		Если Группа = Неопределено Тогда
			Группа = Классификатор.Строки.Добавить();
			Группа.Код = НаименованиеГруппы;
			Группа.Наименование = НаименованиеГруппы;
		КонецЕсли;
		
		Полномочие = Группа.Строки.Добавить();
		Полномочие.Код = Код;
		Полномочие.Наименование = Наименование;
	КонецЦикла;
	
КонецПроцедуры

Функция НаименованиеГруппыДляВзаимодействияСБанкомРоссии()
	
	Возврат "Для взаимодействия с Банком России"; // АПК:1297 не локализуется, поставляется в классификаторе полномочий.
	
КонецФункции

Процедура УстановитьРасписаниеРегламентногоЗадания() Экспорт
	
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
	Задержка = ГенераторСлучайныхЧисел.СлучайноеЧисло(1, 24*60*60) - 1;
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ПериодПовтораДней = 7;
	Расписание.ВремяНачала = '00010101000000' + Задержка; // В любое время.
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 3600);
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 0);
	
	РегламентныеЗаданияСервер.УстановитьПараметрыРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ОбновлениеКлассификаторовМЧД, ПараметрыЗадания);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
