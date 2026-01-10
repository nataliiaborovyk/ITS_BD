-- 1. Gli operatori devono  poter calcolare 
-- l’insieme delle aree verdi fruibili che hanno almeno un soggetto verde
-- della specie 'Pinus pinea' e piantata almeno 5 anni fa.

select a.id, sp.n_scientifico
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
    and not exists (
        select o1.cf, o1.nome, o1.cognome, 
            count(ia.id_intervento) as num_interv1
        from operatore o1, 
            assegna a, 
            intervento i, 
            interventoassegnato ia
        where a.operatore = o1.cf
            and a.interventoassegnato = ia.id_intervento
            and ia.id_intervento = i.id
            and i.priorita >= 5
            and (i.inizio, ia.fine) overlaps ('2023-01-01', '2023-12-31')
        group by o.cf
        having num_interv1 < num_interv  -- num_interv ancora non c'è
    )
group by o.cf;   -- no

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
where t1.count_interv = t2.min_interv; -- si!!!!!



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
from t1   -- si 




-- 4 Restituire tutte le arie verdi con almeno 10 soggetti verdi

select sv.area, count(sv.id)
from soggettoverde sv
group by sv.area
having count(sv.id) >= 10



-- 5 il numero di opperatori che sono stati assegnati almeno una volta  ad interventi con priorita < 4



 -- 6  la durata prevista media di un intervento e la durata effetiva media degli interventi 

 -- 7 gli opperatori che sono stati assegnati agli intervento pia lungo

 -- 8 gli interventi degli interventi non terminati assegati ad aree verdi non sensibili 
 
 -- 9  le aree verdi senza nessun soggetto verde.


















select * 
from interventoassegnato
where fine is null;

select o.id, count(*)
from operatore o, soggettoverde s
where s.area = a.id;

select *
from intervento
where inizio < current_date - interval '2 year';
-- where (inizio, fine) overlaps ('2023-10-9', '2023-10-12');



