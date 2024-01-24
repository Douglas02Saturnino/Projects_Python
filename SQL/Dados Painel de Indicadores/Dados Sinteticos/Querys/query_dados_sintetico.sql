SELECT ano
               ,mes
               ,CD_PRESTADOR
               ,nm_prestador
               ,qtd_ticket_medio
               ,nota_ticket_medio
               ,tempo_casa
               ,nota_tempo_casa
               ,qtd_ATE_URGENCIA
               ,NOTA_URGENCIA
               ,qtd_ATE_EXAMES
               ,NOTA_EXAME
               ,qtd_ATE_ELETIVOS
               ,NOTA_ELETIVOS
               ,qtd_ATE_CIRURGICO
               ,NOTA_CIRURGICO
               ,qtd_glosas
               ,case
                  when round(nota_glosas) < 0 THEN
                   0
                  else
                   round(nota_glosas)
                end NOTA_GLOSA
               ,qtd_inconformidade
               ,nota_inconformidade
               ,qtd_capacitacao
               ,nota_capacitacao
               ,qtd_eve_adverso
               ,nota_eve_adverso
               ,qtd_infeccao
               ,nota_infeccao
               ,qtd_reintervencao
               ,CASE
                  when round(nota_reintervencao) <= 0 THEN
                   1
                  when round(nota_reintervencao) is null THEN
                   1
                  else
                   round(nota_reintervencao)
                end NOTA_REINTERVENCAO
               ,qtd_sat_cli_ext
               ,nota_sat_cli_ext
          FROM (SELECT a.ano
                       ,a.mes
                       ,cd_prestador
                       ,nm_prestador
                       ,qtd_ticket_medio
                       ,CASE
                          WHEN qtd_ticket_medio >= 1600 THEN
                           60
                          else
                           ROUND((60 * qtd_ticket_medio) / 1600)
                        END nota_ticket_medio
                       ,(SELECT CASE
                                  WHEN dt_inicio_contrato is not null THEN
                                   (trunc((trunc(sysdate) -
                                          trunc(dt_inicio_contrato)) / 365) ||
                                   ' ANOS ' ||
                                   trunc(MOD(trunc(sysdate) -
                                              trunc(dt_inicio_contrato)
                                             ,365) / 30) || ' MESES')
                                  ELSE
                                   'NAO INFORMADO'
                                END as tempo_casa
                           FROM prestador
                          WHERE cd_prestador = a.cd_prestador) tempo_casa
                       ,CASE
                          WHEN (SELECT nvl(trunc((trunc(sysdate) -
                                                 trunc(dt_inicio_contrato)) / 365)
                                          ,0)
                                  FROM prestador
                                 WHERE cd_prestador = a.cd_prestador) >= 20 THEN
                           20
                          else
                           ROUND((20 *
                                 (SELECT nvl(trunc((trunc(sysdate) -
                                                    trunc(dt_inicio_contrato)) / 365)
                                             ,0)
                                     FROM prestador
                                    WHERE cd_prestador = a.cd_prestador)) / 20)
                        END nota_tempo_casa
                       ,qtd_ate_urgencia
                       ,CASE
                          WHEN qtd_ate_urgencia >= 160 THEN
                           40
                          else
                           ROUND((40 * qtd_ate_urgencia) / 160) -- Pontuação = (Pontuação Maxima * Qt.Atendimento) / Qt.Maxima de Atendimentos
                        END nota_urgencia
                       ,qtd_ate_exames
                       ,CASE
                          WHEN qtd_ate_exames >= 180 THEN
                           60
                          else
                           ROUND((60 * qtd_ate_exames) / 180)
                        END nota_exame
                       ,qtd_ate_eletivos
                       ,CASE
                          WHEN qtd_ate_eletivos >= 200 THEN
                           80
                          else
                           ROUND((80 * qtd_ate_eletivos) / 200)
                        END nota_eletivos
                       ,qtd_ate_cirurgico
                       ,CASE
                          WHEN qtd_ate_cirurgico >= 27 THEN
                           80
                          else
                           ROUND((80 * qtd_ate_cirurgico) / 27)
                        END nota_cirurgico
                       ,qtd_glosas
                       ,case
                          when qtd_glosas = 0 or qtd_glosas is null THEN
                           60
                          ELSE
                           ROUND(60 - qtd_glosas / NVL(NULLIF((SELECT count(distinct
                                                                           aviso_cirurgia.cd_aviso_cirurgia) * 100 qtd
                                                                FROM atendime
                                                               INNER JOIN aviso_cirurgia
                                                                  ON atendime.cd_atendimento =
                                                                     aviso_cirurgia.cd_atendimento
                                                                 AND aviso_cirurgia.tp_situacao = 'R'
                                                                 and aviso_cirurgia.cd_multi_empresa in
                                                                     (1, 2)
                                                                 and extract(year from
                                                                             aviso_cirurgia.dt_realizacao) =
                                                                     a.ano
                                                                 AND extract(month FROM
                                                                             aviso_cirurgia.dt_realizacao) =
                                                                     a.MES
                                                               INNER JOIN cirurgia_aviso
                                                                  ON aviso_cirurgia.cd_aviso_cirurgia =
                                                                     cirurgia_aviso.cd_aviso_cirurgia
                                                               INNER JOIN prestador_aviso
                                                                  ON prestador_aviso.cd_aviso_cirurgia =
                                                                     aviso_cirurgia.cd_aviso_cirurgia
                                                                 AND prestador_aviso.sn_principal = 'S'
                                                                 AND prestador_aviso.cd_cirurgia_aviso =
                                                                     cirurgia_aviso.cd_cirurgia_aviso
                                                               INNER JOIN prestador
                                                                  ON prestador.cd_prestador =
                                                                     prestador_aviso.cd_prestador
                                                                 AND prestador.cd_prestador =
                                                                     a.cd_prestador)
                                                             ,0)
                                                      ,1))
                        END nota_glosas
                       ,qtd_inconformidade
                       ,CASE
                          WHEN qtd_inconformidade > 0 THEN
                           0
                          else
                           80
                        END nota_inconformidade
                       ,qtd_capacitacao
                       ,CASE
                          WHEN qtd_capacitacao >= 3 THEN
                           80
                          else
                           round((80 * qtd_capacitacao / 3))
                        END nota_capacitacao
                       ,qtd_eve_adverso
                       ,CASE
                          WHEN qtd_eve_adverso is null or qtd_eve_adverso = 0 THEN
                           50
                          else
                           0
                        END nota_eve_adverso
                       ,qtd_infeccao
                       ,CASE
                          WHEN qtd_infeccao = 0 THEN
                           50
                          else
                           0
                        END nota_infeccao
                       ,qtd_reintervencao
                       ,CASE
                          WHEN (qtd_reintervencao) = 0 THEN
                           80
                          ELSE
                           ROUND(80 -
                                 qtd_reintervencao / NVL(NULLIF((SELECT count(distinct
                                                                             aviso_cirurgia.cd_aviso_cirurgia) * 100 qtd
                                                                  FROM atendime
                                                                 INNER JOIN aviso_cirurgia
                                                                    ON atendime.cd_atendimento =
                                                                       aviso_cirurgia.cd_atendimento
                                                                   AND aviso_cirurgia.tp_situacao = 'R'
                                                                   and aviso_cirurgia.cd_multi_empresa in
                                                                       (1, 2)
                                                                   and extract(year from
                                                                               aviso_cirurgia.dt_realizacao) =
                                                                       a.ano
                                                                   AND extract(month FROM
                                                                               aviso_cirurgia.dt_realizacao) =
                                                                       a.MES
                                                                 INNER JOIN cirurgia_aviso
                                                                    ON aviso_cirurgia.cd_aviso_cirurgia =
                                                                       cirurgia_aviso.cd_aviso_cirurgia
                                                                 INNER JOIN prestador_aviso
                                                                    ON prestador_aviso.cd_aviso_cirurgia =
                                                                       aviso_cirurgia.cd_aviso_cirurgia
                                                                   AND prestador_aviso.sn_principal = 'S'
                                                                   AND prestador_aviso.cd_cirurgia_aviso =
                                                                       cirurgia_aviso.cd_cirurgia_aviso
                                                                 INNER JOIN prestador
                                                                    ON prestador.cd_prestador =
                                                                       prestador_aviso.cd_prestador
                                                                   AND prestador.cd_prestador =
                                                                       a.cd_prestador)
                                                               ,0)
                                                        ,1))
                        END nota_reintervencao
                       ,qtd_sat_cli_ext
                       ,CASE
                          WHEN qtd_sat_cli_ext = 0 THEN
                           0
                          WHEN qtd_sat_cli_ext >= 100 THEN
                           60
                          else
                           round((60 * qtd_sat_cli_ext) / 100)
                        END nota_sat_cli_ext
                   FROM (SELECT sub.ano
                               ,sub.mes
                               ,sub.cd_prestador
                               ,sub.nm_prestador
                               ,(SELECT NVL(CASE
                                              WHEN (COALESCE(SUM(reg.vl_total_conta)
                                                            ,0) -
                                                   SUM(fnr.vl_honorario)) < 0 THEN
                                               0
                                              ELSE
                                               ROUND((COALESCE(SUM(reg.vl_total_conta)
                                                              ,0) -
                                                     SUM(fnr.vl_honorario)) /
                                                     NULLIF(COUNT(fnr.cd_atendimento)
                                                           ,0))
                                            END
                                           ,0)
                                   FROM DBAMV.FNRM_REPASSE_ATENDIMENTO fnr
                                   JOIN aviso_cirurgia avi
                                     ON fnr.cd_atendimento = avi.cd_atendimento
                                    AND avi.tp_situacao = 'R'
                                    AND avi.cd_multi_empresa in (1, 2)
                                   JOIN reg_fat reg
                                     ON avi.cd_atendimento = reg.cd_atendimento
                                    AND reg.sn_fechada = 'S'
                                   JOIN atendime ate
                                     ON avi.cd_atendimento = ate.cd_atendimento
                                    and ate.cd_prestador = sub.cd_prestador
                                  WHERE extract(year from fnr.dt_competencia) =
                                        sub.ano
                                    AND extract(month FROM fnr.dt_competencia) =
                                        SUB.MES) qtd_ticket_medio
                               ,sum(CASE
                                      WHEN sub.tp_atendimento = 'U' THEN
                                       1
                                      else
                                       0
                                    END) qtd_ate_urgencia
                               ,sum(CASE
                                      WHEN sub.tp_atendimento = 'E' THEN
                                       1
                                      else
                                       0
                                    END) qtd_ate_exames
                               ,sum(CASE
                                      WHEN sub.tp_atendimento = 'A' THEN
                                       1
                                      else
                                       0
                                    END) qtd_ate_eletivos
                               ,(SELECT count(aviso_cirurgia.cd_aviso_cirurgia)
                                   FROM atendime atend
                                  INNER JOIN aviso_cirurgia
                                     ON atend.cd_atendimento =
                                        aviso_cirurgia.cd_atendimento
                                    AND aviso_cirurgia.tp_situacao = 'R'
                                  INNER JOIN cirurgia_aviso
                                     ON aviso_cirurgia.cd_aviso_cirurgia =
                                        cirurgia_aviso.cd_aviso_cirurgia
                                  INNER JOIN prestador_aviso
                                     ON prestador_aviso.cd_aviso_cirurgia =
                                        aviso_cirurgia.cd_aviso_cirurgia
                                    AND prestador_aviso.sn_principal = 'S'
                                    AND prestador_aviso.cd_cirurgia_aviso =
                                        cirurgia_aviso.cd_cirurgia_aviso
                                  WHERE 1 = 1
                                    AND atend.cd_prestador = sub.cd_prestador
                                    AND extract(year FROM atend.dt_atendimento) =
                                        sub.ano
                                    AND extract(month FROM atend.dt_atendimento) =
                                        sub.mes) qtd_ate_cirurgico
                               ,(SELECT nvl(count(g.cd_pro_fat), 0)
                                   FROM glosas g
                                  WHERE g.cd_prestador = sub.cd_prestador
                                    AND g.cd_setor_apoio in (188)
                                    AND extract(year FROM g.dt_glosa) = sub.ano
                                    AND extract(month FROM g.dt_glosa) = sub.mes) qtd_glosas
                               ,(SELECT nvl(sum(qtd_incorformidades), 0)
                                   FROM mvcustom.mp_inconformidade_medicas
                                  WHERE cd_prestador = sub.cd_prestador
                                    AND extract(year FROM data) = sub.ano
                                    AND extract(month FROM data) = sub.mes) qtd_inconformidade
                               ,(SELECT nvl((count(cap.cd_capacitacao_medica) +
                                            count(tre.cd_treinamento_universidade_mv))
                                           ,0) qtd
                                   FROM mvcustom.mp_capacitacao_medica cap
                                   LEFT JOIN mvcustom.mp_treinamento_uni_mv tre
                                     ON cap.cd_prestador = tre.cd_prestador
                                    AND extract(year FROM cap.data_conclusao) =
                                        extract(year FROM tre.data_conclusao)
                                    AND extract(month FROM cap.data_conclusao) =
                                        extract(MONTH FROM tre.data_conclusao)
                                  WHERE cap.cd_prestador = sub.cd_prestador
                                    AND extract(year FROM cap.data_conclusao) =
                                        SUB.ANO) qtd_capacitacao
                               ,(SELECT nvl(sum(CASE
                                                  WHEN eve.cd_evento_adverso IS NOT NULL THEN
                                                   1
                                                  ELSE
                                                   0
                                                END)
                                           ,0)
                                   FROM mvcustom.mp_evento_adverso eve
                                  WHERE eve.cd_prestador = sub.cd_prestador
                                    AND extract(year FROM eve.data_incidente) =
                                        SUB.ANO
                                    AND extract(MONTH FROM eve.data_incidente) =
                                        SUB.MES) qtd_eve_adverso
                               ,(SELECT nvl(sum(CASE
                                                  WHEN inf.cd_infeccao IS NOT NULL THEN
                                                   1
                                                  ELSE
                                                   0
                                                END)
                                           ,0)
                                   FROM mvcustom.mp_infeccoes inf
                                  WHERE inf.cd_prestador = sub.cd_prestador
                                    AND extract(year FROM inf.data) = SUB.ANO
                                    AND extract(MONTH FROM inf.data) = SUB.MES) qtd_infeccao
                               ,(SELECT nvl(count(egresso_cirurgia.ds_cirurgia)
                                           ,0)
                                   FROM atendime
                                  INNER JOIN atendime egresso_ate
                                     ON atendime.cd_paciente =
                                        egresso_ate.cd_paciente
                                  INNER JOIN aviso_cirurgia
                                     ON atendime.cd_atendimento =
                                        aviso_cirurgia.cd_atendimento
                                    AND aviso_cirurgia.tp_situacao = 'R'
                                    AND aviso_cirurgia.cd_multi_empresa in
                                        (1, 2)
                                  INNER JOIN paciente
                                     ON atendime.cd_paciente =
                                        paciente.cd_paciente
                                    AND paciente.nm_paciente NOT LIKE '%TESTE%'
                                  INNER JOIN cirurgia_aviso
                                     ON aviso_cirurgia.cd_aviso_cirurgia =
                                        cirurgia_aviso.cd_aviso_cirurgia
                                  INNER JOIN prestador_aviso
                                     ON prestador_aviso.cd_aviso_cirurgia =
                                        aviso_cirurgia.cd_aviso_cirurgia
                                    AND prestador_aviso.sn_principal = 'S'
                                    AND prestador_aviso.cd_cirurgia_aviso =
                                        cirurgia_aviso.cd_cirurgia_aviso
                                  INNER JOIN prestador
                                     ON prestador.cd_prestador =
                                        prestador_aviso.cd_prestador
                                    and prestador.cd_prestador =
                                        sub.cd_prestador
                                  INNER JOIN cirurgia
                                     ON cirurgia_aviso.cd_cirurgia =
                                        cirurgia.cd_cirurgia
                                    AND cirurgia.cd_cirurgia not in
                                        (152, 201, 202)
                                  INNER JOIN aviso_cirurgia egresso_aviso
                                     ON egresso_ate.cd_atendimento =
                                        egresso_aviso.cd_atendimento
                                    AND egresso_aviso.tp_situacao = 'R'
                                    AND egresso_aviso.cd_multi_empresa in (1, 2)
                                    AND egresso_aviso.cd_paciente =
                                        aviso_cirurgia.cd_paciente
                                  INNER JOIN paciente egresso_pac
                                     ON egresso_ate.cd_paciente =
                                        egresso_pac.cd_paciente
                                    AND egresso_pac.nm_paciente NOT LIKE
                                        '%TESTE%'
                                  INNER JOIN cirurgia_aviso egresso_cir_aviso
                                     ON egresso_aviso.cd_aviso_cirurgia =
                                        egresso_cir_aviso.cd_aviso_cirurgia
                                  INNER JOIN cirurgia egresso_cirurgia
                                     ON egresso_cir_aviso.cd_cirurgia =
                                        egresso_cirurgia.cd_cirurgia
                                    AND egresso_cirurgia.cd_cirurgia not in
                                        (152, 201, 202)
                                 
                                  WHERE extract(year from
                                                egresso_aviso.dt_realizacao) =
                                        sub.ano
                                    AND extract(month FROM
                                                egresso_aviso.dt_realizacao) =
                                        sub.mes
                                    AND (egresso_aviso.dt_realizacao -
                                         aviso_cirurgia.dt_realizacao) < 31
                                    and egresso_aviso.dt_realizacao >
                                        aviso_cirurgia.dt_realizacao
                                    AND egresso_aviso.dt_aviso_cirurgia >
                                        aviso_cirurgia.dt_aviso_cirurgia) qtd_reintervencao
                               ,(SELECT nvl(ROUND(SUM(CASE
                                                        WHEN cd_ate_medico IN (4, 5) THEN
                                                         1
                                                        ELSE
                                                         0
                                                      END) /
                                                  NULLIF(COUNT(cd_ate_medico), 0) * 100)
                                           ,0) AS qtd_sat_cli_ext
                                   FROM MVCUSTOM.MP_SAT_CLI_EXT sat
                                  WHERE sat.cd_prestador = sub.cd_prestador
                                    AND EXTRACT(YEAR FROM sat.dt_atendimento) =
                                        sub.ano
                                    AND EXTRACT(MONTH FROM sat.dt_atendimento) =
                                        sub.mes) qtd_sat_cli_ext
                         
                           FROM (SELECT atendime.cd_multi_empresa
                                       ,atendime.cd_paciente
                                       ,extract(month FROM
                                                atendime.dt_atendimento) mes
                                       ,extract(year FROM
                                                atendime.dt_atendimento) ano
                                       ,atendime.cd_atendimento
                                       ,atendime.cd_convenio
                                       ,atendime.cd_pro_int
                                       ,atendime.cd_Procedimento
                                       ,atendime.tp_atendimento
                                       ,atendime.cd_prestador
                                       ,atendime.cd_cid
                                       ,atendime.dt_alta
                                       ,max_avi.cd_aviso_cirurgia
                                       ,prestador.nm_prestador
                                   FROM atendime
                                   left JOIN (SELECT max(cd_aviso_cirurgia) cd_aviso_cirurgia
                                                   ,cd_atendimento
                                               FROM aviso_cirurgia
                                              where tp_situacao = 'R'
                                              GROUP BY cd_atendimento) max_avi
                                     ON atendime.cd_atendimento =
                                        max_avi.cd_atendimento
                                   JOIN convenio
                                     ON atendime.cd_convenio =
                                        convenio.cd_convenio
                                    AND convenio.cd_convenio not in (1
                                                                    ,2
                                                                    ,50
                                                                    ,55
                                                                    ,59
                                                                    ,61
                                                                    ,63
                                                                    ,70
                                                                    ,73
                                                                    ,81
                                                                    ,82
                                                                    ,83
                                                                    ,86
                                                                    ,89
                                                                    ,91
                                                                    ,114
                                                                    ,118
                                                                    ,119
                                                                    ,122)
                                   JOIN prestador
                                     ON atendime.cd_prestador =
                                        prestador.cd_prestador
                                    AND prestador.cd_prestador not in (888)
                                    AND prestador.nm_prestador not LIKE
                                        ('%SOCIAL%')
                                    and prestador.nm_prestador NOT like
                                        ('%TESTE%')
                                    AND PRESTADOR.NM_PRESTADOR NOT LIKE
                                        ('%EXAME%')
                                  WHERE extract(year from atendime.dt_atendimento) IN
                                        (2023)) sub
                          GROUP BY sub.ano
                                  ,sub.mes
                                  ,sub.cd_prestador
                                  ,sub.nm_prestador) a
                  ORDER BY 2, 1)