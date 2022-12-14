#Использовать fs
#Использовать strings
#Использовать json

Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("path", "", "Путь куда будет сохранен файл")
	.ТСтрока()
	.Обязательный(Истина);
	
	Команда.Опция("name", "", "Имя категории тестов. Если не указан, 
		|	имя категории будет соответствовать последнему каталогу из пути")
	.ТСтрока()
	.Обязательный(Ложь);
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	ПутьКРезультатам = СокрЛП(Команда.ЗначениеОпции("path"));
	ИмяКатегории = СокрЛП(Команда.ЗначениеОпции("name"));
	
	Если НЕ ФС.КаталогСуществует(ПутьКРезультатам) Тогда
		ФС.ОбеспечитьКаталог(ПутьКРезультатам);
	КонецЕсли;

	ПутьКФайлу = ФС.ОбъединитьПути(ПутьКРезультатам, "categories.json");

	Если НЕ ЗначениеЗаполнено(ИмяКатегории) Тогда
		МассивСтрок = СтроковыеФункции.РазложитьСтрокуВМассивСлов(ПутьКРезультатам, "/\");
		Если МассивСтрок.Количество() = 0 Тогда
			ВызватьИсключение "Не удалось получить каталоги из пути";
		КонецЕсли;
		ИмяКатегории = МассивСтрок[МассивСтрок.Количество() - 1];
	КонецЕсли;

	СоздатьФайл(ПутьКФайлу, ИмяКатегории);
	
КонецПроцедуры

Процедура СоздатьФайл(Знач ПутьКФайлу, Знач ИмяКатегории)
	ПарсерJson = Новый ПарсерJSON();

	ДанныеДляСохранения = "[{""name"":""%1""}]";

	ДанныеДляСохранения = СтрЗаменить(ДанныеДляСохранения, "%1", ИмяКатегории);
	
	ДанныеДляСохранения = ПарсерJSON.ПрочитатьJSON(ДанныеДляСохранения);

	Запись = Новый ЗаписьJSON();
	
	Запись.ОткрытьФайл(ПутьКФайлу, , , Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Unix, Символы.Таб));
	
	Попытка
		ЗаписатьJSON(Запись, ДанныеДляСохранения);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Запись.Закрыть();
	
КонецПроцедуры