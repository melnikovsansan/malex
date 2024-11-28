SELECT "reminders".*
FROM "reminders"
  INNER JOIN "entries"
    ON "entries"."company_id" = $1
         AND "entries"."deleted" = $2
         AND "entries"."id" = "reminders"."entry_id"
WHERE "reminders"."company_id" = $3
  AND "entries"."deleted" = $4
  AND "reminders"."user_id" = $5
  AND "reminders"."active" = $6
  AND "reminders"."remind_at" <= $7 /* loading for inspect */
LIMIT $8;
--   [["company_id", "eaf18e55-d089-4f4c-9173-090455222ed6"],
--   ["deleted", false],
--   ["company_id", "eaf18e55-d089-4f4c-9173-090455222ed6"],
--   ["deleted", false],
--   ["user_id", "24e0eb0a-97c3-4abd-9689-5f41a9a0e4eb"],
--   ["active", true],
--   ["remind_at", "2024-10-09 22:59:59.999999"],
--   ["LIMIT", 11]]

SELECT "reminders".*
FROM "reminders"
  INNER JOIN "entries"
    ON "entries"."company_id" = $1
         AND "entries"."deleted" = $2
         AND "entries"."id" = "reminders"."entry_id"
WHERE "reminders"."company_id" = $3
  AND "entries"."deleted" = $4
  AND "reminders"."user_id" = $5
  AND "reminders"."active" = $6
  AND "reminders"."remind_at" BETWEEN $7 AND $8 /* loading for inspect */
LIMIT $9;
--   [["company_id", "eaf18e55-d089-4f4c-9173-090455222ed6"],
--   ["deleted", false],
--   ["company_id", "eaf18e55-d089-4f4c-9173-090455222ed6"],
--   ["deleted", false],
--   ["user_id", "24e0eb0a-97c3-4abd-9689-5f41a9a0e4eb"],
--   ["active", true],
--   ["remind_at", "2024-10-09 07:48:04.196154"],
--   ["remind_at", "2024-10-09 08:48:04.196184"],
--   ["LIMIT", 11]]
