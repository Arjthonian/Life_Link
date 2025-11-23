/*
  # Cleanup: Remove Unnecessary ID Table

  ## Problem
  An unnecessary table named "id" was created during migration that serves no purpose
  and may interfere with database operations.

  ## Solution
  Drop the unnecessary table completely.
*/

DROP TABLE IF EXISTS "id" CASCADE;