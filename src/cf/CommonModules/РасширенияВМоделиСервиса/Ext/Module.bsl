﻿
#Область ПрограммныйИнтерфейс

// Устарела, в составе конфигурации нет вызовов. Рекомендуется отказаться от использования в прикладном коде.
// Возвращает поставляемое расширение, соответствующее используемому расширению.
//
// Параметры:
//	ИдентификаторИспользуемогоРасширения - УникальныйИдентификатор - идентификатор расширения.
//
// Возвращаемое значение:
//	СправочникСсылка.ПоставляемыеРасширения - ссылка на поставляемое расширение
//
Функция ПоставляемоеРасширение(ИдентификаторИспользуемогоРасширения) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Заполняет массив списком имен объектов метаданных, данные которых могут содержать ссылки на различные объекты метаданных,
// но при этом эти ссылки не должны учитываться в бизнес-логике приложения.
//
// Параметры:
//  Массив - Массив Из Строка - например "РегистрСведений.ВерсииОбъектов".
//
Процедура ПриДобавленииИсключенийПоискаСсылок(Массив) Экспорт
	
	Массив.Добавить(Метаданные.РегистрыСведений.ИспользованиеПоставляемыхРасширенийВОбластяхДанных.ПолноеИмя());
	
КонецПроцедуры

// См. РаботаВМоделиСервисаПереопределяемый.ПриЗаполненииТаблицыПараметровИБ
// 
// Параметры:
//	ТаблицаПараметров - см. РаботаВМоделиСервиса.ПараметрыИБ
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ИспользованиеКаталогаРасширенийВМоделиСервиса");
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ИспользоватьПрофилиБезопасностиДляРасширений");
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "НезависимоеИспользованиеРасширенийВМоделиСервиса");
	
КонецПроцедуры

// См. РаботаВМоделиСервисаПереопределяемый.ПриУстановкеЗначенийПараметровИБ.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриУстановкеЗначенийПараметровИБ(Знач ЗначенияПараметров) Экспорт
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиПринимаемыхСообщений.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	МассивОбработчиков - Массив Из ОбщийМодуль - обработчики.
//
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиОтправляемыхСообщений.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	МассивОбработчиков - Массив Из ОбщийМодуль - обработчики.
//
Процедура РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков) Экспорт	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт	
КонецПроцедуры

// См. ПоставляемыеДанныеПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	Обработчики - см. ПоставляемыеДанныеПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных.Обработчики
//
Процедура ПриОпределенииОбработчиковПоставляемыхДанных(Обработчики) Экспорт
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// 
// Параметры:
// 	Типы - См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
// 
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ИспользованиеПоставляемыхРасширенийВОбластяхДанных);
	Типы.Добавить(Метаданные.РегистрыСведений.ОчередьИнсталляцииПоставляемыхРасширенийВОбластиДанных);
	Типы.Добавить(Метаданные.РегистрыСведений.ОчередьРасширенийДляОповещений);
	Типы.Добавить(Метаданные.РегистрыСведений.ОчередьОбновляемыхПоставляемыхРасширенийВОбластяхДанных);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает информацию о расширениях, зарегистрированных в регистре ИспользованиеПоставляемыхРасширенийВОбластяхДанных
// для текущей области данных.
//
// Возвращаемое значение:
//	Неопределено, ТаблицаЗначений - поля:
//		* ПоставляемоеРасширение - СправочникСсылка.ПоставляемыеРасширения
//		* ИспользуемоеРасширение - УникальныйИдентификатор
//		* Инсталляция - УникальныйИдентификатор
//		* Отключено - Булево - см. Справочник.ПоставляемыеРасширения
//		* ПричинаОтключения - ПеречислениеСсылка.ПричиныОтключенияРасширенийВМоделиСервиса - см. Справочник.ПоставляемыеРасширения
//		* Наименование - Строка - см. Справочник.ПоставляемыеРасширения
//		* ИдентификаторВерсии - УникальныйИдентификатор - см. РегистрСведений.ИспользованиеПоставляемыхРасширенийВОбластяхДанных.
//
Функция РасширенияТекущейОбластиДанных() Экспорт

	Возврат Неопределено;

КонецФункции // РасширенияТекущейОбластиДанных()

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
КонецПроцедуры

// Есть установленные расширения изменяющие структуру данных.
// 
// Возвращаемое значение:
// 	Булево - Факт наличия установленных расширений изменяющих структуру данных
Функция ЕстьУстановленныеРасширенияИзменяющиеСтруктуруДанных() Экспорт 
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	ЕстьУстановленныеРасширения = Ложь;
	
	РасширенияОбласти = РасширенияКонфигурации.Получить();
	Для Каждого РасширениеОбласти Из РасширенияОбласти Цикл
		
		Если РазделениеВключено 
			И РасширениеОбласти.ОбластьДействия <> ОбластьДействияРасширенияКонфигурации.РазделениеДанных Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьУстановленныеРасширения = Макс(
			ЕстьУстановленныеРасширения, 
			РасширениеОбласти.ИзменяетСтруктуруДанных());
		
	КонецЦикла;
	
	Возврат ЕстьУстановленныеРасширения;
	
КонецФункции

#КонецОбласти