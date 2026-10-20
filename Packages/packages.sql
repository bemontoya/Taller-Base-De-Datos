--Creacion del paquete
CREATE OR REPLACE PACKAGE pkg_boleteria AS
--Variable del paquete (guarda el total ddel turno del cajero)
    g_total_vendidas NUMBER := 0;

    --Firma de la funcion para consultar el stock
    --p indica que es un parametro de entrada, y el tipo de dato que se espera recibir
    FUNCTION consultar_stock(p_localidad_id IN NUMBER)
    RETURN NUMBER;

    --Firma del procedimiento para vender entradas
    PROCEDURE vender_entradas(
        p_localidad_id IN NUMBER,
        p_cantidad IN NUMBER
    );

END pkg_boleteria;   
/

CREATE OR REPLACE PACKAGE BODY pkg_boleteria AS

    FUNCTION consultar_stock(p_localidad_id IN NUMBER)
    RETURN NUMBER IS
    
        v_stock NUMBER;
    BEGIN 
        SELECT stock_disponible INTO v_stock
        FROM LOCALIDAD_EVENTO
        WHERE localidad_evento_id = p_localidad_id;

        RETURN v_stock;
    EXCEPTION        
        WHEN NO_DATA_FOUND THEN
            return 0; --Si no se encuentra la localidad devuelve 0 
    END consultar_stock;   


    -- Procedimiento para vender entradas
    PROCEDURE vender_entradas(
        p_localidad_id IN NUMBER,
        p_cantidad IN NUMBER
    ) IS
    
        v_disponible NUMBER;
    BEGIN
        --reutiliza la funcion del mismo paquete
        v_disponible := consultar_stock(p_localidad_id);

        --valida si hay suficiente stock
        if v_disponible < p_cantidad THEN
            raise_application_error(-20001, 'No hay suficiente stock disponible para la localidad seleccionada.');
        END IF;    

        --descontar el stock en la tabla
        UPDATE LOCALIDAD_EVENTO
        SET stock_disponible = stock_disponible - p_cantidad
        WHERE localidad_evento_id = p_localidad_id;

        --acumula en la variable de paquete de la sesion

        g_total_vendidas := g_total_vendidas + p_cantidad;
    END vender_entradas;

END pkg_boleteria;    
/


DECLARE
    v_stock_inicial NUMBER;
    v_stock_final NUMBER;
BEGIN
    --consultar stock de la localida 1
    v_stock_inicial := pkg_boleteria.consultar_stock(1);
    DBMS_OUTPUT.PUT_LINE('Stock inicial: ' || v_stock_inicial);

    -- se realiza la venta de 2 entradas
    pkg_boleteria.vender_entradas(1,2);    

    --verificar si el stock se actualizó
    v_stock_final := pkg_boleteria.consultar_stock(1);
    DBMS_OUTPUT.PUT_LINE('Stock final: ' || v_stock_final);
    --verificar variable del turno del cajero
    DBMS_OUTPUT.PUT_LINE('Total entradas vendidas en el turno: ' || pkg_boleteria.g_total_vendidas);

    ROLLBACK; -- se deja la tabla intacta tras la prueba
END;
/



-- Consultar el stock actual de todas las localidades de un evento:
SELECT 
    nombre_localidad,
    precio,
    pkg_boleteria.consultar_stock(localidad_evento_id) AS cupos_disponibles
FROM LOCALIDAD_EVENTO
WHERE evento_id = 1;
/




--Ejercicio 1
CREATE OR REPLACE PACKAGE pkg_cliente_simple AS

    FUNCTION obtener_nombre_completo(p_cliente_id IN NUMBER) 
    RETURN VARCHAR2;

    PROCEDURE actualizar_telefono(p_cliente_id IN NUMBER, p_nuevo_telefono IN VARCHAR2);

END pkg_cliente_simple;
/


CREATE OR REPLACE PACKAGE BODY pkg_cliente_simple AS

    FUNCTION obtener_nombre_completo(p_cliente_id IN NUMBER)
    RETURN VARCHAR2 IS
    
        v_nombre_completo VARCHAR2(200);

        BEGIN

            SELECT nombre || ' ' || apellido INTO v_nombre_completo
            FROM cliente
            WHERE cliente_id = p_cliente_id;

            RETURN v_nombre_completo;
    END obtener_nombre_completo;

    PROCEDURE actualizar_telefono(p_cliente_id IN NUMBER, p_nuevo_telefono IN VARCHAR2) 
    IS        
        BEGIN
            UPDATE cliente
            SET telefono = p_nuevo_telefono
            WHERE cliente_id = p_cliente_id;

            DBMS_OUTPUT.PUT_LINE('Teléfono actualizado para el cliente');

            COMMIT;
        END;

END pkg_cliente_simple;    
/ 

BEGIN

    -- Obtener el nombre completo del cliente con ID 1
    DBMS_OUTPUT.PUT_LINE('Nombre completo del cliente: ' || pkg_cliente_simple.obtener_nombre_completo(1));

    -- Actualizar el teléfono del cliente con ID 1
    pkg_cliente_simple.actualizar_telefono(1, '987654321');

END;
/




--Ejercicio 2

CREATE OR REPLACE PACKAGE pkg_precios_simple AS 

    CONSTANT c_recargo_servicio NUMBER := 0.10; 

    g_cotizaciones NUMBER := 0;

    FUNCTION precio_con_recargo(p_localidad_id IN NUMBER)
    RETURN NUMBER;

    PROCEDURE ajustar_precio_base(p_localidad_id IN NUMBER, p_nuevo_precio IN NUMBER)
    RETURN NUMBER;

END pkg_precios_simple;
/

CREATE OR REPLACE PACKAGE BODY pkg_precios_simple AS

    FUNCTION precio_con_recargo(p_localidad_id IN NUMBER)
    RETURN NUMBER IS
        v_precio_base NUMBER;
        v_precio_final NUMBER;
    BEGIN
        SELECT precio INTO v_precio_base
        FROM localidad_evento
        WHERE localidad_evento_id = p_localidad_id;

        v_precio_final := v_precio_base * (1 + c_recargo_servicio);

        RETURN v_precio_final;
    END precio_con_recargo;

    PROCEDURE ajustar_precio_base(p_localidad_id IN NUMBER, p_nuevo_precio IN NUMBER) IS
    BEGIN
        UPDATE localidad_evento
        SET precio = p_nuevo_precio
        WHERE localidad_evento_id = p_localidad_id;

        g_cotizaciones := g_cotizaciones + 1;

        DBMS_OUTPUT.PUT_LINE('Precio base ajustado para la localidad. Total de cotizaciones: ' || g_cotizaciones);

        COMMIT;
    END ajustar_precio_base;

END pkg_precios_simple;