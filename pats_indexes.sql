-- INDEXES FOR PATS DATABASE
--
-- by (klouie) & (atoshniw)
--
--
CREATE INDEX medicine_description ON medicines USING gin (to_tsvector(description));

CREATE INDEX procedure_description ON prorcedures USING gin (to_tsvector(description));