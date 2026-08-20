use ventas_tech_db;

SELECT 
DATEPART(MONTH, fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY DATEPART(MONTH, fecha_venta)
ORDER BY mes ASC;

SELECT TOP 5
id_productos,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_productos
ORDER BY total_generado DESC;

SELECT 
id_clientes,
COUNT(*) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_clientes
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

WITH FacturacionMensual AS (
SELECT 
DATEPART(MONTH, fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY DATEPART(MONTH, fecha_venta)
),
PromedioGeneral AS (
SELECT AVG(total_facturado) AS promedio_mensual
FROM FacturacionMensual
)
SELECT 
fm.mes,
fm.total_facturado,
CASE 
WHEN fm.total_facturado >= pg.promedio_mensual THEN 'Por encima'
ELSE 'Por debajo'
END AS desempeño_vs_promedio
FROM FacturacionMensual fm
CROSS JOIN PromedioGeneral pg
ORDER BY fm.mes ASC;

COMENTARIOS

1 - El id_producto 1 encabeza el ranking de ventas representando más del 35% de la facturación global,
lo que indica una fuerte dependencia de este ítem tecnológico en los ingresos totales.

2 - Un 40% de la base de compradores analizada califica como cliente recurrente (más de 1 pedido registrado),
concentrando más de la mitad de la facturación acumulada del período.

3 - Se observa un rendimiento 'Por encima' del promedio mensual general concentrado en el primer mes de operaciones,
seguido de un valle de ventas que justifica ajustar las campañas de promoción activas.
