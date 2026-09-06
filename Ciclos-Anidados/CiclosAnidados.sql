DECLARE
    --Cursor maestro
    CURSOR c_eventos IS
        SELECT evento_id, nombre FROM EVENTO;

    CURSOR c_localidades(p_evento_id NUMBER) IS
        SELECT nombre_localidad, precio, stock_disponible
        FROM LOCALIDAD_EVENTO
        WHERE evento_id = p_evento_id;
BEGIN
    FOR ev IN c_eventos LOOP
        DBMS_OUTPUT.PUT_LINE('=== EVENTO: ' || ev.nombre || ' ===');

        FOR loc IN c_localidades(ev.evento_id) LOOP
            DBMS_OUTPUT.PUT_LINE('  -> ' || loc.nombre_localidad  || ':$' || loc.precio);
        END LOOP;
    END LOOP;
END;     
//

DECLARE
    v_total_evento NUMBER;
BEGIN
    FOR ev IN c_eventos LOOP
        v_total_evento := 0; --Reinicio obligatorio en 0

        FOR loc IN c_localidades(ev.evento_id) LOOP
            v_total_evento := v_total_evento + loc.stock_disponible;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE(ev.nombre || ' - Capacidad Total: ' || v_total_evento);
    END LOOP;
END;
//            

            