-- *****  SPRINT 2 ************    //
-- SPRINT 2 IT ACADEMY DATA ANALYST  //
-- RODRIGO PADILLA					//
-- --------------------------------------------------------------------------

-- ****************************** NIVEL 1 **********************************

-- EJERCICIO 2
-- --------------------------------------------------------------------------

-- A PAISES QUE ESTAN REALIZANDO COMPRAS
SELECT DISTINCT COUNTRY
FROM COMPANY
JOIN TRANSACTION
ON TRANSACTION.COMPANY_ID = COMPANY.ID;

-- ------------------------------------------------------------------------------------
-- B DESDE CUANTOS PAISES SE REALIZAN COMPRAS
SELECT COUNT(DISTINCT company.country) CANT_PAISES
FROM COMPANY
	INNER JOIN TRANSACTION
	ON TRANSACTION.COMPANY_ID = COMPANY.ID;

-- ---------------------------------------------------------------------------------------
-- C COMPAÑIA CON LA MAYOR MEDIA DE VENTAS
SELECT C.company_name, ROUND(AVG(T.amount), 2) AS PROMEDIO_MAXIMO_VENTAS
FROM COMPANY C
JOIN TRANSACTION T ON C.id = T.company_id
WHERE T.DECLINED = 0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


	
-- EJERCICIO 3  
-- -----------------------------------------------------------------------------------------
-- A Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT *
FROM TRANSACTION T
WHERE T.COMPANY_ID IN
			(SELECT C.ID FROM COMPANY C
			WHERE C.COUNTRY = "Germany");

-- B Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones
SELECT DISTINCT C.COMPANY_NAME EMPRESA_MAYOR_PROM
FROM COMPANY C, TRANSACTION T
WHERE C.ID = T.COMPANY_ID
AND T.AMOUNT >
	(	
    SELECT AVG(T.AMOUNT) MEDIA_MONTO
		FROM COMPANY C, TRANSACTION T
		WHERE C.ID = T.COMPANY_ID)
ORDER BY 1 ASC;
        
-- C Empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
-- ---------------------------------------------------------------------------------------------------
SELECT C.COMPANY_NAME AS EMPRESA
FROM COMPANY C
WHERE 
C.ID NOT IN 
			(SELECT DISTINCT T.COMPANY_ID FROM TRANSACTION T)
            ;

-- TODAS LAS EMPRESAS TIENEN TRANSACCIONES, SE COMPROBO TAMBIEN CON LAS SIGUIENTES CONSULTAS
SELECT distinct C.ID FROM COMPANY C ORDER BY C.ID ASC ;
SELECT DISTINCT T.COMPANY_ID FROM TRANSACTION T ORDER BY T.COMPANY_ID ASC;

-- ////////////////////////////////////////////////////////////////////////////////////////////

-- ***************************************** NIVEL 2 *******************************************

-- --------------------------------------------------------------------------------------------------------
-- EJERCICIO 1 
-- Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
-- Muestra la fecha de cada transacción junto con el total de las ventas.

SELECT DATE(T.TIMESTAMP) FECHA, SUM(T.AMOUNT) TOTAL_VENTAS
FROM TRANSACTION T
WHERE T.DECLINED = 0
GROUP BY 1
ORDER BY TOTAL_VENTAS DESC
LIMIT 5;

-- -----------------------------------------------------------------------------------------------------
-- EJERCICIO 2 ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio

	SELECT C.COUNTRY PAIS, ROUND(AVG(T.AMOUNT),2) AS PROM
	FROM company C
	JOIN
	transaction T ON C.id = T.company_id
    AND T.declined = 0
	GROUP BY C.COUNTRY
    ORDER BY PROM DESC ;

-- ---------------------------------------------------------------------------------------------------
-- EJERCICIO 3 
-- lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que compañía "NON INSTITUTE".
-- A Subconsulta
SELECT *
FROM TRANSACTION T
WHERE T.COMPANY_ID IN 
		(SELECT C.ID
        FROM COMPANY C
        WHERE C.COUNTRY = (SELECT C.COUNTRY
							FROM COMPANY C
							WHERE C.COMPANY_NAME = 'Non Institute'));

-- B Join

SELECT *
FROM TRANSACTION T
JOIN COMPANY C ON C.ID = T.COMPANY_ID
WHERE C.COUNTRY = ( SELECT C.COUNTRY FROM COMPANY C WHERE C.COMPANY_NAME= 'Non Institute');

-- JOIN (SELECT C.COUNTRY FROM COMPANY C WHERE C.COMPANY_NAME = 'Non Institute') AUX2 ON C.COUNTRY = AUX2.COUNTRY ;




-- ****************** NIVEL 3 ************************
-- EJERCICIO 1
-- nombre, teléfono, país, fecha y amount, de  empresas CON transacciones con un valor entre 100 y 200 euros 
-- y entre fechas:  29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022.
SELECT C.COMPANY_NAME NOMBRE, C.PHONE TELEFONO, C.COUNTRY PAIS, CONVERT(T.TIMESTAMP, date) FECHA, T.AMOUNT AS MONTO
FROM COMPANY C
	JOIN TRANSACTION T
	ON C.ID = T.COMPANY_ID
	WHERE CONVERT(T.TIMESTAMP, date) IN ('2021-04-29', '2021-07-20', '2022-03-13')
    AND T.AMOUNT BETWEEN 100 AND 200
   ORDER BY T.AMOUNT DESC;
    
-- EJERCICIO 2
-- Cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente 
-- y quiere un listado de las empresas donde especifiques si tienen más de 4 o menos transacciones
SELECT C.COMPANY_NAME NOMBRE_EMPRESA, COUNT(T.ID) CANT_TRANSACCIONES,
	CASE 
		WHEN COUNT(T.ID) > 4 THEN 'Altas transacciones' ELSE 'Bajas transacciones'
	END NIVEL_TRANSACCIONES
FROM COMPANY C
	JOIN TRANSACTION T ON C.ID = T.COMPANY_ID
    group by 1
    ORDER BY 2 DESC;