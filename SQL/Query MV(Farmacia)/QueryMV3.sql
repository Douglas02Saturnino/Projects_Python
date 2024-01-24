 declare
  cursor c_producao_produto is
     select im.cd_itmvto_estoque
     from dbamv.mvto_kit_produzido m, dbamv.itmvto_kit_produzido im
     where m.cd_mvto_estoque = im.cd_mvto_Estoque
       and  im.cd_produto = 12
       AND im.cd_lote = '2132917'
       AND (m.cd_estoque = 4 OR m.cd_estoque_destino = 4)
       AND m.sn_kit_armazenado = 'S'
       AND m.cd_mvto_estoque = 947470;
begin
  for a in c_producao_produto loop
     execute immediate 'alter trigger dbamv.TRG_ITM_KIT_PR_ATUALIZA_SALDO disable';
     execute immediate 'alter trigger dbamv.TRG_ITM_PR_ATUALIZA_QT_MOV disable';
  
     delete FROM dbamv.itmvto_kit_produzido
     WHERE cd_itmvto_estoque = a.cd_itmvto_estoque; 
     
     execute immediate 'alter trigger dbamv.TRG_ITM_KIT_PR_ATUALIZA_SALDO enable';
     execute immediate 'alter trigger dbamv.TRG_ITM_PR_ATUALIZA_QT_MOV enable'; 
  END Loop;
end;    
/

rollback;
commit;


