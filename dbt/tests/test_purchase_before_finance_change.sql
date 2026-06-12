SELECT *
FROM {{ ref('int_purchase_finance_changes') }}

WHERE finance_uuid_changed_timestamp < purchase_timestamp