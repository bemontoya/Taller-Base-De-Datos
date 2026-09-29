CREATE OR REPLACE TRIGGER tgr_validacion_datos_cliente

BEFORE INSERT OR UPDATE ON CLIENTE

FOR EACH ROW
BEGIN 
    --Replace busca todos los espacios ' ' y los reemplaza por nada('')
    --Trim elimina espacios al inicio y al final de una cadena
    :NEW.NOMBRE := INITCAP(TRIM(REPLACE(:NEW.nombre,' ','')));
    :NEW.APELLIDO := INITCAP(TRIM(REPLACE(:NEW.nombre,' ','')));
    --Lower convierte toda la cadena de texto en minuscula
    :NEW.EMAIL := LOWER(TRIM(REPLACE(:NEW.email,' ','')));
END tgr_validacion_datos_cliente;    