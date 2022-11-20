--public.shipping_country_rates
insert into public.shipping_country_rates
(shipping_country, shipping_country_base_rate)
select distinct 
	 shipping_country
	,shipping_country_base_rate
from public.shipping;

select * from public.shipping_country_rates limit 10;

--public.shipping_agreement
insert into public.shipping_agreement
(agreementid, agreement_number, agreement_rate, agreement_commission)
select 
	 cast(array_vendor_agr_desc[1] as numeric) as agreementid
	,array_vendor_agr_desc[2] as agreement_number
	,cast(array_vendor_agr_desc[3] as double precision) as agreement_rate
	,cast(array_vendor_agr_desc[4] as double precision) as agreement_commission
from (
	select distinct regexp_split_to_array(vendor_agreement_description, ':+') as array_vendor_agr_desc
	from public.shipping
	) as vendor_agr_desc;

select * from public.shipping_agreement limit 10;

--public.shipping_transfer
insert into public.shipping_transfer
(transfer_type, transfer_model, shipping_transfer_rate)
select 
	 array_shipping_transf_desc[1] as transfer_type
	,array_shipping_transf_desc[2] as transfer_model
	,shipping_transfer_rate
from (
	select distinct 
		 regexp_split_to_array(shipping_transfer_description, ':+') as array_shipping_transf_desc
		,shipping_transfer_rate
	from public.shipping
	) as shipping_transf_info;

select * from public.shipping_transfer limit 10;


--public.shipping_info
insert into public.shipping_info
(shippingid, vendorid, payment_amount, shipping_plan_datetime, transfer_type_id, shipping_country_id, agreementid)
select distinct 
	 t1.shippingid
	,t1.vendorid
	,t1.payment_amount
	,t1.shipping_plan_datetime
	,t2.transfer_type_id
	,t3.shipping_country_id
	,cast((regexp_split_to_array(t1.vendor_agreement_description, ':+'))[1] as numeric) as agreementid
from public.shipping t1 
left join public.shipping_transfer t2
	on t1.shipping_transfer_description = concat_ws(':', t2.transfer_type, t2.transfer_model) 
left join public.shipping_country_rates t3
	on t1.shipping_country = t3.shipping_country;
	
select * from public.shipping_info limit 10;

--public.shipping_status
insert into public.shipping_status
(shippingid, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
select 
	  t1.shippingid
	 ,t1.status
	 ,t1.state
	 ,t2.shipping_start_fact_datetime
	 ,t2.shipping_end_fact_datetime
from public.shipping t1
inner join (
	select 
		 shippingid
		,max(state_datetime) as max_state_datetime
		,min(case when state = 'booked' then state_datetime end) as shipping_start_fact_datetime
		,max(case when state = 'recieved' then state_datetime end) as shipping_end_fact_datetime
	from public.shipping
	group by shippingid
	) t2
	on t1.shippingid = t2.shippingid
	and t1.state_datetime = t2.max_state_datetime
order by shippingid;

select * from public.shipping_status limit 10;


