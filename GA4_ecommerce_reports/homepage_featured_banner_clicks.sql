WITH featured_left AS (
    SELECT
        user_pseudo_id,
        (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
        event_date
    FROM
        `tough-healer-395417.analytics_287163560.events_*`
    WHERE
        event_name = 'homepage_clicks'
        AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_category') = 'Homepage_Unidentified'
        AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_subcategory') = 'Featured_Left_Click'
        AND geo.country != 'India'
        AND device.web_info.hostname = 'www.laithwaites.com'
        AND _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)) AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
),
featured_middle AS (
    SELECT
        user_pseudo_id,
        (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
        event_date
    FROM
        `tough-healer-395417.analytics_287163560.events_*`
    WHERE
        event_name = 'homepage_clicks'
        AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_category') = 'Homepage_Unidentified'
        AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_subcategory') = 'Featured_Middle_Click'
        AND geo.country != 'India'
        AND device.web_info.hostname = 'www.laithwaites.com'
        AND _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)) AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
),
featured_right AS (
    SELECT
        user_pseudo_id,
        (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
        event_date
    FROM
        `tough-healer-395417.analytics_287163560.events_*`
    WHERE
        event_name = 'homepage_clicks'
        AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_category') = 'Homepage_Unidentified'
        AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_subcategory') = 'Featured_Right_Click'
        AND geo.country != 'India'
        AND device.web_info.hostname = 'www.laithwaites.com'
        AND _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)) AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
),
featured_click_purchase AS (
    SELECT
        fl.session_id,
        fl.user_pseudo_id,
        fl.event_date,
        'Featured Left' AS banner_click,
        SUM(CASE WHEN p.event_name = 'purchase' THEN 1 ELSE 0 END) AS transactions,
        SUM(CASE WHEN p.event_name = 'purchase' THEN p.ecommerce.purchase_revenue ELSE 0 END) AS revenue
    FROM
        `tough-healer-395417.analytics_287163560.events_*` p
    JOIN
        featured_left fl
    ON
        p.user_pseudo_id = fl.user_pseudo_id
        AND (SELECT value.int_value FROM UNNEST(p.event_params) WHERE key = 'ga_session_id') = fl.session_id
    WHERE
        _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)) AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
    GROUP BY
        fl.session_id, fl.user_pseudo_id, fl.event_date

    UNION ALL

    SELECT
        fm.session_id,
        fm.user_pseudo_id,
        fm.event_date,
        'Featured Middle' AS banner_click,
        SUM(CASE WHEN p.event_name = 'purchase' THEN 1 ELSE 0 END) AS transactions,
        SUM(CASE WHEN p.event_name = 'purchase' THEN p.ecommerce.purchase_revenue ELSE 0 END) AS revenue
    FROM
        `tough-healer-395417.analytics_287163560.events_*` p
    JOIN
        featured_middle fm
    ON
        p.user_pseudo_id = fm.user_pseudo_id
        AND (SELECT value.int_value FROM UNNEST(p.event_params) WHERE key = 'ga_session_id') = fm.session_id
    WHERE
        _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)) AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
    GROUP BY
        fm.session_id, fm.user_pseudo_id, fm.event_date

    UNION ALL

    SELECT
        fr.session_id,
        fr.user_pseudo_id,
        fr.event_date,
        'Featured Right' AS banner_click,
        SUM(CASE WHEN p.event_name = 'purchase' THEN 1 ELSE 0 END) AS transactions,
        SUM(CASE WHEN p.event_name = 'purchase' THEN p.ecommerce.purchase_revenue ELSE 0 END) AS revenue
    FROM
        `tough-healer-395417.analytics_287163560.events_*` p
    JOIN
        featured_right fr
    ON
        p.user_pseudo_id = fr.user_pseudo_id
        AND (SELECT value.int_value FROM UNNEST(p.event_params) WHERE key = 'ga_session_id') = fr.session_id
    WHERE
        _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)) AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
    GROUP BY
        fr.session_id, fr.user_pseudo_id, fr.event_date
)
SELECT
    banner_click,
    event_date AS date,
    COUNT(DISTINCT user_pseudo_id) AS total_users,
    COUNT(DISTINCT session_id) AS total_sessions,
    SUM(transactions) AS total_transactions,
    SUM(revenue) AS total_revenue
FROM
    featured_click_purchase
GROUP BY
    banner_click, event_date
ORDER BY
    event_date;
