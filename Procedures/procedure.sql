--Un procedimiento puede recibir parametros de entrada y salida, pero no retorna un valor directamente
--Procedure de entrada
CREATE OR REPLACE PROCEDURE registrar_cliente(
    --Un parametro IN es el modo por defecto, funciona como una constante dentro del procedimiento, es decir, se puede leer el valor, pero no se puede modificar
    p_rut IN VARCHAR2,
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_email IN VARCHAR2,
    p_telefono VARCHAR2
)

AS 

BEGIN 
    INSERT INTO CLIENTE (RUT, NOMBRE, APELLIDO, EMAIL, TELEFONO)
    VALUES (p_rut, p_nombre, p_apellido,p_email,p_telefono);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Cliente ' || p_nombre || ' registrado');
END registrar_cliente;
/    



--Un parametro OUT permite que el procedimiento envíe un valor de vuelta al programa que lo llamó.

CREATE OR REPLACE PROCEDURE datos_cliente(
    p_cliente_id IN NUMBER,
    p_nombre OUT VARCHAR2,
    p_apellido OUT VARCHAR2,
    p_email OUT VARCHAR2,
    p_telefono OUT VARCHAR2

)

IS

BEGIN
    SELECT nombre, apellido, email, telefono INTO p_nombre, p_apellido, p_email, p_telefono FROM CLIENTE WHERE CLIENTE_ID = p_cliente_id;


END datos_cliente;
/
