-- =============================================================================
-- ZENLEAVE POP - INITIALISATION MULTI-UTILISATEURS & IMPORT DES DONNÉES
-- Salarié : KAMENEFF ivan (TESTIA)
-- Contient : Schéma RLS Multi-Users + Soldes (CP: 25, RTT: 11, Anc: 4) + 219 jours
-- =============================================================================
-- Instructions :
-- 1. Créez d'abord votre compte dans Supabase (Authentication > Users > Add user)
-- 2. Remplacez ci-dessous 'VOTRE_EMAIL@EXEMPLE.COM' par votre adresse e-mail.
-- 3. Ouvrez le SQL Editor dans Supabase, collez tout ce script et cliquez sur 'Run'.
-- =============================================================================

-- 1. CRÉATION DES TABLES MULTI-UTILISATEURS & POLITIQUES RLS
CREATE TABLE IF NOT EXISTS public.zenleave_config (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    preferences JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

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

CREATE INDEX IF NOT EXISTS idx_zenleave_days_user_date ON public.zenleave_days (user_id, day_date);

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

-- 2. INSERTION DE LA CONFIGURATION ET DES 219 JOURS POUR VOTRE COMPTE
DO $$
DECLARE
    target_user_id UUID;
    target_email TEXT := 'VOTRE_EMAIL@EXEMPLE.COM'; -- << METTEZ VOTRE E-MAIL SUPABASE ICI
BEGIN
    SELECT id INTO target_user_id FROM auth.users WHERE email = target_email;

    IF target_user_id IS NULL THEN
        RAISE EXCEPTION 'Utilisateur introuvable pour % ! Créez le compte dans Supabase (Authentication > Users) avant d''exécuter ce script.', target_email;
    END IF;

    -- Soldes et préférences
    INSERT INTO public.zenleave_config (user_id, preferences, updated_at)
    VALUES (
        target_user_id,
        '{"year":2026,"cpTotal":25,"rttTotal":11,"ancTotal":4,"bikeDailyKm":14,"userName":"KAMENEFF ivan","userCompany":"TESTIA"}'::jsonb,
        NOW()
    )
    ON CONFLICT (user_id) DO UPDATE SET
        preferences = EXCLUDED.preferences,
        updated_at = NOW();

    -- Insertion des 219 journées enregistrées
    INSERT INTO public.zenleave_days (user_id, day_date, matin, aprem, velo, velo_trip, note, updated_at)
    VALUES
        (target_user_id, '2026-01-02', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-05', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-06', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-07', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-08', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-12', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-13', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-14', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-15', 'TRAVAILLE', 'TRAVAILLE', false, 'AR', '', NOW()),
        (target_user_id, '2026-01-16', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-19', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-20', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-21', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-22', 'TRAVAILLE', 'TRAVAILLE', false, 'AR', '', NOW()),
        (target_user_id, '2026-01-23', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-26', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-27', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-28', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-29', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-01-30', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-02', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-03', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-04', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-05', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-06', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-10', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-11', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-12', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-13', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-16', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-17', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-18', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-19', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-20', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-23', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-24', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-02-25', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-02-26', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-02-27', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-02', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-03', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-04', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-05', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-06', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-10', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-11', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-12', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-13', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-16', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-17', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-18', 'CP', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-19', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-20', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-23', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-24', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-25', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-26', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-27', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-30', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-03-31', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-01', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-02', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-03', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-07', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-08', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-10', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-13', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-14', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-15', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-16', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-17', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-20', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-21', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-22', 'CP', 'CP', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-23', 'CP', 'CP', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-24', 'CP', 'CP', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-27', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-28', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-29', 'CP', 'CP', true, 'AR', '', NOW()),
        (target_user_id, '2026-04-30', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-04', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-05', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-06', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-07', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-11', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-12', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-13', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-15', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-18', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-19', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-20', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-21', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-22', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-25', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-05-26', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-27', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-28', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-05-29', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-01', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-02', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-03', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-04', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-05', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-06', 'TRAVAILLE', 'TRAVAILLE', false, 'AR', '', NOW()),
        (target_user_id, '2026-06-07', 'TRAVAILLE', 'TRAVAILLE', false, 'AR', '', NOW()),
        (target_user_id, '2026-06-08', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-10', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-11', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-12', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-15', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-16', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-17', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-18', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-19', 'CP', 'CP', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-22', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-23', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-24', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-25', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-26', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-29', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-06-30', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-01', 'TRAVAILLE', 'TRAVAILLE', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-02', 'TRAVAILLE', 'TRAVAILLE', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-06', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-07', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-08', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-10', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-13', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-15', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-16', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-17', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-20', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-21', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-22', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-23', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-24', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-07-27', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-28', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-29', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-30', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-07-31', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-03', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-08-04', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-08-05', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-08-06', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-08-07', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-08-10', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-11', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-12', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-13', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-14', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-17', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-18', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-19', 'CP', 'CP', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-20', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-21', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-24', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-25', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-26', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-27', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-28', 'RTT', 'RTT', false, 'AR', '', NOW()),
        (target_user_id, '2026-08-31', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-01', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-02', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-03', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-04', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-07', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-08', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-10', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-11', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-14', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-15', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-16', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-17', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-18', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-21', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-22', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-23', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-24', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-25', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-28', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-29', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-09-30', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-01', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-02', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-05', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-06', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-07', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-08', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-12', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-13', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-14', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-15', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-16', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-19', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-20', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-21', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-22', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-23', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-26', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-27', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-28', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-29', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-10-30', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-11-02', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-11-03', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-11-04', 'CP', 'CP', false, 'AR', 'Repos', NOW()),
        (target_user_id, '2026-11-05', 'CP', 'CP', false, 'AR', 'Repos', NOW()),
        (target_user_id, '2026-11-06', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-11-09', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW()),
        (target_user_id, '2026-11-10', 'TRAVAILLE', 'TRAVAILLE', true, 'AR', '', NOW())
    ON CONFLICT (user_id, day_date) DO UPDATE SET
        matin = EXCLUDED.matin,
        aprem = EXCLUDED.aprem,
        velo = EXCLUDED.velo,
        velo_trip = EXCLUDED.velo_trip,
        note = EXCLUDED.note,
        updated_at = NOW();

    RAISE NOTICE 'Succès : 219 journées et soldes importés pour % (UUID: %)', target_email, target_user_id;
END $$;
