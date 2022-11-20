drop table if exists public.shipping_country_rates cascade;
drop table if exists public.shipping_agreement cascade;
drop table if exists public.shipping_transfer cascade;
drop table if exists public.shipping_info cascade;
drop table if exists public.shipping_status cascade;

--public.shipping_country_rates
create table public.shipping_country_rates (
	 shipping_country_id serial not null
	,shipping_country text null
	,shipping_country_base_rate numeric(14, 3) null
	,primary key (shipping_country_id)
);

--public.shipping_agreement
create table public.shipping_agreement (
	 agreementid bigint not null
	,agreement_number text null
	,agreement_rate double precision null
	,agreement_commission double precision null
	,primary key (agreementid)
);

--public.shipping_transfer
create table public.shipping_transfer (
	 transfer_type_id serial not null
	,transfer_type text null
	,transfer_model text null
	,shipping_transfer_rate double precision null
	,primary key (transfer_type_id)
);

--public.shipping_info
create table public.shipping_info (
	 shippingid bigint not null
	,vendorid bigint null
	,payment_amount numeric(14, 2) null
	,shipping_plan_datetime timestamp null
	,transfer_type_id bigint null
	,shipping_country_id bigint null
	,agreementid bigint null
	,primary key (shippingid)
	,foreign key (transfer_type_id) references public.shipping_transfer (transfer_type_id) on update cascade
	,foreign key (shipping_country_id) references public.shipping_country_rates (shipping_country_id) on update cascade
	,foreign key (agreementid) references public.shipping_agreement (agreementid) on update cascade
);

----public.shipping_status
create table public.shipping_status (
	 shippingid bigint not null
	,status text null
	,state text null
	,shipping_start_fact_datetime timestamp null
	,shipping_end_fact_datetime timestamp null
	,primary key(shippingid)
);