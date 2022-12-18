## Импортирование ресурсов, созданных вручную.


### Концепция
1. Создать ресурс вручную на сайте провайдера
2. Создать в директории проекта файл terraform с минимальным шаблоном ресурса
3. Выполнить импортирование ресурса командой `terraform init <resource.name> <id.resource>`. Ресурс будет занесен в state.
4. В state взять обязаьельные параметры ресурса и перенести их в шаблон ресурса в файле terraform
5. Выполнить `terraform apply`
6. Полученные ошибки устранить добавлением обязательных (Required) полей в шаблон ресурса. Смотреть в документации ресурса
7. Добиться того, что при запуске `terraform apply` будет сообщение `o add, 0 changed, 0 destroyed`
8. Результат: наше ресурс перешел под управление terraform. Теерь можно добавлять в шаблон другие аргументы.