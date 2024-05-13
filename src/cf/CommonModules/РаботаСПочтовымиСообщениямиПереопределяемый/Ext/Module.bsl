﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет настройки подсистемы.
//
// Параметры:
//  Настройки - Структура:
//   * ДоступноПолучениеПисем - Булево - показывать настройки получения писем в учетных записях.
//                                       Значение по умолчанию: для базовых версий конфигурации - Ложь,
//                                       для остальных - Истина.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

// Позволяет выполнить дополнительные операции после отправки почтового сообщения.
//
// Параметры:
//  ПараметрыПисьма - Структура - содержит всю необходимую информацию о письме:
//   * Кому      - Массив - (обязательный) интернет-адрес получателя письма.
//                 Адрес         - строка - почтовый адрес.
//                 Представление - строка - имя адресата.
//
//   * ПолучателиСообщения - Массив - массив структур, описывающий получателей:
//                            * ИсточникКонтактнойИнформации - СправочникСсылка - владелец контактной информации.
//                            * Адрес - Строка - почтовый адрес получателя сообщения.
//                            * Представление - Строка - представление адресата.
//
//   * Копии      - Массив - коллекция структур адресов:
//                   * Адрес         - Строка - почтовый адрес (должно быть обязательно заполнено).
//                   * Представление - Строка - имя адресата.
//                  
//                - Строка - интернет-адреса получателей письма, разделитель - ";".
//
//   * СкрытыеКопии - Массив
//                  - Строка - см. описание поля Копии.
//
//   * Тема       - Строка - (обязательный) тема почтового сообщения.
//   * Тело       - Строка - (обязательный) текст почтового сообщения (простой текст в кодировке win-1251).
//   * Важность   - ВажностьИнтернетПочтовогоСообщения.
//   * Вложения   - Соответствие из КлючИЗначение:
//                   * ключ     - Строка - наименование вложения
//                   * значение - ДвоичныеДанные
//                              - Строка - адрес во временном хранилище двоичных данных вложения;
//                              - Структура:
//                                 * ДвоичныеДанные - ДвоичныеДанные - двоичные данные вложения.
//                                 * Идентификатор  - Строка - идентификатор вложения, используется для хранения картинок,
//                                                             отображаемых в теле письма.
//
//   * АдресОтвета - Соответствие - см. описание поля Кому.
//   * Пароль      - Строка - пароль для доступа к почте.
//   * ИдентификаторыОснований - Строка - идентификаторы оснований данного письма.
//   * ОбрабатыватьТексты  - Булево - необходимость обрабатывать тексты письма при отправке.
//   * УведомитьОДоставке  - Булево - необходимость запроса уведомления о доставке.
//   * УведомитьОПрочтении - Булево - необходимость запроса уведомления о прочтении.
//   * ТипТекста   - Строка
//                 - ПеречислениеСсылка.ТипыТекстовЭлектронныхПисем
//                 - ТипТекстаПочтовогоСообщения - определяет тип
//                  переданного теста допустимые значения:
//                  HTML/ТипыТекстовЭлектронныхПисем.HTML - текст почтового сообщения в формате HTML;
//                  ПростойТекст/ТипыТекстовЭлектронныхПисем.ПростойТекст - простой текст почтового сообщения.
//                                                 Отображается "как есть" (значение по
//                                                 умолчанию);
//                  РазмеченныйТекст/ТипыТекстовЭлектронныхПисем.РазмеченныйТекст - текст почтового сообщения в формате
//                                                 Rich Text.
//
Процедура ПослеОтправкиПисьма(ПараметрыПисьма) Экспорт
	
	// _Демо начало примера
	
	// Добавление введенного вручную адреса электронной почты в контактную информацию партнера.
	
	Если Не ПараметрыПисьма.Свойство("ПолучателиСообщения") Или Не ПараметрыПисьма.Свойство("Кому") Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПисьма.ПолучателиСообщения.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	
	Ссылка = ПараметрыПисьма.ПолучателиСообщения[0].ИсточникКонтактнойИнформации;
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка._ДемоПартнеры") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники._ДемоПартнеры) Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Ссылка.Метаданные().ПолноеИмя());
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
		Блокировка.Заблокировать();
		
		Объект = Ссылка.ПолучитьОбъект(); // СправочникОбъект._ДемоПартнеры
		ОбъектМодифицирован = Ложь;
		Для Каждого Адресат Из ПараметрыПисьма.Кому Цикл
			ЗначениеЭлектроннойПочты = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Адресат.Адрес, УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоEmailПартнера"));
			УправлениеКонтактнойИнформацией.ЗаписатьКонтактнуюИнформацию(Объект, ЗначениеЭлектроннойПочты,
				УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("_ДемоEmailПартнера"), Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
			ОбъектМодифицирован = Истина;
		КонецЦикла;
		
		Если ОбъектМодифицирован Тогда
			Объект.Записать();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Работа с почтовыми сообщениями.После отправки письма'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, Ссылка.Метаданные(), Ссылка, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		// Вызов исключения не требуется, так как выполняется запись второстепенных данных.
	КонецПопытки;
	
	// _Демо конец примера
	
КонецПроцедуры

// Определяет список писем, для которых необходимо получить статус доставки/прочтения.
// Пример определения списка писем см. в РассылкаОтчетов.ПередПолучениемСтатусовПисем
//
//   Параметры:
//  ИдентификаторыПисем - ТаблицаЗначений:
//   * Отправитель - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
//   * ИдентификаторПисьма - Строка
//   * АдресПолучателя - Строка - электронная почта получателя письма
//
Процедура ПередПолучениемСтатусовПисем(ИдентификаторыПисем) Экспорт
	
КонецПроцедуры

// Возвращает сведения только об известных статусах доставки (если были получены соответствующие письма).
// Пример обработки полученных статусов писем см. в РассылкаОтчетов.ПослеПолученияСтатусовПисем
//
// Параметры:
//  СтатусыДоставки - ТаблицаЗначений:
//   * Отправитель - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
//   * ИдентификаторПисьма - Строка 
//   * АдресПолучателя - Строка - электронная почта получателя письма
//   * Статус - ПеречислениеСсылка.СтатусыЭлектронныхПисем 
//   * ДатаИзмененияСтатуса - Дата
//   * Причина - Строка - причина недоставки письма
//
Процедура ПослеПолученияСтатусовПисем(СтатусыДоставки) Экспорт
	
КонецПроцедуры

#КонецОбласти
