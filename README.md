# Allure-helper

Помощник для работы с фреймворком [Allure](https://github.com/allure-framework/allure2) в gitlab.


## Доступные команды и их опции.

* --categories
  * `--path` путь к каталогу с результатами тестов
  * `--name` имя категории результатов тестов (Опционально)
  
На выходе формирует файл categories.json

```cmd
> allurehelper categories --path ./out/allure-results/bdd
```

В каталоге `bdd` будет создан файл с именем `categories.json`

```json
[
	{
		"name": "bdd"
	}
]
```

* --environment
  * `--path`
  * `--v8version`
  * `--oscriptversion`
  * `--vrunnerVersion`
  * `--addversion`
  * `--VAVersion`
  * `--os` Пока только для windows
  * `--sha`
  * `--branch`
  * `--repoUrl`
  
На выходе формирует файл environment.properties.
Создается и заполняется для каждого типа тестов.

```cmd
> allurehelper env --path ./out/allure-results/bdd --v8version 8.3.20 --os --oscriptversion --vrunenrVersion --add 6.8.0 --sha 2ab7144c --branch main --repoUrl https://gitlabexample.com/onec/ssl31
```

В каталоге `bdd` будет создан файл `environment.properties`

```properties
v8version=8.3.20
os=10.0.22000.856
oscriptversion=1.7.0.214
vrunenrVersion=1.11.11
add=6.8.0
sha=2ab7144c
branch=main
repoUrl=https://gitlabexample.com/onec/ssl31

```


* --history
  * --`allureresults`
  * --`apiurl`
  * --`token`
  * --`id`
  * --`scope`

  
Вытягивает артефакт из последнего успешного задания `pages` опубликованный ранее отчет в формате Allure.

```cmd
> allurehelper history --allureresults ./out/allure-results --apiurl %CI_API_V4_URL% --token %CI_DEPLOY_TOKEN% --id %CI_PROJECT_ID%  --scope success
```

* --executors
  * `--path` путь к каталогу с результатами тестов (корневой)
  * `--name` = "Gitlab"
  * `--type` = "Gitlab CI"
  * `--url` = $ci_server_url
  * `--buildOrder` = $ci_pipeline_id
  * `--buildName` = "allure-report#"+$ci_pipeline_id #или прокинуть сюда CI_COMMIT_TITLE для наглядности
  * `--buildUrl` = $ci_pipeline_url
  * `--reportUrl` = $ci_pages_url

```cmd
>allurehelper executors --path ./out/allure-results --name Gitlab --type GitlabCI --url https://gitlabexample.com --buildOrder 522 --buildName 2ab7144c --buildUrl https://gitlabexample.com/onec/ssl31/-/pipelines/522 --reportUrl https://onec.gitlabexampe.com/ssl31
```

```json
[
	{
		"name": "Gitlab",
		"type": "GitlabCI",
		"url": "https://gitlabexample.com",
		"buildOrder": "522",
		"buildName": "2ab7144c",
		"buildUrl": "https://gitlabexample.com/onec/ssl31/-/pipelines/522",
		"reportUrl": "https://onec.gitlabexampe.com/ssl31"
	},
	{
		"name": "Gitlab",
		"type": "Gitlab CI",
		"url": "https://gitlabexample.com",
		"buildOrder": 521,
		"buildName": "allure-report#521",
		"buildUrl": "https://gitlabexample.com/onec/ssl31/-/pipelines/pipelines/521",
		"reportUrl": "https://onec.gitlabexampe.com/ssl31"
	}
]
```

По умолчанию скачивается вместе с каталогом history.
На выходе формирует файл или добавляет данные в файл executors.json
