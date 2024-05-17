CREATE POLICY select_edit_requests ON edit_requests
FOR SELECT
USING (
  auth.uid() = owner_id OR auth.uid() = requestor_id
);

CREATE POLICY insert_edit_requests ON edit_requests
FOR INSERT
WITH CHECK (
  auth.role() = 'authenticated'::text
);

CREATE POLICY update_edit_requests ON edit_requests
FOR UPDATE
USING (
  auth.uid() = owner_id OR auth.uid() = requestor_id
)
WITH CHECK (
  auth.uid() = owner_id OR auth.uid() = requestor_id
);

CREATE POLICY delete_edit_requests ON edit_requests
FOR DELETE
USING (
  auth.uid() = owner_id OR auth.uid() = requestor_id
);