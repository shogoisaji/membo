CREATE POLICY select_profiles ON profiles
FOR SELECT
TO authenticated
USING (
  true
);

CREATE POLICY insert_profiles ON profiles
FOR INSERT
TO authenticated
WITH CHECK (
  true
);

CREATE POLICY update_profiles ON profiles
FOR UPDATE
TO authenticated
USING (
  auth.uid() = user_id
)
WITH CHECK (
  auth.uid() = user_id
);

CREATE POLICY delete_profiles ON profiles
FOR DELETE
TO authenticated
USING (
  auth.uid() = user_id
);