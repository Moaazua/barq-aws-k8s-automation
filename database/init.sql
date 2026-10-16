CREATE TABLE IF NOT EXISTS records (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title varchar(200) NOT NULL CHECK (length(trim(title)) > 0)
);
INSERT INTO records (title) VALUES
    ('Review service readiness'),
    ('Document the operating procedure');
