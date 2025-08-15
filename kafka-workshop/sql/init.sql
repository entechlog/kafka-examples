-- Minimal PostgreSQL initialization for Kafka Connect Auto-Evolution
-- Purpose: Let Kafka Connect auto-create tables with correct schemas

-- For Docker Compose setup, you typically need:
-- 1. Database: kafka_demo (created via POSTGRES_DB env var)
-- 2. User: postgres (created via POSTGRES_USER env var) 
-- 3. Password: postgres (created via POSTGRES_PASSWORD env var)

-- NO TABLE CREATION NEEDED!
-- Let auto.create=true handle table creation with proper schemas

-- Optional: Verify permissions (usually not needed with postgres user)
-- GRANT CREATE ON DATABASE kafka_demo TO postgres;
-- GRANT ALL PRIVILEGES ON SCHEMA public TO postgres;

-- Result: Clean database ready for auto-evolution