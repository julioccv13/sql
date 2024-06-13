SELECT 
  NULLIF(W.BUKRS, "") AS SOCIEDAD,
  W.BELNR AS CONTADOR,
  NULLIF(W.HKONT, "") AS "0GL_ACCOUNT",
  NULLIF(BS.XREF2, "") AS "0COMP_CODE",
  W.GJAHR AS EJERCICIO,
  BS.H_MONAT AS PERIODO,
  W.BUZEI AS POSICION,
  NULLIF(W.WITHT, "") AS TIPO_RETENCION,
  NULLIF(W.WT_WITHCD, "") AS IND_RETENCION,
  FW.WT_QSSHH AS BASE,
  W.WT_QBSHH AS IMP_RETENCION,
  W.WT_QSFHH AS IMP_EXEN_IMP,
  NULLIF(BU.BU_SORT1, "") AS XREF1,
  CASE
      WHEN BU.TYPE = '1' THEN CONCAT(BU.NAME_LAST, '', BU.NAME_LAST2, '', BU.NAME_FIRST, BU.NAMEMIDDLE)
      WHEN BU.TYPE = '2' THEN CONCAT(BU.NAME_ORG1, '', BU.NAME_ORG2, '', BU.NAME_ORG3, '', BU.NAME_ORG4)
      ELSE CONCAT(BU.NAME_GRP1, '', BU.NAME_GRP2)
  END AS XREF3,
  NULLIF(BS.H_BLART, "") AS CLASE_DOCUMENTO,
  BS.H_BLDAT AS FECHA_DOC,
  BS.H_BUDAT AS FECHA_CONT,
  NULLIF(BS.PSWSL, "") AS MONEDA_LOCAL,
  BS.DMBTR AS VALOR_MONEDA,
  NULLIF(BS.SHKZG, "") AS DEBE_HABER,
  NULLIF(T.WAERS, "") AS MONEDA_2,
  NULLIF(BK.WAERS, "") AS MONEDA_3,
  NULLIF(TU.TEXT40, "") AS TEXTO,
  TZ.QSATZ AS PORCENTAJE,
  NULLIF(TT.LAND1, "") AS PAIS,
  NULLIF(TT.SPRAS, "") AS IDIOMA
FROM
  `qa_raw_sap.with_item` W 
JOIN
  `qa_raw_sap.bseg` BS
  ON W.BELNR = BS.BELNR
  AND W.MANDT = BS.MANDT
  AND W.HKONT = BS.HKONT
  AND W.BUKRS = BS.BUKRS
  AND W.GJAHR = BS.GJAHR
JOIN
  `qa_raw_sap.t001` T
  ON W.BUKRS = T.BUKRS
  AND W.MANDT = T.MANDT
JOIN
  `qa_raw_sap.bkpf` BK
  ON W.BELNR = BK.BELNR
  AND W.BUKRS = BK.BUKRS
  AND W.MANDT = BK.MANDT
  AND W.GJAHR = BK.GJAHR
JOIN `qa_raw_sap.t059z` TZ
  ON W.WITHT = TZ.WITHT
  AND W.WT_WITHCD = TZ.WT_WITHCD
  AND W.MANDT = TZ.MANDT
JOIN `qa_raw_sap.t059zt` TT
  ON W.WITHT = TT.WITHT
  AND W.WT_WITHCD = TT.WT_WITHCD
  AND W.MANDT = TT.MANDT
JOIN `qa_raw_sap.t059u` TU
  ON W.WITHT = TU.WITHT
  AND W.MANDT = TU.MANDT
JOIN `qa_raw_sap.but000` BU
  ON W.WT_ACCO = BU.PARTNER
  AND W.MANDT = BU.CLIENT
WHERE (DATE(BLDAT) < DATE('1900-01-01') OR DATE(BLDAT) > DATE('2100-01-01'))
AND (DATE(BUDAT) < DATE('1900-01-01') OR DATE(BUDAT) > DATE('2100-01-01'));