/* This test ensures that the sum of quantity of the "fact_historico_transacao" 
in March 2010 does not change over time*/

with
    data as (
        select 
	        sum(qtd_produto) as qnt_produto 
        from {{ ref('fact_historico_transacao') }}
        where 
            tipo_transacao = 'ordem servico' 
	        and data_transacao between '2013-08-01 00:00:00 UTC' and '2013-08-30 00:00:00 UTC'
    )
    , validation as (
        select *
        from data
        where
            qnt_produto != 234509
    )
select *
from validation

