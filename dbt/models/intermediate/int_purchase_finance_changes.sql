{{ config(materialized='table') }}

SELECT

    c.changelog_id,
    c.purchase_id,

    p.current_finance_uuid,

    c.old_finance_uuid,
    c.new_finance_uuid,

    p.purchase_timestamp,
    c.finance_uuid_changed_timestamp,
    

    v.vehicle_code,
    v.status_id,
    v.mileage,
    v.built_year,

    b.branch_id,
    b.branch_name,
    b.country AS market

FROM {{ ref('stg_changelog_purchase_at_branch') }} c

INNER JOIN {{ ref('stg_purchases') }} p
    ON c.purchase_id = p.purchase_id

LEFT JOIN {{ ref('stg_vehicles') }} v
    ON c.purchase_id = v.purchase_id

LEFT JOIN {{ ref('stg_branches') }} b
    ON v.branch_id = b.branch_id

WHERE c.field = 'financeUuid'

AND (c.old_finance_uuid IS NOT NULL
AND c.new_finance_uuid IS NOT NULL) 

AND c.old_finance_uuid <> c.new_finance_uuid

AND c.finance_uuid_changed_timestamp >= p.purchase_timestamp
AND DATE(p.purchase_timestamp) >=
    DATE_SUB(
        CURRENT_DATE(),
        INTERVAL 12 MONTH
    )

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY c.changelog_id
    ORDER BY
        CASE
            WHEN b.country IS NOT NULL THEN 1
            WHEN b.branch_id IS NOT NULL THEN 2
            ELSE 3
        END
) = 1
