-- name: CreateTransfer :one
INSERT INTO transfers (
  from_acccount_id,
  to_acccount_id,
  amount
) VALUES (
  $1, $2, $3
) RETURNING *;

-- name: GetTransfer :one
SELECT * FROM transfers
WHERE id = $1 LIMIT 1;

-- name: ListTransfers :many
SELECT * FROM transfers
WHERE 
  from_acccount_id = $1 OR
  to_acccount_id = $2
ORDER BY id
LIMIT $3
OFFSET $4;

-- name: UpdateTransfer :one
UPDATE transfers
SET amount = $2
WHERE id = $1
RETURNING *;

-- name: DeleteTransfer :exec
DELETE FROM transfers
WHERE id = $1;
