SELECT 
ca.clase_documento AS tipo_documento
, ca.num_doc_oficial AS factura
, r.ent_vol_calculo AS consumo
, SAFE_DIVIDE(sum(d.impor_variable), sum(d.ent_vol_calculo)) AS tarifa
, r.impor_mon_transaccion AS valor_facturado
, (r.tot_partida_de_factura_incluido - r.impor_mon_transaccion) AS otros_conceptos
, r.tot_partida_de_factura_incluido AS total_factura
, r.fec_inic_validez AS inicio_periodo
, r.fec_fin_validez AS fin_periodo
, r.fec_venci_neto AS fecha_emision
, MAX(ca.fec_compensacion) AS fecha_pago
, SUM(ca.imp_mon_local) AS aplicacion
, CASE 
    WHEN AVG(SAFE_CAST(ca.sts_compensacion AS INT64)) = 9 THEN "pago total"
    WHEN AVG(SAFE_CAST(ca.sts_compensacion AS INT64)) > 0 THEN "pago parcial"
    ELSE "no pago" 
  END AS estado_pago
, (r.impor_mon_transaccion - SUM(ca.imp_mon_local)) AS saldo_factura
FROM `datalake-vanti.prd_del_bi.facturacion_r` r
LEFT JOIN `datalake-vanti.prd_del_bi.facturacion_d` d ON r.num_doc_oficial = d.num_doc_oficial
LEFT JOIN `datalake-vanti.prd_del_bi.fi_ca` ca ON r.num_doc_oficial = ca.num_doc_oficial

WHERE r.num_doc_oficial IS NOT NULL
AND r.num_doc_oficial != ''
AND ca.num_doc_oficial NOT IN ('INV', 'NOT_NUM_OFICIAL')
AND ca.doc_compensacion IS NOT NULL
AND imp_mon_local > 100

AND r.fec_contab_documento BETWEEN '2021-04-01' AND '2021-04-30'-- AND r.num_doc_oficial = 'F24I3269800'
AND d.fec_contab_documento BETWEEN '2021-04-01' AND '2021-04-30'
AND ca.fec_contab_documento BETWEEN '2021-04-01' AND '2021-04-30'
GROUP BY 
ca.clase_documento
, ca.num_doc_oficial
, r.ent_vol_calculo
, r.impor_mon_transaccion
, r.tot_partida_de_factura_incluido
, fec_inic_validez
, fec_fin_validez
, fec_venci_neto
--PARTITION BY
--CLUSTER BY