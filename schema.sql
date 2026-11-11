-- =============================================================================
-- ZENLEAVE POP - SCHEMA DE BASE DE DONNÉES (POSTGRESQL / SUPABASE)
-- =============================================================================
-- Instructions :
-- 1. Rendez-vous sur votre projet Supabase (https://supabase.com)
-- 2. Allez dans le menu "SQL Editor"
-- 3. Collez ce script et cliquez sur "Run"
-- =============================================================================

-- 1. Table des préférences & soldes de congés
CREATE TABLE IF NOT EXISTS public.zenleave_config (
    id TEXT PRIMARY KEY DEFAULT 'default',
    preferences JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Table des journées (congés payés, RTT, ancienneté, maladie, vélo)
CREATE TABLE IF NOT EXISTS public.zenleave_days (
    day_date DATE PRIMARY KEY,
    matin TEXT NOT NULL DEFAULT 'TRAVAILLE',
    aprem TEXT NOT NULL DEFAULT 'TRAVAILLE',
    velo BOOLEAN NOT NULL DEFAULT FALSE,
    velo_trip TEXT NOT NULL DEFAULT 'AR',
    note TEXT DEFAULT '',
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Configuration de la sécurité (Row Level Security - RLS)
-- Permet la lecture et l'écriture directe depuis l'application via la clé anon publique
ALTER TABLE public.zenleave_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.zenleave_days ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "zenleave_config_read" ON public.zenleave_config;
CREATE POLICY "zenleave_config_read" ON public.zenleave_config 
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "zenleave_config_write" ON public.zenleave_config;
CREATE POLICY "zenleave_config_write" ON public.zenleave_config 
    FOR ALL USING (true);

DROP POLICY IF EXISTS "zenleave_days_read" ON public.zenleave_days;
CREATE POLICY "zenleave_days_read" ON public.zenleave_days 
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "zenleave_days_write" ON public.zenleave_days;
CREATE POLICY "zenleave_days_write" ON public.zenleave_days 
    FOR ALL USING (true);

-- 4. Commentaires informatifs sur les tables
COMMENT ON TABLE public.zenleave_config IS 'Paramètres utilisateur ZenLeave (soldes de congés, année, identité)';
COMMENT ON TABLE public.zenleave_days IS 'Calendrier des congés par demi-journée et trajets vélo';
