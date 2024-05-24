SELECT 
ca.clase_documento
,ca.num_doc_oficial
,r.ent_vol_calculo
,(d.impor_variable/NULLIF(d.ent_vol_calculo, 0))
,r.impor_mon_transaccion
,(r.tot_partida_de_factura_incluido-impor_mon_transaccion)
,tot_partida_de_factura_incluido
,fec_inic_validez
,fec_fin_validez
,fec_venci_neto
,MAX(fec_compensacion)
,SUM(imp_mon_local)
,CASE WHEN AVG(CAST(sts_compensacion AS int)) = 9 THEN "pago total"
    WHEN AVG(CAST(sts_compensacion AS int)) > 0 THEN "pago parcial"
    ELSE "no pago" END AS estado_pago
FROM datalake-vanti.prd_del_bi.facturacion_r r
LEFT JOIN datalake-vanti.prd_del_bi.facturacion_d d ON r.num_doc_oficial = d.num_doc_oficial
LEFT JOIN datalake-vanti.prd_del_bi.fi_ca ca ON r.num_doc_oficial = ca.num_doc_oficial
WHERE r.fec_contab_documento = '2021-04-28'  AND r.num_doc_oficial = 'F24I3269800' 
GROUP BY 1,2,3,4,5,6,7,8,9,10
LIMIT 10