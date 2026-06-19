-- RaptorLog Supabase Schema
-- Run this in Supabase SQL editor before launching the app

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ─────────────────────────────────────────
-- Species table (user-owned)
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS species (
  id               UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id          UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  common_name      TEXT NOT NULL,
  chinese_name     TEXT,
  scientific_name  TEXT,
  family_group     TEXT,
  description_en   TEXT,
  description_zh   TEXT,
  sort_order       INT DEFAULT 0,
  created_at       TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, common_name)
);

-- ─────────────────────────────────────────
-- Achievements table
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS achievements (
  id                  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id             UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  species_id          UUID REFERENCES species(id) ON DELETE CASCADE NOT NULL,

  green_unlocked      BOOLEAN DEFAULT false,
  green_photo_url     TEXT,
  green_unlocked_at   TIMESTAMPTZ,

  blue_unlocked       BOOLEAN DEFAULT false,
  blue_photo_url      TEXT,
  blue_unlocked_at    TIMESTAMPTZ,

  yellow_unlocked     BOOLEAN DEFAULT false,
  yellow_photo_url    TEXT,
  yellow_unlocked_at  TIMESTAMPTZ,

  red_unlocked        BOOLEAN DEFAULT false,
  red_photo_url       TEXT,
  red_unlocked_at     TIMESTAMPTZ,

  UNIQUE(user_id, species_id)
);

-- ─────────────────────────────────────────
-- Row-Level Security
-- ─────────────────────────────────────────
ALTER TABLE species ENABLE ROW LEVEL SECURITY;
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own species"
  ON species FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users manage own achievements"
  ON achievements FOR ALL USING (auth.uid() = user_id);

-- ─────────────────────────────────────────
-- Storage bucket for achievement photos
-- ─────────────────────────────────────────
-- Run in Supabase Dashboard > Storage > New Bucket:
--   Name: achievement-photos
--   Public: false
--
-- Then add this RLS policy to the bucket:
-- CREATE POLICY "Users access own photos"
--   ON storage.objects FOR ALL
--   USING (bucket_id = 'achievement-photos' AND auth.uid()::text = (storage.foldername(name))[1]);
