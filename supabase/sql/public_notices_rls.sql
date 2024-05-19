CREATE POLICY select_public_notices ON public_notices
FOR SELECT
USING (
  true
);

CREATE POLICY insert_public_notices ON public_notices
FOR INSERT
WITH CHECK (
  false
);

CREATE POLICY update_public_notices ON public_notices
FOR UPDATE
USING (
  false
)
WITH CHECK (
  false
);

CREATE POLICY delete_public_notices ON public_notices
FOR DELETE
USING (
  false
);