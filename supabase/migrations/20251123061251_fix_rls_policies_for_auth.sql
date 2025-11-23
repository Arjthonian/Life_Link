/*
  # Fix RLS Policies for Authentication

  ## Problem
  The previous RLS policies were too restrictive. During signup, newly created users couldn't insert
  their own profile data because the policies required auth.uid() = id, but the insert was happening
  as an authenticated user trying to create a new row.

  ## Solution
  Replace restrictive policies with permissive policies that:
  1. Allow authenticated users to INSERT their own records (checked via auth.uid())
  2. Allow authenticated users to SELECT their own records
  3. Allow authenticated users to UPDATE their own records
  4. Allow authenticated users to DELETE their own records
  5. For donors table, allow all authenticated users to view ALL donor profiles (for search functionality)

  ## Changes
  - Modified users table policies to properly handle INSERT with WITH CHECK
  - Modified donors table policies to allow public donor viewing and user-specific edits
  - Simplified policy logic for better security and functionality
*/

-- Drop existing policies on users table
DROP POLICY IF EXISTS "Users can read own profile" ON users;
DROP POLICY IF EXISTS "Users can create own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Users can delete own profile" ON users;

-- Drop existing policies on donors table
DROP POLICY IF EXISTS "Authenticated users can view all donors" ON donors;
DROP POLICY IF EXISTS "Users can create own donor record" ON donors;
DROP POLICY IF EXISTS "Users can update own donor record" ON donors;
DROP POLICY IF EXISTS "Users can delete own donor record" ON donors;

-- Users table: SELECT policy (users can read their own profile)
CREATE POLICY "Users can read own profile"
  ON users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

-- Users table: INSERT policy (users can create their own profile during signup)
CREATE POLICY "Users can create own profile"
  ON users FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Users table: UPDATE policy (users can update their own profile)
CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Users table: DELETE policy (users can delete their own profile)
CREATE POLICY "Users can delete own profile"
  ON users FOR DELETE
  TO authenticated
  USING (auth.uid() = id);

-- Donors table: SELECT policy (all authenticated users can view all donors for searching)
CREATE POLICY "Authenticated users can view all donors"
  ON donors FOR SELECT
  TO authenticated
  USING (true);

-- Donors table: INSERT policy (users can create their own donor record)
CREATE POLICY "Users can create own donor record"
  ON donors FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Donors table: UPDATE policy (users can update their own donor record)
CREATE POLICY "Users can update own donor record"
  ON donors FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Donors table: DELETE policy (users can delete their own donor record)
CREATE POLICY "Users can delete own donor record"
  ON donors FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);