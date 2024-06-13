-- CREATE TABLE `datalake-vanti.vanti_linea.t1` AS
SELECT 
ca.clase_documento AS tipo_documento
, ca.num_doc_oficial AS factura
, r.ent_vol_calculo AS consumo
, SAFE_DIVIDE(d.impor_variable, d.ent_vol_calculo) AS tarifa
, r.impor_mon_transaccion AS valor_facturado
, (r.tot_partida_de_factura_incluido - impor_mon_transaccion) AS otros_conceptos
, tot_partida_de_factura_incluido AS total_factura
, fec_inic_validez AS inicio_periodo
, fec_fin_validez AS fin_periodo
, fec_venci_neto AS fecha_emision
, MAX(fec_compensacion) AS fecha_pago
, SUM(imp_mon_local) AS aplicacion
, CASE 
    WHEN AVG(CAST(sts_compensacion AS int)) = 9 THEN "pago total"
    WHEN AVG(CAST(sts_compensacion AS int)) > 0 THEN "pago parcial"
    ELSE "no pago" 
  END AS estado_pago
, (r.impor_mon_transaccion - SUM(imp_mon_local)) AS saldo_factura
FROM `datalake-vanti.prd_del_bi.facturacion_r` r
LEFT JOIN `datalake-vanti.prd_del_bi.facturacion_d` d ON r.num_doc_oficial = d.num_doc_oficial
LEFT JOIN `datalake-vanti.prd_del_bi.fi_ca` ca ON r.num_doc_oficial = ca.num_doc_oficial
WHERE r.fec_contab_documento = '2021-04-28'  AND r.num_doc_oficial = 'F24I3269800' 
GROUP BY 1,2,3,4,5,6,7,8,9,10
--PARTITION BY
--CLUSTER BY