with
    ordens_servicos as (
        select *
        from {{ ref('stg_ordens_servicos') }}
    )

    , produtos as (
        select *
        from {{ ref('dim_produtos') }}
    )

    , sucateado as (
        select *
        from {{ ref('dim_sucateamento') }}
    )

    , fato_ordem as (
        select 
        {{ 
            dbt_utils.surrogate_key(['id_ordem_servico', 'data_modificacao'])
        }} as sk_ordens_servicos
        , p.sk_produtos as fk_produtos
        , s.sk_sucateados as fk_sucateados
        , o.quantidade_ordem
        , o.quantidade_sucateado
        , o.id_razão_sucateado
        , o.data_inicio
        , o.data_fim
        , o.data_vencimento
        , o.data_modificacao
        from ordens_servicos o
        left join produtos p
        left join sucateado s
    )