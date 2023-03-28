create database mails;

--CREATE TABLE message (
--	created TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
--	id VARCHAR NOT NULL,
--	int_id CHAR(16) NOT NULL,
--	str VARCHAR NOT NULL,
--	status BOOL,
--	CONSTRAINT message_id_pk PRIMARY KEY(id)
--);

--адаптирую таблицу под свою версию mysql. у меня оригинальная структура, описанная выше не создается.
create table message (
	id integer unsigned not null,
	created timestamp not null,
	int_id varchar(16) not null,
	str varchar(255) not null,
	status tinyint(1),
	primary key(id)
) engine=innodb default charset=utf8;

alter table message add key(created);
alter table message add key(int_id);

--снова адаптирую таблицу под свою версию mysql.
--CREATE TABLE log (
--	created TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
--	int_id CHAR(16) NOT NULL,
--	str VARCHAR,
--	address VARCHAR
--);

create table log (
	created timestamp not null,
	int_id varchar(16) not null,
	str varchar(255),
	address varchar(255) 
) engine=innodb default charset=utf8;

alter table log add key(address);

--полностью модифицируем базу данных для решения задач
alter table message drop primary key;

alter table message modify id varchar(255) not null default '';

alter table message add primary key(id);

alter table message change int_id int_id integer unsigned not null auto_increment;

alter table log modify int_id integer unsigned not null auto_increment primary key;

alter table log modify str text;

alter table message change int_id int_id varchar(16) not null;

drop table log;

create table log (
  created timestamp not null,
  int_id varchar(16) not null,
  str text,
  address varchar(255) DEFAULT NULL,
  key (address)
) engine=innodb default charset=utf8;
