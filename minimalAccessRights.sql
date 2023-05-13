REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM "tech-support-backend";
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM "tech-support-backend";
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM "tech-support-backend";


GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "tech-support-backend";
SELECT 'ALTER TABLE '|| schemaname || '."' || tablename ||'" OWNER TO "tech-support-backend";'
FROM pg_tables WHERE NOT schemaname IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename;
-- You must execute all ALTERS that was printed by previous string --

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO "tech-support-backend";
SELECT 'ALTER FUNCTION '
            || quote_ident(n.nspname) || '.'
            || quote_ident(p.proname) || '('
            || pg_catalog.pg_get_function_identity_arguments(p.oid)
            || ') OWNER TO foo;'
FROM   pg_catalog.pg_proc p
JOIN   pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE  n.nspname = 'public';
-- You must execute all ALTERS that was printed by previous string --

GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO "tech-support-backend";

-- Now "tech-support-backend" can CREATE, SELECT, UPDATE, INSERT, DELETE all tables
-- And EXECUTE, CREATE. DROP trigger functions
