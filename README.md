# README

## Subindo o container Docker

Para iniciar o ambiente da aplicação usando Docker Compose, execute:

```sh
docker-compose up
```

Para rodar em segundo plano (modo detached):

```sh
docker-compose up -d
```

## Parando/derrubando os containers

Para parar os containers:

```sh
docker-compose down
```

## Acessando o console do Rails (rails c)

Para acessar o console do Rails dentro do container:

```sh
docker-compose exec app rails c
```

## Criando e migrando o banco de dados

Para criar o banco de dados:

```sh
docker-compose exec app rails db:create
```

Para rodar as migrações:

```sh
docker-compose exec app rails db:migrate
```

## Outros comandos úteis

- Para acessar o bash do container:

  ```sh
  docker-compose exec app bash
  ```

- Para ver os logs em tempo real:

  ```sh
  docker-compose logs -f app
  ```

