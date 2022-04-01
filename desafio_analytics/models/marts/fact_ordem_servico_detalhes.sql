with
    source as (
        select *
        from {{ ref('stg_ordem_servico_detalhes') }}
    )
    , dim_localizacao as (
        select
            *
        from {{ ref('dim_localizacao') }}
    )

    , dim_produto as (
        select
            *
        from {{ ref('dim_produtos') }}
    ) 
    , fact_ordens_servicos as (
        select
            *
        from {{ ref('fact_ordens_servicos') }}
    ) 
    , fact_ordem_servico_detalhes as (
        select 
            id_ordem_servico 
            , id_produto 
            , id_localizacao 
            , sequencia_operacao
            , horas_fabricacao
            , custo_estimado
            , custo_real
            , data_planejada_inicio_fabricacao
            , data_planejada_fim_fabricacao
            , data_inicio_real
            , data_fim_real
            , data_modificacao
        from source        
    )
    , joined as (
        select
            /*fact_ordens_servicos.sk_ordens_servicos
            ,*/ dim_produto.sk_produtos
            , dim_localizacao.sk_localizacao
            , fact_ordem_servico_detalhes.id_ordem_servico 
            , fact_ordem_servico_detalhes.id_produto 
            , fact_ordem_servico_detalhes.id_localizacao 
            , fact_ordem_servico_detalhes.sequencia_operacao
            , fact_ordem_servico_detalhes.horas_fabricacao
            , fact_ordem_servico_detalhes.custo_estimado
            , fact_ordem_servico_detalhes.custo_real
            , fact_ordem_servico_detalhes.data_planejada_inicio_fabricacao
            , fact_ordem_servico_detalhes.data_planejada_fim_fabricacao
            , fact_ordem_servico_detalhes.data_inicio_real
            , fact_ordem_servico_detalhes.data_fim_real
            , fact_ordem_servico_detalhes.data_modificacao
        from fact_ordem_servico_detalhes
        /*left join fact_ordens_servicos
            on fact_ordem_servico_detalhes.id_ordem_servico = fact_ordens_servicos.id_ordem_servico*/
        left join dim_produto
            on fact_ordem_servico_detalhes.id_produto = dim_produto.id_produto
        left join dim_localizacao     
            on fact_ordem_servico_detalhes.id_localizacao = dim_localizacao.id_localizacao
    )
select *
from joined


