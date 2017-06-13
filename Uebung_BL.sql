create table customer
(
	customer_id		int		not null primary key,
	first_name		varchar(20) NOT NULL,
	credit			decimal(10,2)
);
commit;

create table sales
(
	customer_id		int,
	product_id		int,
	sales_date		date,
	pieces			int
);
commit;

create table product
(
	product_id int not null primary key,
	product_name	varchar(20) not null,
	product_price	decimal(6,2) not null
);
commit;

create table stock
(
	product_id	int,
	shelf		char(2) not null,
	pieces		int
);
commit;

alter table stock
add constraint const_pk_stock primary key (product_id, shelf);

alter table sales
add constraint const_pk_sales primary key (customer_id, product_id, sales_date);

alter table stock
add (constraint const_fk_stock foreign key (product_id)
references product (product_id));

alter table sales
add (constraint const_fk_customer_sales foreign key (customer_id)
references customer (customer_id))
add (constraint const_fk_product_sales foreign key (product_id)
references product (product_id));


--sequence
create sequence seq_customer_id
	start with		1000
	increment by	1
	cache			20;
commit;

create or replace procedure
proc_new_customer (customer_id	int	 not null primary key,
				   first_name	varchar(20) not null,
				   credit		decimal(10,2)) is
begin
  select seq_customer_id.nextval into customer_id
	from dual;
  
  IF credit is null then
    select -100 into credit
    from   dual;
  end if
  
  insert into customer values (customer_id, first_name, credit);
end proc_new_customer;

--TRIGGER
create or replace trigger trg_customer_credit
before insert or update on customer
referencing new as newRow old as oldRow
for each row
declare
	ex_credit_limit exception;
begin
	if (inserting) then
		select seq_customer_id.nextval into :newRow.customer_id
		from dual;
		if (:newRow.credit < 0) then
			raise_application_error (-20999, 'Credit ist unter 0!');
		end if;
	end if;
	exception
		when ex_credit_limit then
			dbms_output.put_line('Fehler!!!!');
			dbms_output.put_line(sqlerrm);
end;

--Testdaten
insert into customer values(500, 'Werner', -300);
insert into customer values(null, 'Lisa', 0);
insert into customer values(500, 'Ralf', 1200);

--Abfrage
SELECT * FROM bank_account;