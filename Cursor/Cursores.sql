--¿Qué es un cursor?
-- Un cursor es un objeto de base de datos que integra multiples tablas mediante Join, subconsultas, agrupaciones, funnncioones de agregacion, o bien parametros para filtrar dinnámicamente el connjjunnnto de datos.
SELECT * FROM LOCALIDAD_EVENTO;

DECLARE 
    --Declaración con parámetro de entrada
    CURSOR c_localidades(p_evento_id NUMBER) IS
        SELECT nombre_localidad, precio, stock_disponible
        FROM LOCALIDAD_EVENTO
        WHERE evento_id = p_evento_id;
BEGIN
    --Se pasa el argumento al recorrer el cursor
    FOR loc IN c_localidades(1) LOOP
        DBMS_OUTPUT.PUT_LINE(loc.nombre_localidad || ' - $ ' || loc.precio || ' Stock disponible: ' || loc.stock_disponible);  
    END LOOP;
END; 
//

DECLARE
    --En la definición del cursor, los parámetros no llevan lonngitud. Se escribe VARCHAR2, nunca VARCHAR2(50).
    CURSOR c_pagos (p_estado VARCHAR2, p_monto_min NUMBER) IS
        SELECT transaccion_id, monto_final, metodo_pago
        FROM TRANSACCION_PAGO
        WHERE estado = p_estado
          AND monto_final >= p_monto_min;
BEGIN
    FOR r IN c_pagos('APROBADO', 100000) LOOP
        DBMS_OUTPUT.PUT_LINE('Pago #' || r.transaccion_id || ': $' || r.monto_final);
    END LOOP;          
END;  
//  

SELECT * FROM EVENTO;
DECLARE
    CURSOR c_resumenn_eventos IS
        SELECT e.nombre AS evento,
               p.nombre_fantasia AS productora,
               COUNT(t.ticket_id) AS total_tickets,
               NVL(SUM(t.precio_pagado), 0) AS recaudacion
        FROM EVENTO e
        JOIN PRODUCTORA p ON p.PRODUCTORA_ID = e.PRODUCTORA_ID
        LEFT JOIN LOCALIDAD_EVENTO le ON le.EVENTO_ID = e.EVENTO_ID
        LEFT JOIN RESERVA_TEMPORAL rt ON rt.LOCALIDAD_EVENTO_ID = le.LOCALIDAD_EVENTO_ID
        LEFT JOIN TICKET t ON t.RESERVA_ID = rt.RESERVA_ID
        GROUP BY e.nombre, p.nombre_fantasia;
BEGIN
    FOR ev IN c_resumenn_eventos LOOP
        DBMS_OUTPUT.PUT_LINE(ev.evento || ' | Tickets: ' || ev.total_tickets || ' | Total: $' || ev.recaudacion);
    END LOOP;
END;
//

DECLARE
    CURSOR c_localidades_stock IS
        SELECT localidad_evento_id, stock_disponible, precio
        FROM LOCALIDAD_EVENTO
        WHERE evento_id = 1
        FOR UPDATE OF stock_disponible, precio;
BEGIN
    -- Las filas quedan bloqueadas hasta que hagamos COMMIT o ROLLBACK
    NULL;
END;
//

DECLARE
    CURSOR c_loc IS
        SELECT localidad_evento_id, precio
        FROM LOCALIDAD_EVENTO
        WHERE stock_disponible < 500
        FOR UPDATE;
BEGIN
    FOR reg IN c_loc LOOP
        -- Sube 10% el precio de la fila actual
        UPDATE LOCALIDAD_EVENTO
        SET precio = precio * 1.10
        WHERE CURRENT OF c_loc;
    END LOOP;
    COMMIT;        
END;
//




