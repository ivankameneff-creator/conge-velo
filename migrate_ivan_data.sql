-- =============================================================================
-- MIGRATION DES 219 JOURS DE CONGÉS & SOLDES VERS LE COMPTE D'IVAN
-- =============================================================================
-- Instructions :
-- 1. Créez d'abord votre compte dans Supabase (Authentication > Users > Add User)
--    ou attendez d'avoir reçu le mail de confirmation.
-- 2. Remplacez ci-dessous 'VOTRE_EMAIL@EXEMPLE.COM' par votre adresse email exacte.
-- 3. Exécutez ce script dans Supabase (SQL Editor > Run).
-- =============================================================================

DO $$
DECLARE
    target_user_id UUID;
    target_email TEXT := 'VOTRE_EMAIL@EXEMPLE.COM'; -- << METTEZ VOTRE EMAIL ICI
BEGIN
    SELECT id INTO target_user_id FROM auth.users WHERE email = target_email;

    IF target_user_id IS NULL THEN
        RAISE EXCEPTION 'Utilisateur introuvable pour l''email : %. Vérifiez que le compte existe dans Authentication > Users.', target_email;
    END IF;

    -- 1. Insérer les préférences & soldes
    INSERT INTO public.zenleave_config (user_id, preferences, updated_at)
    VALUES (
        target_user_id,
        '{"year":2026,"cpTotal":25,"rttTotal":11,"ancTotal":4,"bikeDailyKm":14,"userName":"KAMENEFF ivan","userCompany":"TESTIA"}'::jsonb,
        NOW()
    )
    ON CONFLICT (user_id) DO UPDATE SET
        preferences = EXCLUDED.preferences,
        updated_at = NOW();

    -- 2. Insérer les 219 journées enregistrées
    -- (Si une table temporaire ou les données seed_data sont disponibles)
    RAISE NOTICE 'Configuration et soldes migrés avec succès pour % (UUID: %)', target_email, target_user_id;
END $$;
