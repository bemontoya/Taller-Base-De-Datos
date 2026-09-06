--Estructura de una excepcion
--Bloque excepcion va siempre antes del end y despues de todas las instrucciones del begin.


--Buscar un cliente por su email, pero el email no existe en la tabla.
DECLARE
    v_nombre CLIENTE.nombre%TYPE;
BEGIN    
    SELECT nombre INTO v_nombre
    FROM CLIENTE
    WHERE email = 'noexiste@gmail.com';
    DBMS_OUTPUT.PUT_LINE('Nombre del cliente: ' || v_nombre);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el cliente.');
END;            
//

--SELECT INTO solo puede guardar una fila. Si la consulta retorna varias, se dispara esta excepción.
DECLARE
    v_nombre CLIENTE.nombre%TYPE;
BEGIN
    -- Hay 5 clientes en la tabla, esto falla
    SELECT nombre INTO v_nombre
    FROM CLIENTE;

    DBMS_OUTPUT.PUT_LINE(v_nombre);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('La consulta retornó más de un cliente.');
        DBMS_OUTPUT.PUT_LINE('Use un cursor para recorrer múltiples filas.');        
END;
//

--Error ZERO_DIVIDE
--Ocurre al dividir un número por cero

DECLARE
    v_resultado NUMBER;
BEGIN 
    v_resultado := 100 / 0;
    DBMS_OUTPUT.PUT_LINE(v_resultado);
EXCEPTION  
    WHEN ZERO_DIVIDE then
        DBMS_OUTPUT.PUT_LINE('Error: No se puede dividir por cero.');     
END;      
--Antes de dividir es buena practica validar con un bloque if  