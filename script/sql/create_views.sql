CREATE OR REPLACE VIEW VA_BAILLEUR AS
SELECT t.bai_id AS "IDENTIFIANT",t.bai_code AS "CODE",t.bai_designation AS "LIBELLE"
FROM bailleur@dblink_elabo_bidf t;

CREATE OR REPLACE VIEW VA_SOURCE_FINANCEMENT AS
SELECT t.sfin_id AS "IDENTIFIANT",t.sfin_code AS "CODE",t.sfin_liblg AS "LIBELLE"
FROM source_financement@dblink_elabo_bidf t;

CREATE OR REPLACE VIEW VA_NATURE_ECONOMIQUE AS
SELECT t.nat_id AS "IDENTIFIANT",t.nat_code AS "CODE",t.nat_liblg AS "LIBELLE"
FROM nature_economique@dblink_elabo_bidf t;

CREATE OR REPLACE VIEW VA_NATURE_DEPENSE AS
SELECT t.ndep_id AS "IDENTIFIANT",t.ndep_code AS "CODE",t.ndep_liblg AS "LIBELLE"
FROM nature_depenses@dblink_elabo_bidf t;

CREATE OR REPLACE VIEW VA_SECTION AS
SELECT t.secb_id AS "IDENTIFIANT",t.secb_num AS "CODE",t.secb_liblg AS "LIBELLE"
FROM section_budgetaire@dblink_elabo_bidf t;

CREATE OR REPLACE VIEW VA_UNITE_ADMINISTRATIVE AS
SELECT t.ua_id AS "IDENTIFIANT",t.ua_code AS "CODE",t.ua_liblg AS "LIBELLE"
,t.secb_id AS "SECTION_IDENTIFIANT",s.secb_num||' '||s.secb_liblg AS "SECTION_CODE_LIBELLE"
FROM unite_administrative@dblink_elabo_bidf t
LEFT JOIN section_budgetaire@dblink_elabo_bidf s ON s.secb_id = t.secb_id;

CREATE OR REPLACE VIEW VA_TYPE_USB AS
SELECT t.uuid AS "IDENTIFIANT",t.tusb_code AS "CODE",t.tusb_liblg AS "LIBELLE"
FROM type_usb@dblink_elabo_bidf t;

CREATE OR REPLACE VIEW VA_CATEGORIE_USB AS
SELECT t.uuid AS "IDENTIFIANT",t.cusb_code AS "CODE",t.cusb_lib AS "LIBELLE"
,tu.uuid AS "TYPE_IDENTIFIANT",tu.tusb_code||' '||tu.tusb_liblg AS "TYPE_CODE_LIBELLE"
FROM categorie_usb@dblink_elabo_bidf t
LEFT JOIN type_usb@dblink_elabo_bidf tu ON tu.uuid = t.tusb_id;

CREATE OR REPLACE VIEW VA_UNITE_SPECIALISATION_BUDGET AS
SELECT usb.usb_id AS "IDENTIFIANT",usb.usb_code AS "CODE",usb.usb_liblg AS "LIBELLE"
,c.uuid AS "CATEGORIE_IDENTIFIANT",c.cusb_code||' '||c.cusb_lib AS "CATEGORIE_CODE_LIBELLE"
,tu.uuid AS "TYPE_IDENTIFIANT",tu.tusb_code||' '||tu.tusb_liblg AS "TYPE_CODE_LIBELLE"
,s.secb_id AS "SECTION_IDENTIFIANT",s.secb_num AS "SECTION_CODE",s.secb_num||' '||s.secb_liblg AS "SECTION_CODE_LIBELLE"
FROM unite_spec_bud@dblink_elabo_bidf usb
LEFT JOIN section_budgetaire@dblink_elabo_bidf s ON s.secb_id = usb.secb_id
LEFT JOIN categorie_usb@dblink_elabo_bidf c ON c.uuid = usb.cusb_code
LEFT JOIN type_usb@dblink_elabo_bidf tu ON tu.uuid = c.tusb_id;

CREATE OR REPLACE VIEW VA_ACTION AS
SELECT t.adp_id AS "IDENTIFIANT",t.adp_code AS "CODE",t.adp_liblg AS "LIBELLE"
,s.secb_id AS "SECTION_IDENTIFIANT",s.secb_num||' '||s.secb_liblg AS "SECTION_CODE_LIBELLE"
,usb.usb_id AS "USB_IDENTIFIANT",usb.usb_code||' '||usb.usb_liblg AS "USB_CODE_LIBELLE"
FROM action@dblink_elabo_bidf t
LEFT JOIN unite_spec_bud@dblink_elabo_bidf usb ON usb.usb_id = t.usb_id
LEFT JOIN section_budgetaire@dblink_elabo_bidf s ON s.secb_id = usb.secb_id;

CREATE OR REPLACE VIEW VA_ACTIVITE AS
SELECT t.ads_id AS "IDENTIFIANT",t.ads_code AS "CODE",t.ads_liblg AS "LIBELLE"
,t.ndep_id AS "NATURE_DEPENSE_IDENTIFIANT",n.ndep_code||' '||n.ndep_liblg AS "NATURE_DEPENSE_CODE_LIBELLE"
,t.catv_id AS "CA_IDENTIFIANT",ca.catv_code||' '||ca.catv_libelle AS "CA_CODE_LIBELLE"
,t.adp_id AS "ACTION_IDENTIFIANT",a.adp_code||' '||a.adp_liblg AS "ACTION_CODE_LIBELLE"
,u.usb_id AS "USB_IDENTIFIANT",u.usb_code||' '||u.usb_liblg AS "USB_CODE_LIBELLE"
FROM activite_de_service@dblink_elabo_bidf t
LEFT JOIN categorie_activite@dblink_elabo_bidf ca ON ca.catv_id = t.catv_id
LEFT JOIN nature_depenses@dblink_elabo_bidf n ON n.ndep_id = t.ndep_id
LEFT JOIN action@dblink_elabo_bidf a ON a.adp_id = t.adp_id
LEFT JOIN unite_spec_bud@dblink_elabo_bidf u ON u.usb_id = a.usb_id;

CREATE OR REPLACE VIEW VA_LIGNE_DEPENSE AS
SELECT fd.find_id AS "IDENTIFIANT"
,a.ads_id AS "ACTIVITE_IDENTIFIANT",a.ads_code AS "ACTIVITE_CODE",a.ads_code||' '||a.ads_liblg AS "ACTIVITE_CODE_LIBELLE"
,ne.nat_id AS "NATURE_ECONOMIQUE_IDENTIFIANT",ne.nat_code AS "NATURE_ECONOMIQUE_CODE",ne.nat_code||' '||ne.nat_liblg AS "NATURE_ECONOMIQUE_CODE_LIBELLE"
,sf.sfin_id AS "SOURCE_FINANCEMENT_IDENTIFIANT",sf.sfin_code AS "SOURCE_FINANCEMENT_CODE",sf.sfin_code||' '||sf.sfin_liblg AS "SF_CODE_LIBELLE"
,b.bai_id AS "BAILLEUR_IDENTIFIANT",b.bai_code AS "BAILLEUR_CODE",b.bai_code||' '||b.bai_designation AS "BAILLEUR_CODE_LIBELLE"
,nd.ndep_id AS "NATURE_DEPENSE_IDENTIFIANT",nd.ndep_code AS "NATURE_DEPENSE_CODE",nd.ndep_code||' '||nd.ndep_liblg AS "NATURE_DEPENSE_CODE_LIBELLE"
,ac.adp_id AS "ACTION_IDENTIFIANT",ac.adp_code AS "ACTION_CODE",ac.adp_code||' '||ac.adp_liblg AS "ACTION_CODE_LIBELLE"
,u.usb_id AS "USB_IDENTIFIANT",u.usb_code AS "USB_CODE",u.usb_code||' '||u.usb_liblg AS "USB_CODE_LIBELLE"
,s.secb_id AS "SECTION_IDENTIFIANT",s.secb_num AS "SECTION_CODE",s.secb_num||' '||s.secb_liblg AS "SECTION_CODE_LIBELLE"
,fd.FIND_BVOTE_AE AS "BUDGET_INITIAL_AE",fd.FIND_BVOTE_CP AS "BUDGET_INITIAL_CP"
,fd.FIND_MONTANT_AE AS "BUDGET_ACTUEL_AE",fd.FIND_MONTANT_CP AS "BUDGET_ACTUEL_CP"
FROM financement_depenses@dblink_elabo_bidf fd
LEFT JOIN ligne_de_depenses@dblink_elabo_bidf ld ON ld.ldep_id = fd.ldep_id
LEFT JOIN activite_de_service@dblink_elabo_bidf a ON a.ads_id = ld.ads_id
LEFT JOIN nature_depenses@dblink_elabo_bidf nd ON nd.ndep_id = a.ndep_id
LEFT JOIN nature_economique@dblink_elabo_bidf ne ON ne.nat_id = ld.nat_id
LEFT JOIN source_financement@dblink_elabo_bidf sf ON sf.sfin_id = fd.sfin_id
LEFT JOIN bailleur@dblink_elabo_bidf b ON b.bai_id = fd.bai_id
LEFT JOIN action@dblink_elabo_bidf ac ON ac.adp_id = a.adp_id
LEFT JOIN unite_spec_bud@dblink_elabo_bidf u ON u.usb_id = ac.usb_id
LEFT JOIN section_budgetaire@dblink_elabo_bidf s ON s.secb_id = u.secb_id;

CREATE OR REPLACE VIEW VA_LIGNE_DEPENSE_DISPONIBLE AS
SELECT fd.find_id AS "IDENTIFIANT",0 AS "AE",0 AS "CP"
FROM financement_depenses@dblink_elabo_bidf fd;