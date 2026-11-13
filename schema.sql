-- =============================================================================
-- ZENLEAVE POP - SCHÉMA DE BASE DE DONNÉES MULTI-UTILISATEURS (SUPABASE AUTH & RLS)
-- =============================================================================
-- Instructions :
-- 1. Rendez-vous sur votre projet Supabase (https://supabase.com)
-- 2. Allez dans le menu "SQL Editor" > "New Query"
-- 3. Collez ce script et cliquez sur "Run"
-- =============================================================================

-- 1. Table des préférences & soldes de congés (isolés par utilisateur)
CREATE TABLE IF NOT EXISTS public.zenleave_config (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    preferences JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Table des journées (congés payés, RTT, ancienneté, maladie, vélo)
CREATE TABLE IF NOT EXISTS public.zenleave_days (
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

-- Index d'optimisation
CREATE INDEX IF NOT EXISTS idx_zenleave_days_user_date ON public.zenleave_days (user_id, day_date);

-- 3. Activation stricte du Row Level Security (RLS)
ALTER TABLE public.zenleave_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.zenleave_days ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "zenleave_config_user_policy" ON public.zenleave_config;
CREATE POLICY "zenleave_config_user_policy" ON public.zenleave_config
    FOR ALL TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "zenleave_days_user_policy" ON public.zenleave_days;
CREATE POLICY "zenleave_days_user_policy" ON public.zenleave_days
    FOR ALL TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

COMMENT ON TABLE public.zenleave_config IS 'Paramètres utilisateur isolés par utilisateur Supabase (auth.uid)';
COMMENT ON TABLE public.zenleave_days IS 'Calendrier des congés et trajets vélo isolés par utilisateur Supabase (auth.uid)';
