WITH dropped_recipients AS (
    SELECT DISTINCT recipient, emailcampaignid
    FROM {{ ref('stg_hubspot__all_event') }}
    WHERE event_type = 'DROPPED'
),
bounced_recipients AS (
    SELECT DISTINCT recipient, emailcampaignid
    FROM {{ ref('stg_hubspot__all_event') }}
    WHERE event_type = 'BOUNCE'
      AND category IN ('UNKNOWN_USER', 'SPAM', 'POLICY', 'IP_REPUTATION', 'MAILBOX_FULL')
      AND obsoletedBy_id = 'nan'
)
SELECT
    e.recipient,
    e.campaign_id,
    CASE
      WHEN dr.recipient IS NOT NULL THEN 'Dropped'
      WHEN br.recipient IS NOT NULL THEN 'Bounced'
      ELSE 'Other'
    END AS recipient_status
FROM {{ ref('stg_hubspot__all_event') }} e
LEFT JOIN dropped_recipients dr
ON e.recipient = dr.recipient AND e.campaign_id = dr.emailcampaignid
LEFT JOIN bounced_recipients br
ON e.recipient = br.recipient AND e.campaign_id = br.emailcampaignid
