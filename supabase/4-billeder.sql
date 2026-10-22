-- Dinnerweek: billeder og noter på opskrifter (fx opskrifter hentet fra Instagram).
-- Kør i Supabase (SQL Editor). Kan køres igen uden problemer.

-- Billede (adresse i Storage) og note (fx hvad Claude har gættet) på opskrifter.
alter table public.recipes add column if not exists image text not null default '';
alter table public.recipes add column if not exists note  text not null default '';

-- Bøtten "billeder" i Storage. Offentlig læsning, så billedet kan vises direkte i appen.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('billeder', 'billeder', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = true, file_size_limit = excluded.file_size_limit, allowed_mime_types = excluded.allowed_mime_types;

-- Kun brugere, der er logget ind, kan lægge billeder op og erstatte dem.
drop policy if exists "billeder laes"    on storage.objects;
drop policy if exists "billeder upload"  on storage.objects;
drop policy if exists "billeder opdater" on storage.objects;
create policy "billeder laes"    on storage.objects for select to authenticated using (bucket_id = 'billeder');
create policy "billeder upload"  on storage.objects for insert to authenticated with check (bucket_id = 'billeder');
create policy "billeder opdater" on storage.objects for update to authenticated using (bucket_id = 'billeder') with check (bucket_id = 'billeder');
