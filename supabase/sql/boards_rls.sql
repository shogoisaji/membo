CREATE POLICY select_boards ON boards
    FOR SELECT
    USING ((is_public IS TRUE AND auth.role() = 'authenticated'::text) OR ((is_public IS FALSE) AND (auth.uid() = owner_id)));

CREATE POLICY insert_boards ON boards
    FOR INSERT
    WITH CHECK ((is_public IS TRUE AND auth.role() = 'authenticated'::text) OR ((is_public IS FALSE) AND (auth.uid() = owner_id)));

CREATE POLICY update_boards ON boards
    FOR UPDATE
    USING ((is_public IS TRUE AND auth.role() = 'authenticated'::text) OR ((is_public IS FALSE) AND (auth.uid() = owner_id)))
    WITH CHECK ((is_public IS TRUE AND auth.role() = 'authenticated'::text) OR ((is_public IS FALSE) AND (auth.uid() = owner_id)));

CREATE POLICY delete_boards ON boards
    FOR DELETE