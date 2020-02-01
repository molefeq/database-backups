SELECT * FROM public.ucloud_country
WHERE country_id is null;

SELECT *
FROM public.country
where name like '%Venezuela%';

UPDATE  public.ucloud_country
SET country_id = 87
where country like '%Venezuela%';

UPDATE  public.ucloud_country
SET country_id = 184
where country like '%Bolivia%';

UPDATE  public.ucloud_country
SET country_id = 167
where country like '%Antigua%';

COMMIT;
COMMIT;

UPDATE  public.ucloud_country
SET country_id = 167
where country like '%Antigua%';

COMMIT;

UPDATE  public.ucloud_country
SET country_id = 88
where country like '%Vietnam%';

COMMIT;

UPDATE  public.ucloud_country
SET country_id = 65
where country like '%Taiwan%';

UPDATE public.country
SET is_ucloud_enabled = true
WHERE id in (select country_id from public.ucloud_country where country_id is not null);

commit;
UPDATE public.country
SET tier = 1
WHERE id in (select country_id from public.ucloud_country where country_id is not null and tier = 1);

commit;
UPDATE public.country
SET tier = 2
WHERE id in (select country_id from public.ucloud_country where  country_id is not null and tier = 2);

commit;
UPDATE public.country
SET tier = 3
WHERE id in (select country_id from public.ucloud_country where   country_id is not null and tier = 3);

commit;
COMMIT;

UPDATE  public.ucloud_country
SET country_id = 117
where country like '%South Korea%';

COMMIT;

UPDATE  public.ucloud_country
SET country_id = 82
where country = 'United Kingdom';

COMMIT;
UPDATE  public.ucloud_country
SET country_id = 83
where country = 'United States';

COMMIT;
UPDATE  public.ucloud_country
SET country_id = 67
where country = 'Tanzania';

COMMIT;

UPDATE  public.ucloud_country
SET country_id = 159
where country = 'Aland Islands';

COMMIT;

UPDATE  public.ucloud_country
SET country_id = 186
where country = 'Bosnia & Herzegovina';

COMMIT;

UPDATE  public.ucloud_country
SET country_id = 39
where country = 'Macedonia';

COMMIT;

select *
from public.country;

alter table public.country
  add column tier int;
  
INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 300 data_quantity, 'MB' data_scale,
       '300MB/Day' data_quantity_description, 149 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 1;

INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 500 data_quantity, 'MB' data_scale,
       '500MB/Day' data_quantity_description, 199 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 1;

INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 1 data_quantity, 'GB' data_scale,
       '1GB/Day' data_quantity_description, 299 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 1;


INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 300 data_quantity, 'MB' data_scale,
       '300MB/Day' data_quantity_description, 209 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 2;

INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 500 data_quantity, 'MB' data_scale,
       '500MB/Day' data_quantity_description, 289 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 2;

INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 1 data_quantity, 'GB' data_scale,
       '1GB/Day' data_quantity_description, 399 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 2;


INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 300 data_quantity, 'MB' data_scale,
       '300MB/Day' data_quantity_description, 329 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 3;

INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 500 data_quantity, 'MB' data_scale,
       '500MB/Day' data_quantity_description, 599 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 3;

INSERT INTO public.topup_option
(country_id, data_quantity, data_scale, data_quantity_description, amount, currency, create_date)
SELECT id country_id, 1 data_quantity, 'GB' data_scale,
       '1GB/Day' data_quantity_description, 749 amount, 'ZAR' currency,
	   NOW()::date create_date
FROM public.country
WHERE tier = 3;

select *
from public.topup_option;

