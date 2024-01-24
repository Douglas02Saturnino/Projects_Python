CREATE OR REPLACE FUNCTION fnc_paciente_dentro_do_horario(hr_agendamento in DATE, hr_chegada in DATE)

 RETURN Varchar2 IS

  v_Result Varchar2 (100);
  v_Tempo  Varchar2(100);

BEGIN
  SELECT TO_CHAR(TRUNC((ROUND(AVG(TO_CHAR(hr_agendamento -
                                          hr_chegada) * 1440)) * 60) / 3600)
                ,'FM9900') || ':' ||
         TO_CHAR(TRUNC(MOD((ROUND(AVG(to_char(hr_agendamento -
                                              hr_chegada) * 1440)) * 60)
                          ,3600) / 60)
                ,'FM00') ds_hora
    INTO v_Tempo
    FROM dual;

  CASE
    WHEN v_Tempo BETWEEN '00:-01' AND '00:-15' THEN
      v_Result := 'TRUE';
    WHEN v_Tempo BETWEEN '00:00' AND '00:15' THEN
      v_Result := 'TRUE';
    WHEN v_Tempo < '00:-16' THEN
      v_Result := 'FALSE';
    WHEN v_Tempo > '00:16' THEN
      v_Result := 'FALSE';
  END CASE;
  
  RETURN(v_Result);

EXCEPTION
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('ERRO.');
  
    RETURN(NULL);

END;
/
