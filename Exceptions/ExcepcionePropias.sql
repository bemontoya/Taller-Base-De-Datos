--Excepciones predefinidas

--Se declara como una variable especial de tipo EXCEPTION en el bloque DECLARE

DECLARE
    --Declarar la excepción personalizada
    e_evento_cancelado EXCEPTION;
BEGIN
    NULL;
END;

--Lanzar la excepcion con RAISE. Se usa la instruccion RAISE para disparar la excepcion cuando se cumple una condicion

DECLARE
    e_evento_cancelado EXCEPTION;
    v_estado EVENTO.estado%TYPE;
BEGIN
    SELECT estado INTO v_estado
    FROM EVENTO
    WHERE nombre = 'Bad bunny - World''s Hottest Tour';

    IF v_estado = 'CANCELADO' THEN
        RAISE e_evento_cancelado;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Evento disponible para venta.');
EXCEPTION 
    WHEN e_evento_cancelado THEN
        DBMS_OUTPUT.PUT_LINE('No se puede vender: el evento está cancelado.');
END;                     

--Error con codigo personalizado (Entre -20000 y -20999) y un mensaje personalizado
BEGIN
    IF condicion THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Mensaje de error personalizado'
        );
    END IF;
END;         

--Ejemplo para validar stock
DECLARE
    v_stock LOCALIDAD_EVENTO.stock_disponible%TYPE;
BEGIN
    SELECT stock_disponible INTO v_stock
    FROM LOCALIDAD_EVENTO
    WHERE localidad_evento_id = 1;

    IF v_stock <= 0 THEN  
        RAISE_APPLICATION_ERROR(
            -20001,
            'Sin stock: las entradas para esta localidad están agotadas.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Stock disponible: ' || v_stock);
END;             