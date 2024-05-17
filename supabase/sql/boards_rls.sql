CREATE POLICY select_boards ON boards
    FOR SELECT
    TO authenticated
    USING ((is_public IS TRUE) OR (auth.uid() = owner_id));

CREATE POLICY insert_boards ON boards
    FOR INSERT
    TO authenticated
    WITH CHECK ((is_public IS TRUE) OR (auth.uid() = owner_id));

CREATE POLICY update_boards_without_objects ON boards
    FOR UPDATE
    TO authenticated
    USING (
        auth.uid () = owner_id
        or boards.objects is not distinct from boards.objects
    )
    WITH CHECK (
        auth.uid () = owner_id
        or boards.objects is not distinct from boards.objects
    );

CREATE POLICY update_boards_objects ON boards
    FOR UPDATE
    TO authenticated
    USING (
        (is_public IS TRUE AND auth.uid() = ANY(SELECT (jsonb_array_elements_text(editable_user_ids))::uuid)) OR
        (auth.uid() = owner_id)
    )
    WITH CHECK (
        (is_public IS TRUE AND auth.uid() = ANY(SELECT (jsonb_array_elements_text(editable_user_ids))::uuid)) OR
        (auth.uid() = owner_id)
    );

CREATE POLICY delete_boards ON boards
    FOR DELETE
    TO authenticated
    USING (auth.uid() = owner_id);