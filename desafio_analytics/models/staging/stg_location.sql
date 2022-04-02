with
    source as (
        select *
        from {{source('analytics','raw_location')}}
    )
    , transformed as (
        SELECT
            locationid as id_localizacao
            , costrate as custo_hora
            , name as nome_local
            , availability as capacidade_manufatura
            , cast(modifieddate as timestamp) as data_modificacao
        from source
    )
select * from transformed