-- PRIVILEGES FOR pats USER OF PATS DATABASE
--
-- by (klouie) & (atoshniw)
--
--
-- SQL needed to create the pats user
CREATE USER pats;
ALTER USER pats NOSUPERUSER;

-- SQL to limit pats user access on key tables
GRANT ALL PRIVILEGES ON owners TO pats;
GRANT ALL PRIVILEGES ON pets TO pats;
GRANT ALL PRIVILEGES ON visits TO pats;
GRANT ALL PRIVILEGES ON animals TO pats;
GRANT ALL PRIVILEGES ON medicines TO pats;
GRANT ALL PRIVILEGES ON procedures TO pats;
GRANT ALL PRIVILEGES ON treatments TO pats;
GRANT ALL PRIVILEGES ON notes TO pats;
GRANT ALL PRIVILEGES ON users TO pats;