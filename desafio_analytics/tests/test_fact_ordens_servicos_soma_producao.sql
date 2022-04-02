/*Esse teste garante que os joins da dim_contributors não estão duplicando linhas. */

with
    data as (
        select 
	        sum(quantidade_ordem) as produzido_em_2012
        from {{ ref('fact_ordens_servicos') }}
        where 
	        data_inicio >= '2012-01-01 00:00:00 UTC' 
            and data_fim < '2013-01-01 00:00:00 UTC'
    )
    , validation as (
        select *
        from data
        where
            produzido_em_2012 != 1300410.0
    )
select *
from validation

