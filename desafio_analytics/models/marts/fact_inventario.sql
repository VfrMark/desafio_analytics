with
    stg_productinventory as (
        select 
            *
        from{{ref('stg_productinventory')}}
    )

    , dim_localizacao as (
        select
            *
        from{{ref('dim_localizacao')}}
    )

    , dim_produto as (
        select
            *
        from{{ref('dim_produto')}}
    )

    , joined as (
        select 
        dim_produto.id_produto as FK_produto
        , dim_localizacao.sk_localizacao as FK_localizacao
        , produto_inventario.quantidade_no_inventario as quantidade
        , produto_inventario.data_modificacao as data_mudanca
        from stg_productinventory as produto_inventario
        left join dim_localizacao
        on dim_localizacao.id_localizacao = produto_inventario.id_localizacao
        left join dim_produto
        on dim_produto.id_produto = produto_inventario.id_produto 
    )

select * from joined