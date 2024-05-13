﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИдентификаторВзаимодействия = Параметры.ИдентификаторВзаимодействия;
	ИдентификаторОбращения = Параметры.ИдентификаторОбращения;
	ТипВзаимодействия = Параметры.ТипВзаимодействия;
	Входящее = Параметры.Входящее;
	Если Параметры.Свойство("КодПользователя") 
		И ЗначениеЗаполнено(Параметры.КодПользователя) Тогда
		КодПользователя = Параметры.КодПользователя;
	Иначе
		КодПользователя = ИнформационныйЦентрСервер.КодПользователяДляДоступа();
	КонецЕсли;
	Просмотрено = Параметры.Просмотрено;
	
	ЗаполнитьВзаимодействие();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Просмотрено Тогда 
		Оповестить("ПросмотреноВзаимодействиеПоОбращению");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СодержаниеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ИнформационныйЦентрКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, Элемент.Документ);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ФайлыПредставление" Или Поле.Имя = "ФайлыКартинка" Тогда 
		Результат = ПолучитьИмяФайлаИАдресХранилищаФайла(Элемент.ТекущиеДанные.Идентификатор);
		ИнформационныйЦентрКлиент.ПолучитьФайлИзХранилища(Результат.АдресХранилища, Результат.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Ответить(Команда)
	
	ИнформационныйЦентрКлиент.ОткрытьФормуОтправкиСообщенияВСлужбуПоддержки(
		Ложь, ИдентификаторОбращения, КодПользователя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКОбращению(Команда)
	
	ИнформационныйЦентрКлиент.ОткрытьОбращениеВСлужбуПоддержки(ИдентификаторОбращения, КодПользователя);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВзаимодействие()
	
	Попытка
		ДанныеПоВзаимодействию = ПолучитьДанныеПоВзаимодействию();
		ЗаполнитьЭлементыФормы(ДанныеПоВзаимодействию);
	Исключение
		ТекстОшибки = ИнформационныйЦентрСлужебный.ПодробныйТекстОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВСлужбеПоддержки();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

// Получить данные по взаимодействию.
// 
// Возвращаемое значение:
//  ОбъектXDTO 
&НаСервере
Функция ПолучитьДанныеПоВзаимодействию()
	
	WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиСлужбыПоддержки();
	
	Результат = WSПрокси.getInteraction(КодПользователя, Строка(ИдентификаторВзаимодействия), 
		ТипВзаимодействия, Входящее);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьЭлементыФормы(ДанныеПоВзаимодействию)
	
	ЭтотОбъект.Заголовок = ДанныеПоВзаимодействию.Name;
	
	Если ДанныеПоВзаимодействию.Type = "PhoneCall" Тогда
		
		Элементы.Содержание.Видимость = Ложь;
		Элементы.Файлы.Видимость = Ложь;
		
		Возврат;
		
	КонецЕсли;
	
	HTMLТекст = ДанныеПоВзаимодействию.HTMLText;
	
	// Поместить во временное хранилище картинки
	Для Каждого ДД Из ДанныеПоВзаимодействию.HTMLFiles Цикл
		 
		Картинка = Новый Картинка(ДД.Data);
		АдресХранилища = ПоместитьВоВременноеХранилище(Картинка, УникальныйИдентификатор);
		HTMLТекст = СтрЗаменить(HTMLТекст, ДД.Name, АдресХранилища);
		
	КонецЦикла;
	
	Содержание = HTMLТекст;
	
	// Отображение файлов
	
	Файлы.Очистить();
	Элементы.Файлы.Видимость = (ДанныеПоВзаимодействию.Files.Количество() <> 0);
	
	Для Каждого ТекущийФайл Из ДанныеПоВзаимодействию.Files Цикл
		 
		НовыйЭлемент = Файлы.Добавить();
		НовыйЭлемент.Представление = ТекущийФайл.Name + "." + ТекущийФайл.Extension
			 + " (" + Окр(ТекущийФайл.Size / 1024, 2) + " " + НСтр("ru = 'Кб'") + ")";
		НовыйЭлемент.Картинка = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(
			ТекущийФайл.Extension);
		НовыйЭлемент.Идентификатор = Новый УникальныйИдентификатор(ТекущийФайл.Id);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяФайлаИАдресХранилищаФайла(ИдентификаторФайла)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("АдресХранилища", "");
	ВозвращаемоеЗначение.Вставить("ИмяФайла", "");
	
	Попытка
		
		WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиСлужбыПоддержки();
		Результат = WSПрокси.getInteractionFile(КодПользователя, Строка(ИдентификаторВзаимодействия), 
			Строка(ИдентификаторФайла), ТипВзаимодействия, Входящее);
		ВозвращаемоеЗначение.АдресХранилища = ПоместитьВоВременноеХранилище(Результат.Data, УникальныйИдентификатор);
		ВозвращаемоеЗначение.ИмяФайла = Результат.Name + "." + Результат.Extension;
		
	Исключение
		
		ТекстОшибки = ИнформационныйЦентрСлужебный.ПодробныйТекстОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВСлужбеПоддержки();
		
		ВызватьИсключение ТекстВывода;
		
	КонецПопытки;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти