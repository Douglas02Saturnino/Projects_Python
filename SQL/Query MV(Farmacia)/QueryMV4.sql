select * From dbamv.lot_pro
WHERE cd_produto = 62
    AND cd_lote = 'DP21L247'
   AND cd_estoque = 4;
   
   select * FROM dbamv.uni_pro
   WHERE cd_produto = 62;
   
select im.*
     from dbamv.mvto_kit_produzido m, dbamv.itmvto_kit_produzido im
     where m.cd_mvto_estoque = im.cd_mvto_Estoque
       and  im.cd_produto = 12
       AND im.cd_lote = '2132917'
       AND (m.cd_estoque = 4 OR m.cd_estoque_destino = 4)
       AND m.sn_kit_armazenado = 'S'
