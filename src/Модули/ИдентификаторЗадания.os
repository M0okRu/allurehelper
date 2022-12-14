#Использовать 1connector

Перем ТаблицаЗаданий;
Перем Айди;

Функция ПолучитьАйдиССайта(Параметры) Экспорт
	
	Результат = ВыполнитьЗапрос(Параметры);

	ЭлементМассива = Результат[0];
	
	ЗаполнитьКолонкиТаблицы(ЭлементМассива);
	
	Для Каждого Элемент Из Результат Цикл
		НоваяСтрока = ТаблицаЗаданий.Добавить();
		Для Каждого КлючИЗначение Из Элемент Цикл
			Если ПроверкаКлюча(КлючИЗначение.Ключ) Тогда				
				НоваяСтрока[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаЗаданий.Сортировать("id Убыв");

	МассивСтраниц = ТаблицаЗаданий.НайтиСтроки(Новый Структура("name", "pages"));
	
	Айди = МассивСтраниц[0].id;

	Возврат Айди;
	
КонецФункции

Функция ВыполнитьЗапрос(Знач Параметры)
	
	Если Параметры.Свойство("apiurl") Тогда
		АпиУрл = Параметры.apiurl;
	КонецЕсли;
	Если Параметры.Свойство("id") Тогда
		ПроектИД = Параметры.id;
	КонецЕсли;
	Если Параметры.Свойство("token") Тогда
		Токен = Параметры.token;
	КонецЕсли;
	Если Параметры.Свойство("scope") Тогда
		СтатусФильтр = Параметры.scope;
	КонецЕсли;
	
	УРЛ = СобратьУРЛ(АпиУрл, ПроектИД, СтатусФильтр);
	
	Заголовки = ЗаголовкиHTTP(Токен);
	
	Результат = КоннекторHTTP.Get(УРЛ, , Новый Структура("Заголовки", Заголовки)).Json();
	
	Если ТипЗнч(Результат) <> Тип("Массив") Тогда
		ВызватьИсключение "Упс.. Что-то пошло не так. Должен был вернуться массив.";
	КонецЕсли;
	
	Если Результат.Количество() = 0 Тогда
		ВызватьИсключение "Вот теперь точно, что-то пошло не так.";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СобратьУРЛ(Знач АпиУрл, Знач ПроектИД, Знач СтатусФильтр = Неопределено, Знач Айди = Неопределено) Экспорт
	Если Айди = Неопределено Тогда
		Если ТипЗнч(СтатусФильтр) = Тип("Массив") И СтатусФильтр.Количество() > 0 Тогда
			ПараметрФильтра = ДополнитьУрлСтатусФильтрами(СтатусФильтр);
		КонецЕсли;
		
		УРЛ = АпиУРЛ + "/projects/" + ПроектИД + "/jobs?scope[]=" + СтатусФильтр;
	Иначе
		УРЛ = АпиУРЛ + "/projects/" + ПроектИД + "/jobs/" + Айди + "/artifacts";
	КонецЕсли;
	Возврат УРЛ;
КонецФункции

Функция ДополнитьУрлСтатусФильтрами(Знач СтатусФильтр)

	ПараметрФильтра = "&scope[]=";

	Для Каждого Элемент Из СтатусФильтр Цикл
		ПараметрФильтра = ПараметрФильтра + СокрЛП(Элемент);
	КонецЦикла;

	Возврат ПараметрФильтра;
КонецФункции

Функция ЗаголовкиHTTP(Знач Токен) Экспорт
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("PRIVATE-TOKEN", Токен);
	Возврат Заголовки;
КонецФункции

Процедура ЗаполнитьКолонкиТаблицы(Знач ЭлементМассива)
	
	ТаблицаЗаданий = Новый ТаблицаЗначений();
	
	Для Каждого КлючИЗначение Из ЭлементМассива Цикл
		
		Если ПроверкаКлюча(КлючИЗначение.Ключ) Тогда
			
			ТаблицаЗаданий.Колонки.Добавить(
				СокрЛП(КлючИЗначение.Ключ),
				Новый ОписаниеТипов(СокрЛП(ТипЗнч(КлючИЗначение.Значение))));
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверкаКлюча(Знач Ключ)
	
	Возврат Ключ = "id"
			ИЛИ Ключ = "name"
				ИЛИ Ключ = "stage"
					ИЛИ Ключ = "status";
	
КонецФункции