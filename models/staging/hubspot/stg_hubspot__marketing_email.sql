WITH source_data AS

( SELECT
    archivedInDashboard,
    currentlyPublished,
    ab,
    id AS email_id,
    name AS email_name,
    emailType AS email_type,
    subcategory,
    subject,
    fromName AS from_name,
    created,
    publishedAt AS published_at,
    author,
    authorName,
    categoryId AS email_category_id,
    contentTypeCategory,
    currentState,
    mailingListsExcluded,
    mailingListsIncluded,
    subscription,
    subscriptionName,
    vidsExcluded,
    vidsIncluded,
    primaryEmailCampaignId,
    emailCampaignGroupId,
    campaign,
    campaignName,
    campaignUtm
 
 FROM `datapilot-datadrivenmarketing`.`hubspot_tables`.`marketing_email_table`
 )

SELECT * from source_data
WHERE archivedInDashboard = 'False'
AND email_name != 'Upgrade Your Marketing Game'

