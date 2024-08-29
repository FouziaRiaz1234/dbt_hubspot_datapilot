SELECT
    c.campaign_id,
    c.campaign_name,
    c.campaign_type,
    c.content_id,
    m.ab,
    m.archivedInDashboard,
    m.email_id,
    m.email_name,
    m.subject AS marketing_email_subject,
    m.created AS marketing_email_createdAt,
FROM
    {{ ref('stg_hubspot__campaigns') }} c
LEFT JOIN
    {{ ref('stg_hubspot__marketing_email') }} m
ON
    c.content_id = m.email_id
WHERE email_id IS NOT NULL
