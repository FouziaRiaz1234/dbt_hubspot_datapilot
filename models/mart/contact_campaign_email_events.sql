WITH email_campaign_events AS (
    SELECT * 
    FROM {{ ref('int_hubspot__campaign_email_events_aggregated') }} ca
),

contacts AS (
    SELECT * 
    FROM {{ ref('int_hubspot__merged_contact_list') }} co
)

SELECT 
    ca.*,  -- Select all columns from email_campaign_events
    co.*   -- Select all columns from contacts
FROM 
    email_campaign_events ca
LEFT JOIN 
    contacts co
ON 
    ca.recipient = co.email
