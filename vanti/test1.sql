select 
ca.clase_documento
,ca.num_doc_oficial
,r.ent_vol_calculo
,(d.impor_variable/d.ent_vol_calculo)
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
from datalake-vanti.prd_del_bi.facturacion_r r
join datalake-vanti.prd_del_bi.facturacion_d d on r.id_facturacion_r = d.id_facturacion_d
join datalake-vanti.prd_del_bi.fi_ca ca on r.id_facturacion_r = id_fi_ca
where r.fec_contab_documento = '2023-06-23' and r.id_facturacion_r = "60005817-623003680463-520020402200-1000270731-400002944"
group by 1,2,3,4,5,6,7,8,9,10

