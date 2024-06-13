WITH VENCIMIENTOS AS (
SELECT 
  num_doc_oficial AS factura, 
  venci_neto      AS vencimiento
FROM (
  SELECT
    *,   
    row_number() over(
      partition by num_doc_oficial
      order by clase_documento
    ) as orden
  FROM (
    SELECT 
      distinct 
        num_doc_oficial, 
        venci_neto,
        CASE clase_documento
          WHEN 'FA' THEN '001FA'
          WHEN 'SD' THEN '001SD'
          ELSE clase_documento
        END AS clase_documento 
    FROM `datalake-vanti.prd_del_bi.fi_ca` 
    WHERE 
      fec_contab_documento BETWEEN '2023-12-01' AND '2023-12-31'
    )
  ))

SELECT 
ca.clase_documento AS tipo_documento
, sd.nro_referencia AS factura
, SUM(sd.valor_neto+sd.impte_impuesto) AS valor_facturado
, SUM(sd.valor_neto+sd.impte_impuesto) AS total_factura
, sd.fec_factura AS fecha_emision
, v.vencimiento AS fecha_vencimiento
, MAX(ca.fec_compensacion) AS fecha_pago
, SUM(ca.imp_mon_local) AS aplicacion
, CASE 
    WHEN AVG(SAFE_CAST(ca.sts_compensacion AS INT64)) = 9 THEN "pago total"
    WHEN AVG(SAFE_CAST(ca.sts_compensacion AS INT64)) > 0 THEN "pago parcial"
    ELSE "no pago" 
  END AS estado_pago
, (SUM(sd.valor_neto+sd.impte_impuesto) - SUM(ca.imp_mon_local)) AS saldo_factura
FROM `datalake-vanti.prd_del_bi.facturacion_sd` sd
INNER JOIN `datalake-vanti.GC.GC_USUARIOS_SD` usu ON sd.usu_modificacion = usu.cod_usuario_str
INNER JOIN `datalake-vanti.GC.GC_MATERIALES_SD` mat ON SAFE_CAST(sd.material as INT) = mat.Material_int
JOIN `datalake-vanti.prd_del_bi.fi_ca` ca ON sd.nro_referencia = ca.num_doc_oficial
JOIN VENCIMIENTOS v ON ca.num_doc_oficial = v.factura

WHERE sd.nro_referencia IS NOT NULL
AND sd.nro_referencia != ''
AND est_contabilidad = 'C'
AND est_fac_pedido = 'C'
AND sd.nro_referencia not like '%I%'
AND ca.doc_compensacion IS NOT NULL

AND sd.fec_factura BETWEEN '2023-12-01' AND '2023-12-31'  --AND sd.nro_referencia = 'C15S113530'
AND ca.fec_contab_documento BETWEEN '2023-12-01' AND '2023-12-31'
GROUP BY ca.clase_documento, sd.nro_referencia, sd.fec_factura, v.vencimiento