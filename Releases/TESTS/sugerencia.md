Aquí hay una lista completa de los comandos de PostgreSQL más utilizados para la gestión de bases de datos, junto con una breve descripción y un ejemplo de su uso:

1. `createdb`: crea una nueva base de datos.

Ejemplo: `createdb mydatabase`

2. `dropdb`: elimina una base de datos existente.

Ejemplo: `dropdb mydatabase`

3. `pg_dump`: realiza una copia de seguridad de una base de datos.

Ejemplo: `pg_dump mydatabase > backup.sql`

4. `pg_restore`: restaura una base de datos a partir de un archivo de copia de seguridad.

Ejemplo: `pg_restore -d mydatabase backup.sql`

5. `pg_ctl`: controla el servidor PostgreSQL.

Ejemplo: `pg_ctl start -D "C:\Program Files\PostgreSQL\9.6\data"`

6. `psql`: inicia una sesión interactiva con una base de datos.

Ejemplo: `psql mydatabase`

7. `createuser`: crea un nuevo usuario de PostgreSQL.

Ejemplo: `createuser myuser`

8. `dropuser`: elimina un usuario de PostgreSQL existente.

Ejemplo: `dropuser myuser`

9. `grant`: otorga permisos a un usuario en una base de datos.

Ejemplo: `grant all privileges on database mydatabase to myuser`

10. `revoke`: revoca permisos a un usuario en una base de datos.

Ejemplo: `revoke all privileges on database mydatabase from myuser`

11. `create table`: crea una nueva tabla en una base de datos.

Ejemplo: 

```
create table mytable (
    id serial primary key,
    name varchar(50) not null,
    age integer not null
);
```

12. `alter table`: modifica una tabla existente en una base de datos.

Ejemplo: 

```
alter table mytable add column email varchar(100);
```

13. `drop table`: elimina una tabla existente en una base de datos.

Ejemplo: 

```
drop table mytable;
```

14. `insert into`: inserta nuevos registros en una tabla existente en una base de datos.

Ejemplo: 

```
insert into mytable (name, age, email) values ('John Doe', 30, 'john.doe@example.com');
```

15. `update`: actualiza registros existentes en una tabla en una base de datos.

Ejemplo: 

```
update mytable set age = 31 where name = 'John Doe';
```

16. `delete from`: elimina registros existentes en una tabla en una base de datos.

Ejemplo: 

```
delete from mytable where name = 'John Doe';
```

17. `select`: recupera información de una o varias tablas en una base de datos.

Ejemplo: 

```
select * from mytable where age > 25;
```

Estos son solo algunos de los comandos más comunes utilizados para la gestión de bases de datos en PostgreSQL. Hay muchos más comandos disponibles, y cada uno tiene varias opciones y argumentos que se pueden utilizar para personalizar su comportamiento. Si necesita ayuda para utilizar alguno de estos comandos o para realizar una tarea específica en PostgreSQL, no dude en preguntar.