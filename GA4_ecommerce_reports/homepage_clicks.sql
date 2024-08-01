--CTE filtering homepage_clicks event
WITH homepage_clicks AS (
  SELECT
  	user_pseudo_id,
  	(SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
  	--column to include all values for event_category (logged-in or logged-out)
  	(SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_category') AS event_category,
  	--column to include all values for event_subcategory (banner location)
  	(SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'event_subcategory') AS event_subcategory,
  FROM
  	`tablename`
  WHERE
  	--filters for homepage_clicks event
  	event_name = 'homepage_clicks'
)
--joining transactions and revenue with users and sessions from the homepage_clicks CTE
SELECT
	hc.event_category,
	hc.event_subcategory,
	COUNT(DISTINCT hc.user_pseudo_id) AS total_users,
	COUNT(DISTINCT CONCAT(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id'))) as sessions,    
	SUM(CASE WHEN p.event_name = 'purchase' THEN 1 ELSE 0 END) AS transactions,
	SUM(CASE WHEN p.event_name = 'purchase' THEN p.ecommerce.purchase_revenue ELSE 0 END) AS revenue
FROM
	homepage_clicks hc
LEFT JOIN
	`table name` p
ON
	hc.user_pseudo_id = p.user_pseudo_id
	AND hc.session_id = (SELECT value.int_value FROM UNNEST(p.event_params) WHERE key = 'ga_session_id')
GROUP BY
	hc.event_category, hc.event_subcategory;
