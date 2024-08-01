INSERT INTO `tough-healer-395417.analytics_287163560.homepage_clicks` (
  event_category,
  event_subcategory,
  date,
  user_pseudo_id,
  session_id,
  transactions,
  revenue
)
WITH homepage_clicks AS (
    SELECT
        user_pseudo_id,
        CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING) AS session_id,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_category') AS event_category,
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_subcategory') AS event_subcategory,
        PARSE_DATE('%Y%m%d', event_date) AS date
    FROM
        `tough-healer-395417.analytics_287163560.events_*`
    WHERE
        event_name = 'homepage_clicks'
        AND geo.country != 'India'
        AND device.web_info.hostname = 'www.laithwaites.com'
        AND _TABLE_SUFFIX BETWEEN '20240501' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
),
homepage_clicks_purchase AS (
    SELECT
        hc.session_id,
        hc.user_pseudo_id,
        hc.event_category,
        hc.event_subcategory,
        hc.date,
        SUM(CASE WHEN p.event_name = 'purchase' THEN 1 ELSE 0 END) AS transactions,
        SUM(CASE WHEN p.event_name = 'purchase' THEN p.ecommerce.purchase_revenue ELSE 0 END) AS revenue
    FROM
        homepage_clicks hc
    LEFT JOIN
        `tough-healer-395417.analytics_287163560.events_*` p
    ON
        hc.user_pseudo_id = p.user_pseudo_id
        AND CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS STRING) = hc.session_id
    WHERE
        _TABLE_SUFFIX BETWEEN '20240501' AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    GROUP BY
        hc.session_id, hc.user_pseudo_id, hc.event_category, hc.event_subcategory, hc.date
)
SELECT
    event_category,
    event_subcategory,
    date,
    user_pseudo_id,
    session_id,
    SUM(transactions) AS transactions,
    SUM(revenue) AS revenue
FROM
    homepage_clicks_purchase
GROUP BY
    event_category, event_subcategory, date, user_pseudo_id, session_id
ORDER BY
    date DESC;