--CREATE TABLE `datalake-vanti.integracion_suplos.t1` AS
SELECT 
NULLIF(MSG, "") AS status_recepcion
, NULLIF(BUKRS, "") AS sociedad
, NULLIF(XBLNR, "")  AS numero_factura
, NULLIF(BLART, "") AS clase_documento
, CASE
    WHEN BLDAT IS NULL THEN NULL
    WHEN DATE(BLDAT) < DATE('1900-01-01') OR DATE(BLDAT) > DATE('2100-01-01') THEN NULL
    ELSE BLDAT
  END AS fecha_documento
, CASE
    WHEN DOC_DATE_SIGNED IS NULL THEN NULL
    WHEN DATE(DOC_DATE_SIGNED) < DATE('1900-01-01') OR DATE(DOC_DATE_SIGNED) > DATE('2100-01-01') THEN NULL
    ELSE DOC_DATE_SIGNED
  END AS fecha_radicado
, NULLIF(PARTNER,"" ) AS socio_comercial
, NULLIF(STCD1, "") AS identificador_proveedor
, NULLIF(STCD2, "") AS identificador_soc_vanti
, DMBTR AS importe_neto
, NULLIF(WAERS, "") AS moneda
, NULLIF(PERNR, "") AS numero_empleado
, NULLIF(EBELN, "") AS pedido_compra
, NULLIF(CONTRATO, "") AS numero_contrato
, IMIVA AS base_importe_iva
from `datalake-vanti.qa_raw_sap.zfi_t_irpa002`
--PARTITION BY
--CLUSTER BY