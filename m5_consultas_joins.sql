USE Ventas_Tech_DB;
GO

SELECT
    TABLE_NAME AS tabla,
    COLUMN_NAME AS columna
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('clientes', 'productos', 'categorias', 'ventas')
ORDER BY TABLE_NAME, ORDINAL_POSITION;

USE Ventas_Tech_DB;
GO

-- CONSULTA 1: Vista base del proyecto
-- Objetivo: integrar las ventas con los datos descriptivos
-- de clientes, productos y categorías para utilizar en Power BI.

SELECT
    ventas.fecha_venta,
    clientes.id_cliente,
    clientes.nombre AS nombre_cliente,
    clientes.ciudad,
    productos.nombre_producto,
    categorias.nombre_categoria,
    ventas.cantidad,
    ventas.precio_unitario,
    ventas.cantidad * ventas.precio_unitario AS total_venta
FROM ventas
INNER JOIN clientes
    ON ventas.id_cliente = clientes.id_cliente
INNER JOIN productos
    ON ventas.id_producto = productos.id_producto
INNER JOIN categorias
    ON productos.id_categoria = categorias.id_categoria;

-- Hallazgo:
-- La consulta integra cada venta con su cliente, producto y categoría.
-- La ciudad y la categoría permiten segmentar las ventas en Power BI.


-- CONSULTA 2: Clientes sin ventas
-- Objetivo: identificar clientes registrados que nunca realizaron una compra.

SELECT
    clientes.nombre,
    clientes.email,
    clientes.fecha_registro
FROM clientes
LEFT JOIN ventas
    ON clientes.id_cliente = ventas.id_cliente
WHERE ventas.id_cliente IS NULL;

-- Hallazgo:
-- No se encontraron clientes sin ventas: los 5 clientes registrados
-- realizaron compras durante el período analizado.


-- CONSULTA 3: Productos sin ventas
-- Objetivo: identificar productos del catálogo que no registraron ventas.

SELECT
    productos.nombre_producto,
    categorias.nombre_categoria,
    productos.precio
FROM productos
INNER JOIN categorias
    ON productos.id_categoria = categorias.id_categoria
LEFT JOIN ventas
    ON productos.id_producto = ventas.id_producto
WHERE ventas.id_producto IS NULL;

-- Hallazgo:
-- No se encontraron productos sin ventas: todo el catálogo registró
-- al menos una venta, por lo que no hay artículos sin movimiento que revisar.


-- CONSULTA 4: Consolidado por origen usando UNION ALL
-- Objetivo: comparar la facturación de dos períodos de ventas.

SELECT
    consolidado.canal,
    SUM(consolidado.total) AS total_canal
FROM (
    SELECT
        cantidad * precio_unitario AS total,
        'Periodo 1 (5 al 10 de marzo)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-05'
      AND fecha_venta < '2024-03-11'

    UNION ALL

    SELECT
        cantidad * precio_unitario AS total,
        'Periodo 2 (11 al 15 de marzo)' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-11'
      AND fecha_venta < '2024-03-16'
) AS consolidado
GROUP BY consolidado.canal;

-- Hallazgo:
-- El período del 5 al 10 de marzo facturó $3.620, frente a $2.824
-- del segundo período: una diferencia de $796 a favor del primero.