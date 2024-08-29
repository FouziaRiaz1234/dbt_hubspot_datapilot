WITH email_campaign AS (
    SELECT
        m.campaign_id,
        m.campaign_name,
        m.campaign_type,
        m.content_id,
        m.ab,
        m.email_id,
        m.email_name,
        m.marketing_email_subject,
        m.marketing_email_createdAt
    FROM
        {{ ref('int_hubspot__marketing_campaign_email') }} m
),

email_events AS (
    SELECT DISTINCT
        e.sentBy_created,
        e.browser_type,
        e.obsoletedBy_id,
        e.filteredEvent,
        e.event_type,
        e.recipient,
        e.dropMessage,
        e.dropReason,
        e.bounced,
        e.response,
        e.attempt,
        e.category AS event_category,
        e.suppressedMessage,
        e.suppressedReason,
        m.campaign_name,
        m.campaign_type,
        m.content_id,
        m.ab,
        m.email_id,
        m.campaign_id,
        m.email_name,
        m.marketing_email_subject,
        m.marketing_email_createdAt AS marketing_email_created_at
    FROM
        {{ ref('stg_hubspot__all_event') }} e
    INNER JOIN
        {{ ref('int_hubspot__marketing_campaign_email') }} m
    ON
        e.campaign_id = m.campaign_id
)
SELECT 
    *
FROM 
    email_events
    
