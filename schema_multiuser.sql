-- =============================================================================
-- ZENLEAVE POP - SCHÉMA MULTI-UTILISATEURS AVEC AUTHENTIFICATION SUPABASE
-- =============================================================================
-- Ce script configure une base PostgreSQL multi-comptes hermétique :
-- - Chaque utilisateur possède ses propres soldes et ses propres congés.
-- - Les politiques Row Level Security (RLS) garantissent que personne ne peut
--   lire ou modifier les données d'un autre utilisateur.
--
-- Instructions :
-- 1. Rendez-vous sur votre projet Supabase (https://supabase.com)
-- 2. Allez dans "SQL Editor" > "New Query"
-- 3. Collez ce script et cliquez sur "Run"
-- =============================================================================

-- Suppression propre des anciennes tables mono-utilisateurs si présentes
DROP TABLE IF EXISTS public.zenleave_days CASCADE;
DROP TABLE IF EXISTS public.zenleave_config CASCADE;

-- 1. TABLE DES PRÉFÉRENCES ET SOLDES (PAR UTILISATEUR)
CREATE TABLE public.zenleave_config (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    preferences JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. TABLE DES JOURNÉES DE CONGÉS & TRAJETS VÉLO (PAR UTILISATEUR)
CREATE TABLE public.zenleave_days (
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    day_date DATE NOT NULL,
    matin TEXT NOT NULL DEFAULT 'TRAVAILLE',
    aprem TEXT NOT NULL DEFAULT 'TRAVAILLE',
    velo BOOLEAN NOT NULL DEFAULT FALSE,
    velo_trip TEXT NOT NULL DEFAULT 'AR',
    note TEXT DEFAULT '',
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, day_date)
);

-- Index pour optimiser les requêtes par utilisateur et date
CREATE INDEX IF NOT EXISTS idx_zenleave_days_user_date 
ON public.zenleave_days (user_id, day_date);

-- 3. ROW LEVEL SECURITY (RLS) - ISOLATION STRICTE
ALTER TABLE public.zenleave_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.zenleave_days ENABLE ROW LEVEL SECURITY;

-- Suppression des anciennes règles éventuelles
DROP POLICY IF EXISTS "zenleave_config_user_policy" ON public.zenleave_config;
DROP POLICY IF EXISTS "zenleave_days_user_policy" ON public.zenleave_days;
DROP POLICY IF EXISTS "zenleave_config_all" ON public.zenleave_config;
DROP POLICY IF EXISTS "zenleave_days_all" ON public.zenleave_days;

-- Seul l'utilisateur connecté peut lire et modifier SES propres données
CREATE POLICY "zenleave_config_user_policy" ON public.zenleave_config
    FOR ALL
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "zenleave_days_user_policy" ON public.zenleave_days
    FOR ALL
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 4. COMMENTAIRES EXPLICATIFS
COMMENT ON TABLE public.zenleave_config IS 'Soldes et préférences isolés par utilisateur Supabase (auth.uid)';
COMMENT ON TABLE public.zenleave_days IS 'Congés et trajets vélo isolés par utilisateur Supabase (auth.uid)';
