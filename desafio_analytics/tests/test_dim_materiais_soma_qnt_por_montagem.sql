/* This test ensures that the sum of perassemblyqty of the "dim_materiais" 
in March 2010 does not change over time*/

with
    data as (
        select 
	        sum(qtd_por_montagem) as qnt_por_montagem
        from {{ ref('dim_materiais') }}
        where 
            data_inicio between '2010-03-01' and '2010-03-30'
    )
    , validation as (
        select *
        from data
        where
            qnt_por_montagem != 1394
    )
select *
from validation
