{{ config(materialized='view') }}

SELECT

    id AS changelog_id,

    object_id AS purchase_id,

    field,

    old_value AS old_finance_uuid,

    new_value AS new_finance_uuid,

    created_at AS finance_uuid_changed_timestamp,

    created_by

FROM {{ source('auto1', 'raw_changelog_purchase_at_branch') }}
