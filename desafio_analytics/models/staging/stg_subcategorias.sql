with 
    source as (
        select *
        from {{source('analytics','raw_productsubcategory')}}
    )
    
    , transformed as (
        select 
            "productsubcategoryid" as id_subcategoria_produto
            , "productcategoryid" id_categoria_produto
            , "name" as nome
            , "rowguid" as guia_linha
            , "modifieddate" as data_modificacao
        from source
    )

select * from transformed