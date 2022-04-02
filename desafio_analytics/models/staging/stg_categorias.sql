with 
    source as (
        select *
        from {{source('analytics','raw_productcategory')}}
    )
    
    , transformed as (
        select
            productcategoryid as id_categoria_produto
            , name as nome
            , rowguid as guia_linha
            , cast(modifieddate as timestamp) as data_modificacao
        from {{source('analytics','raw_productcategory')}}
    )

select * from transformed