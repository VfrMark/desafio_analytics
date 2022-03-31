with
    staging as (
        select *
        from{{ ref('stg_location') }}
    )

    , transformed as (
        select
            {{ 
                dbt_utils.surrogate_key(['id_localização', 'data_modificação']) 
            }} as sk_localização
            , id_localização
            , custo_hora
            , nome_local
            , capacidade_manufatura
            , data_modificacao
        from staging
    )

select * from transformed