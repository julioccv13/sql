SELECT 
msg AS status_recepcion
, BUKRS AS sociedad
, XBLNR  AS numero_factura
, BLART AS clase_documento
, BLDAT AS fecha_documento
, DOC_DATE_SIGNED AS fecha_radicado
, PARTNER AS socio_comercial
, STCD1 AS identificador_proveedor
, STCD2 AS identificador_soc_vanti
, DMBTR AS importe_neto
, WAERS AS moneda
, PERNR AS numero_empleado
, EBELN AS pedido_compra
, CONTRATO AS numero_contrato
, IMIVA AS base_importe_iva
from datalake-vanti.qa_raw_sap.zfi_t_irpa002