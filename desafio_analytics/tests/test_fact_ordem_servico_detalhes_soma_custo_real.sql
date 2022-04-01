/* This test ensures that the sum of actualcost of the "fact_ordem_servico_detalhes" 
in June 2011 does not change over time for operationsequence = '1'*/

with
    data as (
        select 
	        sum(custo_real) as custo_real
        from {{ ref('fact_ordem_servico_detalhes') }}
        where 
	        sequencia_operacao = '1'
	        and data_planejada_inicio_fabricacao between '2011-06-01' and '2011-06-30'
    )
    , validation as (
        select *
        from data
        where
            custo_real != 11900.25
    )
select *
from validation






