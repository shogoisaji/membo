CREATE TABLE public_notices (
    id SMALLINT PRIMARY KEY,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    notice_code SMALLINT NOT NULL,
    notice1 TEXT,
    notice2 TEXT,
    notice3 TEXT,
    app_url TEXT,
    updated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL
);

