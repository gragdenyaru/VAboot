﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
	
	Если ЗначениеЗаполнено(Параметры.УзелИнформационнойБазы) Тогда
		ОбщиеПараметрыСинхронизацииСтрокой = ОбменДаннымиСервер.ОписаниеПравилСинхронизацииДанных(Параметры.УзелИнформационнойБазы);
		НаименованиеУзла = Строка(Параметры.УзелИнформационнойБазы);
	Иначе
		НаименованиеУзла = "";
	КонецЕсли;
	
	Заголовок = СтрЗаменить(Заголовок, "%1", НаименованиеУзла);
	
КонецПроцедуры

#КонецОбласти
