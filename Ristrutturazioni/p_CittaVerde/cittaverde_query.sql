--  inizio < current_date - interval '2 year'

-- 1. Gli operatori devono  poter calcolare 
-- l’insieme delle aree verdi fruibili che hanno almeno un soggetto verde
-- della specie 'Pinus pinea' e piantata almeno 5 anni fa.

select distinct a.id, sp.n_scientifico
from areaverde a, soggettoverde sv, specie sp
where sv.area = a.id
    and sv.specie = sp.n_scientifico
    and sv.specie = 'Pinus pinea'
    and a.is_fruibile = True
    and sv.data < current_date - interval '5 year';



-- 2. Il management deve poter calcolare, 
-- l’insieme delle aree verdi sensibili che non sono state 
-- oggetto di alcun intervento
-- nel periodo '2023-10-9' - '2023-10-13'

-- vers 1 - NOT IN
select a.id
from areaverde a
where a.is_sensibile = True
    and a.id not in (
        select a.id
        from areaverde a, intervento i, interventoassegnato ia
        where i.area = a.id
            and ia.id_intervento = i.id
            and a.is_sensibile = True
            and (i.inizio, ia.fine) overlaps ('2023-10-9', '2023-10-12')
    );

-- vers 2 - EXCEPT
select a.id
from areaverde a
where a.is_sensibile = True

except

select a.id
        from areaverde a, intervento i, interventoassegnato ia
        where i.area = a.id
            and ia.id_intervento = i.id
            and a.is_sensibile = True
            and (i.inizio, ia.fine) overlaps ('2023-10-9', '2023-10-12');




-- 3. I dipendenti comunali devono poter ottenere dal sistema 
-- gli operatori ai quali è stato assegnato il
-- minor numero di interventi con priorità maggiore o uguale a 5 nell'anno 2023.

-- -- vers 1 NOT EXISTS - sbagliata!!!!
-- select o.cf, o.nome, o.cognome, 
--     count(ia.id_intervento) as num_interv
-- from operatore o, 
--     assegna a, 
--     intervento i, 
--     interventoassegnato ia
-- where a.operatore = o.cf
--     and a.interventoassegnato = ia.id_intervento
--     and ia.id_intervento = i.id
--     and i.priorita >= 5
--     and (i.inizio, ia.fine) overlaps ('2023-01-01', '2023-12-31')
--     and not exists (
--         select o1.cf, o1.nome, o1.cognome, 
--             count(ia.id_intervento) as num_interv1
--         from operatore o1, 
--             assegna a, 
--             intervento i, 
--             interventoassegnato ia
--         where a.operatore = o1.cf
--             and a.interventoassegnato = ia.id_intervento
--             and ia.id_intervento = i.id
--             and i.priorita >= 5
--             and (i.inizio, ia.fine) overlaps ('2023-01-01', '2023-12-31')
--         group by o.cf
--         having num_interv1 < num_interv  -- num_interv ancora non c'è
--     )
-- group by o.cf;   -- no!!!!


-- vers 2 
with n_int_per_oper as (
    select o.cf, o.nome, o.cognome, count(ia.id_intervento) as count_interv
    from operatore o, 
        assegna a, 
        intervento i, 
        interventoassegnato ia
    where a.operatore = o.cf
        and a.interventoassegnato = ia.id_intervento
        and ia.id_intervento = i.id
        and i.priorita >= 5
        and (i.inizio, ia.fine) overlaps ('2023-01-01', '2023-12-31')
        -- extract(year from a.istante) = 2023
    group by o.cf
),
 t2 as (
    select min(n_int_per_oper.count_interv) as min_interv
    from n_int_per_oper
)
select * 
from n_int_per_oper t1, t2
where t1.count_interv = t2.min_interv; -- si!


            -- num interv assegnate
            select o.cf, o.nome, o.cognome, 
                count(ia.id_intervento) as num_interv
            from operatore o, 
                assegna a, 
                intervento i, 
                interventoassegnato ia
            where a.operatore = o.cf
                and a.interventoassegnato = ia.id_intervento
                and ia.id_intervento = i.id
                and i.priorita >= 5
                and (i.inizio, ia.fine) overlaps ('2023-01-01', '2023-12-31')
            group by o.cf;  -- si

            -- calcolo min
            with t1 as (
                select o.cf, o.cognome, count(ia.id_intervento) as count_interv
                from operatore o, 
                    assegna a, 
                    intervento i, 
                    interventoassegnato ia
                where a.operatore = o.cf
                    and a.interventoassegnato = ia.id_intervento
                    and ia.id_intervento = i.id
                    and i.priorita >= 5
                    and (i.inizio, ia.fine) overlaps ('2023-01-01', '2023-12-31')
                group by o.cf
            )
            select min(t1.count_interv) as min_interv
            from t1 ;  -- si 




-- 4 Restituire tutte le arie verdi con almeno 10 soggetti verdi

select sv.area, count(sv.id)
from soggettoverde sv
group by sv.area
having count(sv.id) >= 10;



-- 5 il numero di opperatori che sono stati assegnati almeno una volta  ad interventi con priorita < 4
select count(o.cf) as num_operatori
from assegna a, 
    operatore o, 
    interventoassegnato ia, 
    intervento i
where a.operatore = o.cf
    and a.interventoassegnato = ia.id_intervento
    and ia.id_intervento = i.id
    and i.priorita < 4;



 -- 6  la durata prevista media  e la durata effetiva media degli interventi complettati

-- -- versione sbagliata
-- select round(avg(i.durata)::numeric, 2) as durata_prevista_media,
--     avg(ia.fine - i.inizio) as durata_effettiva_media-- 
-- from intervento i, interventoassegnato ia
-- where ia.id_intervento = i.id;  -- sbagliato!!!!!!!!!!!!!!!!
-- -- perche calcolo anche interventi che non hanno fine, quindi media sbagliata !!!!!!!
    

-- vers 1 - confronto in formato interval
select avg(i.durata * interval '1 minute') as durata_prevista_media,
V   -- avg(make_interval(min => i.durata))
    avg(ia.fine - i.inizio) as durata_effettiva_media-- media_prev, media ef
from intervento i, interventoassegnato ia
where ia.id_intervento = i.id  
    and ia.fine is not null; -- prendo solo quelli assegnati che anno la fine


        -- extract - estrae un valore numerico da data, timestamp o interval
        -- extract( campo from valore_temporale )
            -- es. 
            -- extract(year from timestamp'2026-01-12 10:20:00') -> 2026
            -- extract(minute from timestamp'2026-01-12 10:20:00') -> 20 
        -- epoch - contatore di secondi
        -- extract(epoch from interval) -> qunti secondi ci sono in quel intervallo
            -- es. 
            -- extract(epoch from interval '01:30:00') -> 5400 secondi

-- vers 2 - confronto in formato numeric
select round( avg(i.durata)::numeric, 2) as media_durata_prevista,
    round( avg( extract ( epoch 
                        from (ia.fine - i.inizio)  -- fine - inizio per non avere i valori negativi
                        ) -- estraggo num seccondi dal intervallo
                        / 60 -- trasformo in minuti
                ) , 2) as media_durata_effetiva
from intervento i, interventoassegnato ia
where ia.id_intervento = i.id
    and ia.fine is not null;




-- 7 gli opperatori che sono stati assegnati agli intervento pia lungo

-- vers 1 - con durata rapresentata in minuti interi
with 
durata_interv as (
    select
        o.cf as cf,
        o.nome as nome, 
        o.cognome as cognome,
        i.id as id_intervento,
        round( ( extract ( epoch 
                        from (ia.fine - i.inizio)
                        ) / 60 -- trasformo in minuti
                ) , 2) as durata_minuti
    from intervento i, 
        interventoassegnato ia,
        assegna a,
        operatore o
    where ia.id_intervento = i.id
        and ia.fine is not null
        and a.operatore = o.cf
        and a.interventoassegnato = ia.id_intervento
    order by o.cognome
),
massima_durata as (
    select max(durata_minuti) as max_durata_minuti
    from durata_interv
)
select t1.cf, t1.nome, t1.cognome, 
    t1.id_intervento, t2.max_durata_minuti
from durata_interv t1,
	massima_durata t2
where t1.durata_minuti = t2.max_durata_minuti;   -- si

-- vers 2 - con durata rapresentata come intervallo
with 
durata_interv as (
    select
        o.cf as cf,
        o.nome as nome, 
        o.cognome as cognome,

        (ia.fine - i.inizio) as durata_intervallo
    from intervento i, 
        interventoassegnato ia,
        assegna a,
        operatore o
    where ia.id_intervento = i.id
        and ia.fine is not null
        and a.operatore = o.cf
        and a.interventoassegnato = ia.id_intervento
    order by o.cognome
),
massima_durata as (
    select max(durata_intervallo) as max_durata_intervallo
    from durata_interv
)
select t1.cf, t1.nome, t1.cognome, t2.max_durata_intervallo
from durata_interv t1,
	massima_durata t2
where t1.durata_intervallo = t2.max_durata_intervallo;   -- si



        -- solo durata
        select
                o.cf as cf,
                o.nome as nome, 
                o.cognome as cognome,
                (ia.fine - i.inizio) as durata
            from intervento i, 
                interventoassegnato ia,
                assegna a,
                operatore o
            where ia.id_intervento = i.id
                and ia.fine is not null
                and a.operatore = o.cf
                and a.interventoassegnato = ia.id_intervento
            order by o.cognome; -- si


        -- max durata
        with 
        durata_interv as (
            select
                o.cf as cf,
                o.nome as nome, 
                o.cognome as cognome,
                round( ( extract ( epoch 
                                from (ia.fine - i.inizio)
                                ) / 60 -- trasformo in minuti
                        ) , 2) as durata
            from intervento i, 
                interventoassegnato ia,
                assegna a,
                operatore o
            where ia.id_intervento = i.id
                and ia.fine is not null
                and a.operatore = o.cf
                and a.interventoassegnato = ia.id_intervento
            order by o.cognome
        )
        select max(durata) as max_durata
        from durata_interv;  -- si


-- 8. il numero degli interventi non terminati assegnati ad aree verdi non sensibili
 
-- prendo solo fruibili
select count(i.id) as num_interv_non_terminati
from intervento i, interventoassegnato ia, areaverde av
where ia.id_intervento = i.id
    and i.area = av.id
    and av.is_fruibile = True 
    and av.is_sensibile = false
    and ia.fine is null;

-- prendo areeverdi fruibili e non fruibili
select count(i.id) as num_interv_non_terminati
from intervento i, interventoassegnato ia, areaverde av
where ia.id_intervento = i.id
    and i.area = av.id
    and av.is_sensibile = false
    and ia.fine is null;



-- 9  le aree verdi senza nessun soggetto verde.

-- vers EXCEPT
select av.id
from areaverde av

except

select av.id
from areaverde av, soggettoverde sv
where sv.area = av.id;

-- vers NOT IN
select av.id
from areaverde av
where av.id not in (
    select av.id
    from areaverde av, soggettoverde sv
    where sv.area = av.id
);


















