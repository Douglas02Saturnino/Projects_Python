CREATE OR REPLACE PROCEDURE prc_cal_temp(hr_agendamento in date
                                         ,hr_chegada     in date
                                         ,v_Result       out varchar2
                                         ,v_Tempo        out varchar2) IS


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
  DBMS_OUTPUT.PUT_LINE(v_Result);

EXCEPTION
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('ERRO.');
    
END;
/
