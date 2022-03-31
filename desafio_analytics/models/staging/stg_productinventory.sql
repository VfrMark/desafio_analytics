with
    source as (
        select 
            locationid as id_localização
            , productid as id_produto
            , shelf as prateleira
            , bin as caixa
            , quantity as quantidade_no_inventário
            , rowguid as guia_linha
            , modifieddate as data_modificacao
        from {{source('analytics','raw_productinventory')}}
    )

select * from source