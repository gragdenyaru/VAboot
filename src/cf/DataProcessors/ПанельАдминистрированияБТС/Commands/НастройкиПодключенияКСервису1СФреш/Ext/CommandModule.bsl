﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура;
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБТС.Форма.НастройкиПодключенияКСервису1СФреш", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияБТС.Форма.НастройкиПодключенияКСервису1СФреш" 
			+ ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
