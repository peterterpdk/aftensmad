-- Dinnerweek: tilføjer lam som proteintype.
-- Kør i Supabase (SQL Editor). Kan køres igen uden problemer.

alter table public.recipes drop constraint if exists recipes_protein_check;
alter table public.recipes add constraint recipes_protein_check
  check (protein in ('kylling','okse','lam','gris','fisk','vegetar'));
