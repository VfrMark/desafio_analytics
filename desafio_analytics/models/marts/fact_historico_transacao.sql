with
    historico_transacao as (
        select *
        from {{ ref('stg_historico_transacao') }}
    ) 
    , historico_transacao_arquivo as (
        select *
        from {{ ref('stg_historico_transacao_arquivo') }}
    )
    , fact_historico_transacao as (
        select *
        from historico_transacao_arquivo     
        union all 
        select *
        from historico_transacao   
    )
    , fact_historico_transacao_with_sk as (
        select
            {{ 
                dbt_utils.surrogate_key(['id_transacao', 'fact_historico_transacao.data_modificacao']) 
            }} as sk_historico_transacao  
            , dim_produtos.sk_produtos
            , fact_historico_transacao.id_transacao 
            , fact_historico_transacao.id_produto
            , fact_historico_transacao.data_transacao
            , fact_historico_transacao.tipo_transacao
            , fact_historico_transacao.qtd_produto
            , fact_historico_transacao.custo_produto
            , fact_historico_transacao.data_modificacao
        from fact_historico_transacao    
        left join {{ ref('dim_produtos') }} 
            on fact_historico_transacao.id_produto = dim_produtos.id_produto
    )
select *
from fact_historico_transacao_with_sk
