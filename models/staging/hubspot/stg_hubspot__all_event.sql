WITH aggregated_events AS (
    SELECT 
        recipient,
        type AS event_type,
        sentBy_created,
        sentBy_id,
        MAX(obsoletedBy_id) AS obsoletedBy_id,
        MAX(emailCampaignId) AS campaign_id,
        MAX(`from`) AS from_name,
        MAX(created) AS created_at, --- Take the maximum creation timestamp for the grouped events
        MAX(id) AS event_id,
        MAX(deviceType) AS device_type,
        MAX(browser_type) AS browser_type,
        MAX(dropMessage) AS dropMessage,
        MAX(dropReason) AS dropReason,
        MAX(bounced) AS bounced,
        MAX(response) AS response,
        MAX(attempt) AS attempt,
        MAX(category) AS category,
        MAX(suppressedMessage) AS suppressedMessage,
        MAX(suppressedReason) AS suppressedReason,
        MAX(filteredEvent) AS filteredEvent,
        -- Use CASE to replace 'UNKNOWN' and 'nan' with NULL in location_country and location_city
        MAX(CASE 
                WHEN location_country IN ('UNKNOWN', 'nan') THEN NULL 
                ELSE location_country 
            END) AS location_country,
        MAX(CASE 
                WHEN location_city IN ('UNKNOWN', 'nan') THEN NULL 
                ELSE location_city 
            END) AS location_city
    FROM 
        `datapilot-datadrivenmarketing`.`hubspot_tables`.`all_events_table`
    WHERE 
        browser_type != 'Robot'
        AND filteredEvent != 'True'
    GROUP BY 
        recipient, 
        event_type,
        sentBy_created,
        sentBy_id
)

SELECT 
    ae.*
FROM 
    aggregated_events ae
WHERE 
    -- Include all other event types that are not DELIVERED, BOUNCE, or SENT
    (ae.event_type NOT IN ('DELIVERED', 'BOUNCE', 'SENT'))
    
    OR
    -- Include SENT events where obsoletedBy_id is 'nan' (i.e., not obsolete) and no corresponding DROPPED event exists    (ae.event_type = 'SENT' AND ae.obsoletedBy_id = 'nan' AND NOT EXISTS (
      (ae.event_type = 'SENT' AND ae.obsoletedBy_id = 'nan' AND NOT EXISTS (        
            SELECT 1
            FROM `datapilot-datadrivenmarketing`.`hubspot_tables`.`all_events_table` dr
            WHERE dr.recipient = ae.recipient 
              AND dr.emailCampaignId = ae.campaign_id
              AND dr.type = 'DROPPED'
         ))
    -- This condition includes SENT events only if they are not obsolete (obsoletedBy_id = 'nan') and if the event was not dropped.

    OR
    -- Include DELIVERED events only if there is no corresponding BOUNCE event with the specified categories
    (ae.event_type = 'DELIVERED' AND NOT EXISTS (
        SELECT 1
        FROM `datapilot-datadrivenmarketing`.`hubspot_tables`.`all_events_table` br 
        WHERE br.recipient = ae.recipient 
          AND br.emailCampaignId = ae.campaign_id
          AND br.type = 'BOUNCE'
          AND br.category IN ('UNKNOWN_USER', 'SPAM', 'POLICY', 'IP_REPUTATION', 'MAILBOX_FULL')
          AND br.obsoletedBy_id = 'nan'
    ))
    -- This condition includes DELIVERED events only if there is no BOUNCE event with certain categories (e.g., spam, policy issues) associated with it.
    
    OR
    -- Include BOUNCE events where obsoletedBy_id is 'nan' (i.e., the event is not obsolete)
    (ae.event_type = 'BOUNCE' AND ae.obsoletedBy_id = 'nan')
    -- This condition includes BOUNCE events only if they are not obsolete.


