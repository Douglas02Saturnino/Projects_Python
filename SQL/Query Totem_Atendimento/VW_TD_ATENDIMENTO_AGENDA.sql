CREATE OR REPLACE PACKAGE BODY MVCUSTOM.PKG_TD_ATENDIMENTO IS

/**********************************************************************************************************************************************************
 Autor..............: Douglas Alexander Saturnino
 Data...............: 24/10/2022
 Funcionalidade.....: Faz o processo do totem de auto_atendimento, cria atendimento, pedido de exame e item de pedido de exame.
**********************************************************************************************************************************************************/  
  PROCEDURE prc_td_cria_atendimento(v_cpf IN VARCHAR2, v_paciente in VARCHAR2, v_dt_nascimento in date) IS
  
    v_result      number;
    v_pedido      number;
    v_item_pedido number;
  
  begin
  
    for c_agendamento in (SELECT CD_IT_AGENDA_CENTRAL
                                ,CD_AGENDA_CENTRAL
                                ,MEDICO
                                ,CD_RECURSO_CENTRAL
                                ,HR_AGENDA
                                ,DATA
                                ,HORA
                                ,CD_PACIENTE
                                ,NM_PACIENTE
                                ,DT_NASCIMENTO
                                ,CD_ITEM_AGENDAMENTO
                                ,CD_EXA_RX
                                ,EXA_RX_CD_PRO_FAT
                                ,DS_EXA_RX
                                ,CD_CONVENIO
                                ,CD_CON_PLA
                                ,CD_SER_DIS
                                ,CD_TIP_MAR
                                ,DS_EMAIL
                                ,CD_PRESTADOR
                                ,CD_MULTI_EMPRESA
                                ,CD_UNIDADE_ATENDIMENTO
                                ,sistema
                                ,TP_ATENDIMENTO
                                ,SN_APAC
                                ,ORI_ATE
                                ,LOC_PROCED
                                ,TP_INTERNACAO
                                ,NR_CARTEIRA_ULTIMO_ATENDIMENTO
                                ,NR_CPF
                                ,TP_SEXO
                                ,cd_setor
                                ,ds_senha
                                ,cd_triagem_atendimento
                                ,cd_procedimento
                                ,nr_guia
                                ,dt_validade
                                ,cd_sub_plano
                                ,dt_val_guia
                                ,cd_cid
                                ,cd_des_ate
                            FROM mvcustom.vw_td_atendimento_agenda
                           WHERE 1=1
                           AND( NM_PACIENTE = v_paciente AND to_date(DT_NASCIMENTO, 'dd/mm/yyyy') = trunc(v_dt_nascimento))
                           OR NR_CPF = v_cpf)
                           
    loop
    
      v_result := dbamv.fnc_insere_atendime(psistema               => c_agendamento.sistema
                                           ,pcd_prestador          => c_agendamento.cd_prestador
                                           ,pcd_pro_int            => c_agendamento.exa_rx_cd_pro_fat
                                           ,pcdprocedimento        => c_agendamento.cd_procedimento
                                           ,pcd_paciente           => c_agendamento.cd_paciente
                                           ,pcd_convenio           => c_agendamento.cd_convenio
                                           ,ptp_atendimento        => nvl(c_agendamento.tp_atendimento, 'E')
                                           ,pmaquina               => 'PCSCTI04'
                                           ,pcd_ser_dis            => c_agendamento.cd_ser_dis
                                           ,pcd_tip_mar            => c_agendamento.cd_tip_mar
                                           ,pnr_guia               => c_agendamento.nr_guia
                                           ,pnr_senha              => NULL
                                           ,pcd_con_pla            => c_agendamento.cd_con_pla
                                           ,pnrcarteira            => c_agendamento.nr_carteira_ultimo_atendimento
                                           ,pdtvalidade            => c_agendamento.dt_validade
                                           ,pcd_sub_plano          => c_agendamento.cd_sub_plano
                                           ,pcdmultiempresa        => c_agendamento.cd_multi_empresa
                                           ,psn_atendimento_apac   => c_agendamento.sn_apac
                                           ,pcdoriate              => nvl(c_agendamento.ori_ate, 29)
                                           ,pcdtriagematendimento  => c_agendamento.cd_triagem_atendimento
                                           ,pdssenhatriagematend   => c_agendamento.ds_senha
                                           ,pdt_val_guia           => c_agendamento.dt_val_guia
                                           ,pcd_cid                => c_agendamento.cd_cid
                                           ,pcddesate              => c_agendamento.cd_des_ate
                                           ,pcdlocproced           => c_agendamento.loc_proced
                                           ,pcdtipointernacao      => c_agendamento.tp_internacao);                                         
      DBMS_OUTPUT.PUT_LINE('Atendimento: ' || v_result);
    
      v_pedido := seq_ped_rx.nextval;
    
      insert into ped_rx
        (cd_ped_rx
        ,cd_setor
        ,cd_prestador
        ,cd_atendimento
        ,cd_set_exa
        ,dt_pedido
        ,hr_pedido
        ,tp_local
        ,tp_motivo
        ,cd_age_rx
        ,dt_entrega
        ,hr_entrega
        ,cd_convenio
        ,nm_usuario
        ,cd_con_pla
        ,nm_prestador
        ,cd_guia
        ,nr_peso
        ,nr_altura
        ,sn_impresso
        ,cd_pre_med
        ,sn_importado_integracao
        ,cd_seq_integra
        ,dt_integra
        ,dt_coleta
        ,hr_coleta
        ,cd_ped_rx_integra
        ,dt_solicitacao
        ,dt_autorizacao
        ,dt_validade
        ,senha)
      values
        (v_pedido
        ,c_agendamento.cd_setor
        ,c_agendamento.cd_prestador
        ,v_result
        ,38 -- 
        ,SYSDATE
        ,SYSDATE
        ,'S'
        ,'R'
        ,NULL
        ,NULL
        ,NULL
        ,c_agendamento.cd_convenio
        ,'MVCUSTOM'
        ,c_agendamento.cd_con_pla
        ,(SELECT nm_prestador
           from prestador
          WHERE cd_prestador = c_agendamento.cd_prestador)
        ,NULL
        ,NULL
        ,NULL
        ,'N'
        ,NULL
        ,'N'
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL);
    
      DBMS_OUTPUT.PUT_LINE('Pedido de exame: ' || v_pedido);
    
      v_item_pedido := seq_itped_rx.nextval;
    
      insert into itped_rx
        (cd_ped_rx
        ,cd_exa_rx
        ,dt_entrega
        ,cd_itped_rx
        ,nr_faturado
        ,sn_import_aih
        ,sn_imagem_liberada)
      values
        (v_pedido
        ,c_agendamento.cd_exa_rx
        ,sysdate
        ,v_item_pedido
        ,2
        ,'N'
        ,'N');
      DBMS_OUTPUT.PUT_LINE('Item de pedido de exame: ' || v_item_pedido);
      
    
    END loop;
  
  END;
  
  

/************************************************************************************************************
 Autor..............: Douglas Alexander Saturnino
 Data...............: 29/11/2022
 Funcionalidade.....: Calcula o tempo do paciente definindo se o paciente est? atrasado ou no horario.
************************************************************************************************************/   

  FUNCTION fnc_paciente_dentro_do_horario(hr_agendamento in DATE
                                       ,hr_chegada     in DATE)

     RETURN Varchar2 IS

      v_Result Varchar2(100);
      v_Tempo  Varchar2(100);

  BEGIN
      SELECT TO_CHAR(TRUNC((ROUND(AVG(TO_CHAR(hr_agendamento - hr_chegada) * 1440)) * 60) / 3600)
                  ,'FM9900') || ':' ||
           TO_CHAR(TRUNC(MOD((ROUND(AVG(to_char(hr_agendamento - hr_chegada) * 1440)) * 60)
                            ,3600) / 60)
                  ,'FM00') ds_hora
      INTO v_Tempo
      FROM dual;

    CASE
      WHEN v_Tempo BETWEEN '00:-01' AND '00:-15' THEN
      v_Result := 'TRUE';
    WHEN v_Tempo BETWEEN '00:00' AND '00:15' THEN
      v_Result := 'TRUE';
    WHEN v_Tempo > '00:-15' THEN
      v_Result := 'FALSE';
    WHEN v_Tempo > '00:15' THEN
      v_Result := 'FALSE';
  END CASE;
    
    DBMS_OUTPUT.PUT_LINE(v_Tempo);
     
    RETURN(v_Result);

  EXCEPTION
    WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE('ERRO.');
  
      RETURN(NULL);
  
  END;


END PKG_TD_ATENDIMENTO;
