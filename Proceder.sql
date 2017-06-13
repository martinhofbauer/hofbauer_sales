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