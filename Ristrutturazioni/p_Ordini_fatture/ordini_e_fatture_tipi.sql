CREATE DOMAIN Stringa as varchar;

CREATE DOMAIN InteGEZ as integer
    check (value >= 0);

CREATE DOMAIN FloatGEZ as real
    check (value >= 0);

CREATE DOMAIN Real_0_1 as real
    check (value BETWEEN 0 and 1);

CREATE DOMAIN PartitaIva as char(11)
    check (value ~ '^[0-9]{11}$'); 

CREATE DOMAIN Email as Stringa
    check (value ~* '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?$');

CREATE DOMAIN CodiceFiscale as char(16)
    check (value ~* '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');

CREATE DOMAIN Telefono as char(10)
    check (value ~ '^[0-9]{10}$');

 
CREATE TYPE Stato as ENUM
        ('in preparazione', 'inviato', 'da saldare', 'saldato');


CREATE DOMAIN Stringa_not_null as varchar(100)
    check (value is not null);

CREATE DOMAIN CAP_not_null as char(5)
    check (value is not null and value ~ '^[0-9]{5}$');

CREATE TYPE Indirizzo as (
    via Stringa_not_null,
    civico Stringa_not_null,
    cap CAP_not_null
);