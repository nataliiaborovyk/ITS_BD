begin transaction;

create domain stringa as varchar;

create domain Latitudine as real
    check(value >= -90 and value <= 90);
    -- check(value between -90 and 90)

create domain Longitudine as real
    check(value >= -180 and value <= 180);
    -- check(value between -180 and 180)

create domain IntGZ as integer
    check(value > 0);

create domain Priorita as integer
    check (value >= 1 and value <= 10);
    -- check(value bettween 1 and 10)

create domain CF as char(16)
    check (value ~* '^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$');



create table specie (
    n_scientifico stringa primary key,
    n_comune stringa not null
);

create table areaverde (
    id serial primary key,
    lat Latitudine not null,
    lang longitudine not null,
    is_fruibile boolean not null,
    is_sensibile boolean 
    check( 
        (is_sensibile is not null and is_fruibile = True)
        or
        (is_sensibile is null and is_fruibile = False))
    -- check(is_sensibile = False or is_fruibile = True) se A allora B
 );

create table soggettoverde (
    id serial primary key,
    data date not null,
    specie stringa not null,
    areaverde integer not null,
    foreign key (specie)
        references specie(n_scientifico) deferrable,  -- accorpa ap_sv
    foreign key (areaverde)
        references areaverde(id) deferrable   -- accorpa av_av
);

create table intervento (
    id serial primary key,
    inizio timestamp not null,
    durata_prev intgz not null,
    priorita priorita not null,
    ariaverde integer not null,
    foreign key (ariaverde)
        references areaverde(id)  deferrable -- accorpa av_int
);

create table interventoassegnato (
    intervento integer primary key,
    is_completato boolean not null,
    fine timestamp,
    foreign key (intervento)
        references intervento(id) deferrable,
    check(
        (fine is not null and is_completato = True)
        or 
        (fine is null and is_completato = False)
    )
    -- v.inclusione interventoassegnato(intervento) occorre in assegna(interventoassegnato)
);
--  se non metto is_complettato allora chi ha la fine significa che è complettato e in quel caso non serve il vincolo

create table operatore (
    cf cf primary key,
    nome stringa not null,
    cognome stringa not null,
    inizio date not null,
    fine date -- se ci fosse un vincolo   " , check(value is null or value > inizio)"
    
);

create table assegna (
    interventoassegnato integer not null,
    operatore cf not null,
    istante timestamp not null,
    primary key (interventoassegnato, operatore),
    foreign key (interventoassegnato)
        references interventoassegnato(intervento) deferrable,
    foreign key (operatore)
        references operatore(cf) deferrable
);


commit;