with
    source as(
        select *
        from {{source('analytics','raw_productinventory')}}
    )

    , transformed as (
        SELECT
            locationid as id_localizacao
            , productid as id_produto
            , shelf as prateleira
            , bin as caixa
            , quantity as quantidade_no_inventario
            , rowguid as guia_linha
            , cast(modifieddate as date) as data_modificacao
        from source
    )
select * from transformed
