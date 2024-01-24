SELECT atendime.cd_multi_empresa
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
                                        (2023)