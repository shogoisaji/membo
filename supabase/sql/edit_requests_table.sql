CREATE TABLE edit_requests (
    edit_request_id UUID PRIMARY KEY,
    board_id UUID NOT NULL,
    owner_id UUID NOT NULL,
    requestor_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL
);

