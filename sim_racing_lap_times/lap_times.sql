SELECT 
    lapNum + 1 AS lap,
    CASE WHEN MAX(lap_time_invalid) = 1 THEN 'No' ELSE 'Yes' END AS lap_valid,
    CONCAT(
        LPAD(CAST(FLOOR(MAX(lap_time) / 60) AS STRING), 2, '0'), ':',
        LPAD(CAST(FLOOR(MAX(l.lap_time - FLOOR(l.lap_time / 60) * 60) AS STRING), 2, '0'), '.',
        LPAD(CAST(ROUND((MAX(l.lap_time) - FLOOR(MAX(l.lap_time))) * 1000) AS STRING), 3, '0')
    ) AS lap_time
FROM 
    `2024-07-02_lagunaseca`
WHERE 
    validBin = 1
GROUP BY 
    lapNum
ORDER BY 
    lapNum