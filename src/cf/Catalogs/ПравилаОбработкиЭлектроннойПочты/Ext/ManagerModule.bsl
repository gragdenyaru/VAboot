﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Код");
	Результат.Добавить("Наименование");
	Результат.Добавить("КомпоновщикНастроек");
	Результат.Добавить("ПомещатьВПапку");
	Результат.Добавить("РеквизитДопУпорядочивания");
	Результат.Добавить("ПредставлениеОтбора");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)
	|	ИЛИ ЗначениеРазрешено(Владелец.ВладелецУчетнойЗаписи, ПустаяСсылка КАК Ложь)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Применяет правила обработки писем.
//
// Параметры:
//  ПараметрыВыгрузки  - Структура:
//    * ДляПисемВПапке     - СправочникСсылка.ПапкиЭлектронныхПисем - письма, которые находятся в этой папке будут обработаны.
//    * ВключаяПодчиненные - Булево - признак, того что должны обрабатываться письма в подчиненных папках.
//    * ТаблицаПравил      - ТаблицаЗначений - таблица правил, которые должны быть применены.
//  АдресХранилища - Строка - сообщение о результате применения правил.
//
Процедура ПрименитьПравила(ПараметрыВыгрузки, АдресХранилища) Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВыбранныеПравила.Правило,
		|	ВыбранныеПравила.Применять
		|ПОМЕСТИТЬ ВыбранныеПравила
		|ИЗ
		|	&ВыбранныеПравила КАК ВыбранныеПравила
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВыбранныеПравила.Правило КАК Ссылка,
		|	ПравилаОбработкиЭлектроннойПочты.Владелец КАК УчетнаяЗапись,
		|	ПравилаОбработкиЭлектроннойПочты.Наименование КАК НаименованиеПравила,
		|	ПравилаОбработкиЭлектроннойПочты.КомпоновщикНастроек,
		|	ПравилаОбработкиЭлектроннойПочты.ПомещатьВПапку
		|ИЗ
		|	ВыбранныеПравила КАК ВыбранныеПравила
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПравилаОбработкиЭлектроннойПочты КАК ПравилаОбработкиЭлектроннойПочты
		|		ПО ВыбранныеПравила.Правило = ПравилаОбработкиЭлектроннойПочты.Ссылка
		|ГДЕ
		|	ВыбранныеПравила.Применять
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЭлектронноеПисьмоВходящее.Ссылка,
		|	ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма КАК Папка
		|ИЗ
		|	Документ.ЭлектронноеПисьмоВходящее КАК ЭлектронноеПисьмоВходящее
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|		ПО ПредметыПапкиВзаимодействий.Взаимодействие = ЭлектронноеПисьмоВходящее.Ссылка
		|ГДЕ
		|	&УсловиеПоПапке
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЭлектронноеПисьмоИсходящее.Ссылка,
		|	ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма
		|ИЗ
		|	Документ.ЭлектронноеПисьмоИсходящее КАК ЭлектронноеПисьмоИсходящее
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|		ПО ПредметыПапкиВзаимодействий.Взаимодействие = ЭлектронноеПисьмоИсходящее.Ссылка
		|ГДЕ
		|	&УсловиеПоПапке");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоПапке", 
		?(ПараметрыВыгрузки.ВключаяПодчиненные, 
			"ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма В ИЕРАРХИИ(&ПапкаЭлектронногоПисьма)", 
			"ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма = &ПапкаЭлектронногоПисьма"));
	Запрос.УстановитьПараметр("ВыбранныеПравила", ПараметрыВыгрузки.ТаблицаПравил);
	Запрос.УстановитьПараметр("ПапкаЭлектронногоПисьма", ПараметрыВыгрузки.ДляПисемВПапке);
	
	Результат = Запрос.ВыполнитьПакет();
	Если Результат[2].Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В выбранной папке нет писем.'");
		ПоместитьВоВременноеХранилище(ТекстСообщения, АдресХранилища);
		Возврат;
	КонецЕсли;
	
	ТаблицаПисем = Результат[2].Выгрузить();
	ОбрабатываемыеПисьма = ТаблицаПисем.ВыгрузитьКолонку("Ссылка");
	ОбрабатываемыеПапки = ТаблицаПисем.ВыгрузитьКолонку("Папка");
	ОбрабатываемыеПапки = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ОбрабатываемыеПапки);
	
	ПапкиПисем = Новый ТаблицаЗначений;
	ПапкиПисем.Колонки.Добавить("Папка");
	ПапкиПисем.Колонки.Добавить("Письмо");
	
	ВыбранноеПравило = Результат[1].Выбрать();
	Пока ВыбранноеПравило.Следующий() Цикл
		
		Попытка
			СхемаПравилаОбработки = ПолучитьМакет("СхемаПравилаОбработкиЭлектроннойПочты");
			
			КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
			КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
			КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаПравилаОбработки));
			КомпоновщикНастроек.ЗагрузитьНастройки(ВыбранноеПравило.КомпоновщикНастроек.Получить());
			КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КомпоновщикНастроек.Настройки.Отбор,
				"Ссылка", ОбрабатываемыеПисьма, ВидСравненияКомпоновкиДанных.ВСписке);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КомпоновщикНастроек.Настройки.Отбор,
				"Ссылка.УчетнаяЗапись", ПараметрыВыгрузки.УчетнаяЗапись, ВидСравненияКомпоновкиДанных.Равно);
			
			МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаПравилаОбработки,
				КомпоновщикНастроек.ПолучитьНастройки(),,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
			
			ТекстЗапроса = МакетКомпоновкиДанных.НаборыДанных.ОсновнойНаборДанных.Запрос;
			ЗапросПравило = Новый Запрос(ТекстЗапроса);
			Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
				ЗапросПравило.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
			КонецЦикла;
			
			// @skip-check query-in-loop - Порционная обработка писем по учетным записям.
			РезультатПисьма = ЗапросПравило.Выполнить();
		
		Исключение
			
			ШаблонСообщенияОбОшибке = НСтр("ru = 'Не удалось применить правило обработки писем ""%1"" для электронной почты ""%2"" по причине: 
			                                |%3
			                                |Требуется исправить правило.'", ОбщегоНазначения.КодОсновногоЯзыка());
		
			ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщенияОбОшибке, 
				ВыбранноеПравило.НаименованиеПравила,
				ВыбранноеПравило.УчетнаяЗапись,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(УправлениеЭлектроннойПочтой.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка, , ВыбранноеПравило.Ссылка, ТекстСообщенияОбОшибке);
			Продолжить;
			
		КонецПопытки;
		
		Если Не РезультатПисьма.Пустой() Тогда
			ВыбранноеПисьмо = РезультатПисьма.Выбрать();
			Пока ВыбранноеПисьмо.Следующий() Цикл
				
				НоваяСтрокаТаблицы = ПапкиПисем.Добавить();
				НоваяСтрокаТаблицы.Папка = ВыбранноеПравило.ПомещатьВПапку;
				НоваяСтрокаТаблицы.Письмо = ВыбранноеПисьмо.Ссылка;
				
				Индекс = ОбрабатываемыеПисьма.Найти(ВыбранноеПисьмо.Ссылка);
				Если Индекс <> Неопределено Тогда
					ОбрабатываемыеПисьма.Удалить(Индекс);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Взаимодействия.УстановитьПапкиЭлектронныхПисем(ПапкиПисем, Ложь);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ОбрабатываемыеПапки, ПапкиПисем.ВыгрузитьКолонку("Папка"), Истина);
	Взаимодействия.РассчитатьРассмотреноПоПапкам(Взаимодействия.ТаблицаДанныхДляРасчетаРассмотрено(ОбрабатываемыеПапки, "Папка"));
	
	Если ПапкиПисем.Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru = 'Перенос писем в папки выполнен.'");
	Иначе
		ТекстСообщения =  НСтр("ru = 'Ни одно письмо не было перенесено.'");
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ТекстСообщения, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
