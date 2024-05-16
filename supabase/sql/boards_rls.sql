CREATE POLICY select_boards ON boards
    FOR SELECT
    USING ((is_public IS TRUE AND auth.role() = 'authenticated'::text) OR (auth.uid() = owner_id));

CREATE POLICY insert_boards ON boards
    FOR INSERT
    WITH CHECK ((is_public IS TRUE AND auth.role() = 'authenticated'::text) OR (auth.uid() = owner_id));

CREATE POLICY update_boards ON boards
    FOR UPDATE
    USING (
        (is_public IS TRUE AND auth.role() = 'authenticated'::text AND auth.uid() = ANY(SELECT (jsonb_array_elements_text(editable_user_ids))::uuid)) OR 
        (auth.uid() = owner_id)
    )
    WITH CHECK (
        (is_public IS TRUE AND auth.role() = 'authenticated'::text AND auth.uid() = ANY(SELECT (jsonb_array_elements_text(editable_user_ids))::uuid)) OR 
        (auth.uid() = owner_id)
    );

CREATE POLICY delete_boards ON boards
    FOR DELETE
    USING (auth.uid() = owner_id);