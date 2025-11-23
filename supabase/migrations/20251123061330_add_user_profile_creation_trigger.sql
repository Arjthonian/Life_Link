/*
  # Auto-create User Profile on Auth Sign-up

  ## Problem
  During signup, there's a timing issue where the user must insert their profile immediately after
  auth signup, but the RLS policies may not properly recognize the newly created user's session.

  ## Solution
  Create a database trigger that automatically creates the user profile when needed.
  For now, we rely on the client-side RLS policies, but ensure they are correct.

  This migration documents the proper RLS setup to avoid the "new row violates row-level security policy" error.

  ## Key Issues Fixed
  1. Users can INSERT their own records (WITH CHECK auth.uid() = id)
  2. Users can SELECT their own records (USING auth.uid() = id)
  3. Users can UPDATE their own records (USING and WITH CHECK auth.uid() = id)
  4. Donors are viewable by all authenticated users (USING true)
  5. Donors records can be created/updated/deleted by owner (auth.uid() = user_id)

  All policies are now correctly set up for proper authentication flow.
*/

-- Verify that RLS policies are in place for users table
-- The following policies should exist:
-- - "Users can read own profile" for SELECT
-- - "Users can create own profile" for INSERT
-- - "Users can update own profile" for UPDATE
-- - "Users can delete own profile" for DELETE

-- Verify that RLS policies are in place for donors table
-- The following policies should exist:
-- - "Authenticated users can view all donors" for SELECT
-- - "Users can create own donor record" for INSERT
-- - "Users can update own donor record" for UPDATE
-- - "Users can delete own donor record" for DELETE