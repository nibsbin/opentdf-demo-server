----------------------------------------------------------------
-- OBLIGATIONS
----------------------------------------------------------------

-- name: createObligationDefinition :one
INSERT INTO obligation_definitions (namespace_id, name)
VALUES ($1, $2)
RETURNING id;

-- name: getObligationDefinition :one
SELECT
    od.id,
    od.name,
    -- todo: prob return this as a JSON object
    od.namespace_id,
    JSON_STRIP_NULLS(JSON_BUILD_OBJECT('labels', od.metadata -> 'labels', 'created_at', od.created_at,'updated_at', od.updated_at)) as metadata,
    JSON_AGG(
    JSON_BUILD_OBJECT(
        'id', ov.id,
        'value', ov.value
    )
    ) FILTER (WHERE ov.id IS NOT NULL) as values
    -- todo: add triggers and fulfillers
FROM obligation_definitions od
LEFT JOIN obligation_values_standard ov on od.id = ov.obligation_definition_id
WHERE
    (NULLIF(@id, '') IS NULL OR id = @id::UUID) AND
    (NULLIF(@name, '') IS NULL OR name = @name::VARCHAR);

-- name: listObligationDefinitions :many
WITH counted AS (
    SELECT COUNT(id) AS total
    FROM obligation_definitions
)
SELECT
    od.id,
    od.name,
    -- todo: prob return this as a JSON object
    od.namespace_id,
    JSON_STRIP_NULLS(JSON_BUILD_OBJECT('labels', od.metadata -> 'labels', 'created_at', od.created_at,'updated_at', od.updated_at)) as metadata,
    JSON_AGG(
    JSON_BUILD_OBJECT(
        'id', ov.id,
        'value', ov.value
    )
    ) FILTER (WHERE ov.id IS NOT NULL) as values
    -- todo: add triggers and fulfillers
    counted.total
FROM obligation_definitions od
CROSS JOIN counted
LEFT JOIN obligation_values_standard ov on od.id = ov.obligation_definition_id
WHERE
    (NULLIF(@namespace_id, '') IS NULL OR od.namespace_id = @namespace_id::UUID)
GROUP BY od.id, counted.total
LIMIT @limit_
OFFSET @offset_;

-- name: updateObligationDefinition :execrows
UPDATE obligation_definitions
SET
    name = COALESCE(sqlc.narg('name'), name),
    metadata = COALESCE(sqlc.narg('metadata'), metadata)
WHERE id = $1;

-- name: deleteObligationDefinition :execrows
DELETE FROM obligation_definitions WHERE id = $1;
