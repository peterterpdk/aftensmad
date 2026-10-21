-- Planlæg ugens aftensmad: tabeller, adgang og live-opdatering.
-- Kør hele scriptet én gang i Supabase: SQL Editor > New query > Run.

create table if not exists public.recipes (
  id          text primary key,
  name        text not null,
  protein     text not null check (protein in ('kylling','okse','gris','fisk','vegetar')),
  sides       jsonb not null default '[]'::jsonb,
  minutes     integer not null default 0,
  servings    integer not null default 4,
  ingredients jsonb not null default '[]'::jsonb,
  steps       jsonb not null default '[]'::jsonb,
  source      text not null default '',
  builtin     boolean not null default false,
  updated_at  timestamptz not null default now()
);

create table if not exists public.weeks (
  id         text primary key,            -- fx 2026-W44
  days       jsonb not null,              -- d0..d6: recipe, protein, side, locked, skip
  updated_at timestamptz not null default now()
);

create table if not exists public.settings (
  id   text primary key,
  data jsonb not null default '{}'::jsonb
);

-- Kun brugere, der er logget ind, kan læse og skrive.
alter table public.recipes  enable row level security;
alter table public.weeks    enable row level security;
alter table public.settings enable row level security;

drop policy if exists "familie" on public.recipes;
drop policy if exists "familie" on public.weeks;
drop policy if exists "familie" on public.settings;
create policy "familie" on public.recipes  for all to authenticated using (true) with check (true);
create policy "familie" on public.weeks    for all to authenticated using (true) with check (true);
create policy "familie" on public.settings for all to authenticated using (true) with check (true);

-- Opdaterer enkelte dage i en uge uden at overskrive de andre dage.
create or replace function public.patch_week(p_id text, p_patch jsonb)
returns jsonb
language plpgsql
security invoker
as $$
declare
  cur jsonb;
  k   text;
  v   jsonb;
begin
  insert into public.weeks (id, days) values (p_id, '{}'::jsonb) on conflict (id) do nothing;
  select days into cur from public.weeks where id = p_id for update;
  for k, v in select * from jsonb_each(p_patch) loop
    cur := jsonb_set(cur, array[k], coalesce(cur -> k, '{}'::jsonb) || v, true);
  end loop;
  update public.weeks set days = cur, updated_at = now() where id = p_id;
  return cur;
end;
$$;
revoke all on function public.patch_week(text, jsonb) from public, anon;
grant execute on function public.patch_week(text, jsonb) to authenticated;

-- Live-opdatering, så alle i familien ser ændringer med det samme.
do $$
begin
  begin alter publication supabase_realtime add table public.recipes;  exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.weeks;    exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.settings; exception when duplicate_object then null; end;
end $$;
