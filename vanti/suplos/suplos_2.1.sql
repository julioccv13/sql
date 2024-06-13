--CREATE TABLE `datalake-vanti.integracion_suplos.t2` AS
SELECT 
NULLIF(MSG, "") AS status_recepcion
, NULLIF(BUKRS, "") AS sociedad
, NULLIF(XBLNR, "")  AS numero_factura
, NULLIF(FACT_ID, "") AS id_factura
, NULLIF(STATUS, "") AS status_workflow
, CASE
    WHEN STATUS = "0" THEN "En Solicitante"
    WHEN STATUS = "1" THEN "Rechazado por Solicitante"
    WHEN STATUS = "2" THEN "En Aprobador"
    WHEN STATUS = "3" THEN "En Solicitante x Rechazo"
    WHEN STATUS = "4" THEN "En Cta. Pagar"
    WHEN STATUS = "5" THEN "Rechazado x Cta. Pagar"
    WHEN STATUS = "6" THEN "Contabilizado"
    ELSE "Cancelado desde transacción ZFI_IRPA003"
  END AS estado
, NULLIF(BLART, "") AS clase_documento
, BLDAT AS fecha_documento
, DOC_DATE_SIGNED AS fecha_radicado
, NULLIF(PARTNER,"" ) AS socio_comercial
, NULLIF(STCD1, "") AS identificador_proveedor
, NULLIF(STCD2, "") AS identificador_soc_vanti
, DMBTR AS importe_neto
, NULLIF(WAERS, "") AS moneda
, NULLIF(PERNR, "") AS numero_empleado
, NULLIF(EBELN, "") AS pedido_compra
, NULLIF(CONTRATO, "") AS numero_contrato
, IMIVA AS base_importe_iva
from `datalake-vanti.qa_raw_sap.zfi_t_irpa003`
WHERE DATE(BLDAT) < DATE('1900-01-01') OR DATE(BLDAT) > DATE('2100-01-01')
AND DATE(DOC_DATE_SIGNED) < DATE('1900-01-01') OR DATE(DOC_DATE_SIGNED) > DATE('2100-01-01') 
--PARTITION BY
--CLUSTER BY