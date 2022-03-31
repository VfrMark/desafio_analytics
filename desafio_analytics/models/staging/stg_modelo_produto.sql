/*with 
    source as (
        select *
        from {{ source('analytics', 'raw_productmodel') }}
    )
    
    transformed as (
        select
        'productmodelid' as id_modelo_produto
        'name' as modelo_produto
        'catalogdescription' as descricao_catalogo
        'instructions' as instrucoes
        'rowguid' as guia_linha
        'modifieddate' as data_modificacao
        from source
    )