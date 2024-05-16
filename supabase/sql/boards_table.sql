CREATE TABLE boards (
    board_id UUID PRIMARY KEY,
    password VARCHAR,
    owner_id UUID NOT NULL,
    objects JSONB NOT NULL DEFAULT '[]',
    editable_user_ids JSONB NOT NULL DEFAULT '[]',
    edit_request_user_ids JSONB NOT NULL DEFAULT '[]',
    board_name VARCHAR NOT NULL DEFAULT '',
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    width SMALLINT NOT NULL DEFAULT 1000,
    height SMALLINT NOT NULL DEFAULT 1000,
    bg_color VARCHAR NOT NULL DEFAULT '0xffffffff',
    thumbnail_url TEXT,
    created_at TIMESTAMPTZ NOT NULL
);

