WITH source_data AS 
(
  SELECT
    id AS contact_id,
    CONCAT(properties_firstname, ' ', properties_lastname) AS full_name,
    properties_createdate AS created_at,
    properties_annualrevenue AS annual_revenue,
    properties_hs_marketable_status AS marketing_contact_status,
    NULLIF(properties_country, 'None') AS country,
    NULLIF(properties_state, 'None') AS state,
    NULLIF(properties_city, 'None') AS city,
    properties_company AS company,
    properties_company_size AS company_size,
    properties_email AS email,
    properties_hs_is_unworked,
    properties_hs_lead_status AS hs_lead_status,
    properties_industry AS industry,
    properties_jobtitle AS job_title,
    properties_lastmodifieddate AS last_modified_at,
    properties_phone AS phonse,
    properties_total_revenue AS total_revenue
  FROM `datapilot-datadrivenmarketing`.`hubspot_tables`.`contacts_table`
)

SELECT * FROM source_data
