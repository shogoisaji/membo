create table
  profiles (
    user_id uuid primary key,
    user_name varchar,
    linked_board_ids JSONB default '[]'::jsonb,
    membership_type JSONB default '{"membership_type":"free"}'::jsonb,
    avatar_url text,
    created_at TIMESTAMPTZ default now(),
    owned_board_ids JSONB default '[]'::jsonb
  );