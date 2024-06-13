
--IRPA002
CREATE TABLE IF NOT EXISTS `datalake-vanti.integracion_suplos.t1` (
    status_recepcion STRING OPTIONS(description="Mensaje Recepción")
    , sociedad STRING OPTIONS(description="Sociedad")
    , numero_factura STRING OPTIONS(description="Número de documento de referencia")
    , clase_documento STRING OPTIONS(description="Clase de documento")
    , fecha_documento DATE OPTIONS(description="Fecha de documento en documento")
    , fecha_radicado DATE OPTIONS(description="Fecha")
    , socio_comercial STRING OPTIONS(description="Número de socio comercial")
    , identificador_proveedor STRING OPTIONS(description="Número de identificación fiscal 1")
    , identificador_soc_vanti STRING OPTIONS(description="Número de identificación fiscal 1")
    , importe_neto NUMERIC OPTIONS(description="Importe neto")
    , moneda STRING OPTIONS(description="Clave de moneda")
    , numero_empleado STRING OPTIONS(description="Número de personal")
    , pedido_compra STRING OPTIONS(description="Número del documento de compras")
    , numero_contrato STRING OPTIONS(description="Numero de contrato")
    , base_importe_iva NUMERIC OPTIONS(description="Importe IVA iRPA")
);

INSERT INTO `datalake-vanti.integracion_suplos.t1` (status_recepcion, sociedad, numero_factura, clase_documento, fecha_documento, fecha_radicado, socio_comercial, identificador_proveedor, identificador_soc_vanti, importe_neto, moneda, numero_empleado, pedido_compra, numero_contrato, base_importe_iva)
SELECT 
    NULLIF(MSG, "")
    , NULLIF(BUKRS, "")
    , NULLIF(XBLNR, "")
    , NULLIF(BLART, "")
    , BLDAT
    , DOC_DATE_SIGNED
    , NULLIF(PARTNER, "")
    , NULLIF(STCD1, "")
    , NULLIF(STCD2, "")
    , DMBTR
    , NULLIF(WAERS, "")
    , NULLIF(PERNR, "")
    , NULLIF(EBELN, "")
    , NULLIF(CONTRATO, "")
    , IMIVA AS base_importe_iva
FROM `datalake-vanti.qa_raw_sap.zfi_t_irpa002`
WHERE (DATE(BLDAT) < DATE('1900-01-01') OR DATE(BLDAT) > DATE('2100-01-01'))
AND (DATE(DOC_DATE_SIGNED) < DATE('1900-01-01') OR DATE(DOC_DATE_SIGNED) > DATE('2100-01-01'));

-- IRPA003
CREATE TABLE IF NOT EXISTS `datalake-vanti.integracion_suplos.t2` (
      status_recepcion STRING OPTIONS(description="Mensaje Recepción")
    , sociedad STRING OPTIONS(description="Sociedad")
    , numero_factura STRING OPTIONS(description="Número de documento de referencia")
    , id_factura STRING OPTIONS(description="Id de Factura")
    , status_workflow STRING OPTIONS(description="Estado WF")
    , estado STRING OPTIONS(description="Estado de la Factura")
    , clase_documento STRING OPTIONS(description="Clase de documento")
    , fecha_documento DATE OPTIONS(description="Fecha de documento en documento")
    , fecha_radicado DATE OPTIONS(description="Fecha")
    , socio_comercial STRING OPTIONS(description="Número de socio comercial")
    , identificador_proveedor STRING OPTIONS(description="Número de identificación fiscal 1")
    , identificador_soc_vanti STRING OPTIONS(description="Número de identificación fiscal 1")
    , importe_neto NUMERIC OPTIONS(description="Importe neto")
    , moneda STRING OPTIONS(description="Clave de moneda")
    , numero_empleado STRING OPTIONS(description="Número de personal")
    , pedido_compra STRING OPTIONS(description="Número del documento de compras")
    , numero_contrato STRING OPTIONS(description="Numero de contrato")
    , base_importe_iva NUMERIC OPTIONS(description="Importe IVA IRPA")
);

INSERT INTO `datalake-vanti.integracion_suplos.t2` (status_recepcion, sociedad, numero_factura, id_factura, status_workflow, estado, clase_documento, fecha_documento, fecha_radicado, socio_comercial, identificador_proveedor, identificador_soc_vanti, importe_neto, moneda, numero_empleado, pedido_compra, numero_contrato, base_importe_iva)
SELECT 
      NULLIF(MSG, "")
    , NULLIF(BUKRS, "")
    , NULLIF(XBLNR, "")
    , NULLIF(FACT_ID, "")
    , NULLIF(STATUS, "")
    , CASE
        WHEN STATUS = "0" THEN "En Solicitante"
        WHEN STATUS = "1" THEN "Rechazado por Solicitante"
        WHEN STATUS = "2" THEN "En Aprobador"
        WHEN STATUS = "3" THEN "En Solicitante x Rechazo"
        WHEN STATUS = "4" THEN "En Cta. Pagar"
        WHEN STATUS = "5" THEN "Rechazado x Cta. Pagar"
        WHEN STATUS = "6" THEN "Contabilizado"
        ELSE "Cancelado desde transacción ZFI_IRPA003"
    END
    , NULLIF(BLART, "")
    , BLDAT
    , DOC_DATE_SIGNED
    , NULLIF(PARTNER, "")
    , NULLIF(STCD1, "")
    , NULLIF(STCD2, "")
    , DMBTR
    , NULLIF(WAERS, "")
    , NULLIF(PERNR, "")
    , NULLIF(EBELN, "")
    , NULLIF(CONTRATO, "")
    , IMIVA
FROM `datalake-vanti.qa_raw_sap.zfi_t_irpa003`
WHERE (DATE(BLDAT) < DATE('1900-01-01') OR DATE(BLDAT) > DATE('2100-01-01'))
AND (DATE(DOC_DATE_SIGNED) < DATE('1900-01-01') OR DATE(DOC_DATE_SIGNED) > DATE('2100-01-01'));
