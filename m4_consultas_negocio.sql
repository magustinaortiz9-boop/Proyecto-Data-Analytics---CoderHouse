SELECT
    MONTH(fecha_venta) AS mes
FROM ventas;


SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta);


SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(*) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY MONTH(fecha_venta);



SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;



SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;



SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >= promedio_mensual THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
) AS ventas_mensuales
CROSS JOIN (
    SELECT
        AVG(total_mensual) AS promedio_mensual
    FROM (
        SELECT
            MONTH(fecha_venta) AS mes,
            SUM(cantidad * precio_unitario) AS total_mensual
        FROM ventas
        GROUP BY MONTH(fecha_venta)
    ) AS totales_mensuales
) AS promedio
ORDER BY mes;


-- HALLAZGOS

-- 1. Las 10 ventas registradas se concentran en marzo,
-- con una facturación total de $6.444 y un ticket promedio de $644,40.

-- 2. El producto 1 genera la mayor facturación con $3.600,
-- aunque solo registra 3 unidades vendidas.

-- 3. Los 5 clientes registrados son recurrentes,
-- ya que cada uno realizó 2 pedidos durante el período analizado.