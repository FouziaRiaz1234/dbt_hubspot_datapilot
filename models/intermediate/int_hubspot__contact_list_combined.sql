ITH contact_data AS (
    SELECT
        contact_id,
        full_name,
        email,
        annual_revenue,
        country,
        state,
        city,
        company,
        company_size,
        hs_lead_status,
        industry,
        job_title,
        last_modified_at,
        phone,
        total_revenue
    FROM {{ ref('stg_hubspot__contacts') }}
),

contact_list_data AS (
    SELECT
        contact_list_id,
        list_name,
        list_type,
        list_size
    FROM {{ ref('stg_hubspot__contacts_list') }}
),

contact_list_membership_data AS (
    SELECT
        contact_list_id,
        contact_id,
        is_member
    FROM {{ ref('stg_hubspot__contacts_list_membership') }}
)

SELECT
    cd.contact_id,
    cd.full_name,
    cd.email,
    cd.annual_revenue,
    cd.country,
    cd.state,
    cd.city,
    cd.company,
    cd.company_size,
    cd.hs_lead_status,
    cd.industry,
    cd.job_title,
    cd.last_modified_at,
    cd.phone,
    cd.total_revenue,
    cld.contact_list_id,
    cld.list_name,
    cld.list_type,
    cld.list_size,
    clmd.is_member
FROM
    contact_data cd
LEFT JOIN
    contact_list_membership_data clmd
ON
    cd.contact_id = clmd.contact_id
LEFT JOIN
    contact_list_data cld
ON
    clmd.contact_list_id = cld.contact_list_id
