with 
    staging_produto as (
        select *
        from {{ ref('stg_produtos') }}
    )
    
    , staging_categorias as (
        select *
        from {{ ref('stg_categorias') }}
    )

    , staging_subcategoria as (
        select *
        from {{ ref('stg_subcategorias') }}
    )

    , join_sub_categoria as (
        select
            sc.id_subcategoria_produto
            , sc.id_categoria_produto
            , c.nome as categoria
            , sc.nome as sub_categoria
            , sc.data_modificação
        from staging_subcategoria sc
        left join staging_categorias c
        on sc.id_categoria_produto = c.id_categoria_produto
    )
    
    
    , join_final as (
        select 
        {{ 
            dbt_utils.surrogate_key(['id_produto', 'p.data_modificacao']) 
        }} as sk_produtos
        , p.id_produto
        , p.nome
        , p.numero_produto
        , p.flag_feito
        , p.flag_produtos_finalizados
        , p.cor
        , p.estoque_minimo_seguro
        , p.estoque_minimo_critico
        , p.custo_padrao
        , p.preco_venda
        , p.tamanho
        , p.unidade_medida_tamanho
        , p.peso
        , p.unidade_medida_peso
        , p.dias_manufatura
        , p.linha_produto
        , p.classe
        , p.estilo
        , c.categoria
        , c.sub_categoria
        , p.modelo_produto
        , p.data_inicio_venda
        , p.data_fim_venda
        , p.data_descontinuado
        , p.data_modificacao
    from staging_produto p
    left join join_sub_categoria c
    on p.id_subcategoria_produto = c.id_subcategoria_produto
    )

select * from join_final