-- 1. Gli operatori devono
-- poter calcolare l’insieme delle aree verdi fruibili che hanno almeno un soggetto verde
-- della specie 'Pinus pinea' e piantata almeno 5 anni fa.

select distinct a.id
from areaverde a
    join soggettoverde s
        on a.area = a.id
where s.specie = 'Pinus Pinea'
    and a.is_fruibile = true
    and s.date <= current_date - interval '5 year'


-- 2. Il management deve poter calcolare, l’insieme delle aree verdi sensibili che non sono state 
-- oggetto di alcun intervento
-- nel periodo '2023-10-9' - '2023-10-13'

-- not in
select * 
from areavede a
where a.is_sensibile = true
    and a.id not in (
        select i.area
        from intervento i, interventoassegnato ia
        where i.id = ia.id_intervento
            and (i.inizio, i.fine) overlaps ('2023-10-9', '2023-10-12')
    );

-- not exist
select * 
from areavede a
where a.is_sensibile = true
    and not exists (
        select *
        from intervento i, interventoassegnato ia
        where i.id = ia.id_intervento
            and (i.inizio, i.fine) overlaps ('2023-10-9', '2023-10-12')
            and i.area = a.id  -- riferimento a query esterna
    );

-- join esterno  brutta
select *
from ariaverde a
    left outer join intervento i -- o left join
        on a.id = i.area
    left join interventoassegnato ia
        on a.id = ia.id_intervento
        and (i.inizio, i.fine) overlaps ('2023-10-9', '2023-10-12')
where i.id is null; --  non ha intervento assegnato


select interval '-2 hours';


-- 3. I dipendenti
-- comunali devono poter ottenere dal sistema gli operatori ai quali è stato assegnato il
-- minor numero di interventi con priorità maggiore o uguale a 5 nell'anno 2023.

-- Soluzione query 3

WITH
n_int_per_oper AS (
    select o.cf, o.nome, o.cognome, count(*) as num_interv
    from operatore o, intervento i, assegna a
    where
        a.operatore = o.cf
        and a.interventoassegnato = i.id
        and i.priorita >= 5
        and extract(year from a.istante) = 2023
    group by o.cf),
n_min_interv as (
    select min(num_interv) as n_min
    from n_int_per_oper
)
select *
from n_int_per_oper t1, n_min_interv t2
where t1.num_interv = t2.n_min;


-- 3a Restituire tutti gli operatori ai quali erano stati assegnato al massimo due interventi
select o.cf, o.nome, o.cognomei
from operatore o, intervento i, assegna a
where
    a.operatore = o.cf
    and a.interventoassegnato = i.id
    and i.priorita >= 5
    and extract(year from a.istante) = 2023
group by o.cf
having  count(*) <= 2;


-- 4. restituire tutte le aree verdi con almeno 10 soggetti verdi

-- 5. il numero di operatori che sono stati assegnati almeno una volta ad interventi con priorità < 4

-- 6. la durata prevista media e la durata effettiva media degli interventi completati.

-- 7. gli operatori assegnati all'intervento più lungo

-- 8. il numero degli interventi non terminati assegnati ad aree verdi non sensibili

-- 9. le aree verdi senza nessun soggetto verde.