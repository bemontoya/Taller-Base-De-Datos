--Una funcion es un bloque con nombre que siempre retorna exactamente un valor mediante la cláusula RETURN.
CREATE OR REPLACE FUNCTION calcular_descuento(
    p_monto_bruto IN NUMBER,
    p_convenio_id IN NUMBER
) RETURN NUMBER  -- <- se declara el tipo de retorno, en este caso NUMBER
AS 

    v_porcentaje NUMBER;
    v_descuento NUMBER;
BEGIN
    SELECT descuento_porcentaje 
    INTO v_porcentaje
    FROM CONVENIO_BANCO
    WHERE convenio_banco_id = p_convenio_id    
        AND activo = 'S';

    v_descuento := ROUND(p_monto_bruto * v_porcentaje / 100, 2);
    RETURN v_descuento; -- <- devuelve el resultado
END calcular_descuento;      
/


CREATE OR REPLACE FUNCTION calcular_cuadrado(
    p_numero IN NUMBER
) return NUMBER
AS
    v_resultado NUMBER;
BEGIN    
    v_resultado := p_numero * p_numero;
    return v_resultado;
END;    

--Se envia la constante 15 a la funcion como parametro de entrada (p_numero).
--Se calcula el 15 * 15 lo que retorna un valoe 225.
SELECT CALCULAR_CUADRADO(15) AS RESULTADO FROM DUAL;


DECLARE
    v_resultado NUMBER;
BEGIN 
    v_resultado := CALCULAR_CUADRADO(15);
    DBMS_OUTPUT.PUT_LINE('El resultado del cuadrado es ' || v_resultado);
END;
/   

SELECT * FROM CONVENIO_BANCO WHERE CONVENIO_BANCO_ID = 1 AND ACTIVO = 'S';

CREATE OR REPLACE FUNCTION aplicar_descuento(
    p_id_banco IN NUMBER,
    p_monto_bruto IN NUMBER
) RETURN NUMBER
IS 
    v_descuento_banco NUMBER;
    v_precio_final NUMBER;
BEGIN 
    SELECT DESCUENTO_PORCENTAJE INTO v_descuento_banco FROM CONVENIO_BANCO WHERE CONVENIO_BANCO_ID = p_id_banco AND ACTIVO = 'S';

    v_precio_final := p_monto_bruto - (p_monto_bruto * v_descuento_banco) / 100;

    return v_precio_final;
END aplicar_descuento;
/     

--el ide de p_id_banco será 1 y el monto bruto p_monto_bruto será de 10000, esto está definido en el select
SELECT APLICAR_DESCUENTO(1, 10000) AS TOTAL_A_PAGAR FROM DUAL;

DECLARE 
    v_monto_a_pagar NUMBER;
BEGIN 
    v_monto_a_pagar := APLICAR_DESCUENTO(1,10000);
    DBMS_OUTPUT.PUT_LINE('El monto a pagar ' || v_monto_a_pagar);
END;        

