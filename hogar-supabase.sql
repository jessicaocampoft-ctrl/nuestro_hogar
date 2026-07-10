-- Hogar web: ejecutar una sola vez en Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.hogar_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  email text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.hogares (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Nuestro hogar',
  invite_code text unique not null default upper(substr(encode(gen_random_bytes(5),'hex'),1,6)),
  created_by uuid not null references auth.users(id),
  created_at timestamptz not null default now()
);

create table if not exists public.hogar_members (
  hogar_id uuid not null references public.hogares(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member' check (role in ('owner','member')),
  joined_at timestamptz not null default now(),
  primary key (hogar_id,user_id),
  unique(user_id)
);

create table if not exists public.hogar_data (
  hogar_id uuid primary key references public.hogares(id) on delete cascade,
  content jsonb not null default '{"expenses":[],"tasks":[],"notes":[]}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id)
);

create or replace function public.hogar_is_member(target uuid)
returns boolean language sql stable security definer set search_path=public
as $$ select exists(select 1 from hogar_members where hogar_id=target and user_id=auth.uid()) $$;

create or replace function public.hogar_create(display_name text, hogar_name text default 'Jessica & Mateo')
returns table(hogar_id uuid, invite_code text)
language plpgsql security definer set search_path=public
as $$ declare h hogares; begin
  if auth.uid() is null then raise exception 'Debes iniciar sesión'; end if;
  if exists(select 1 from hogar_members where user_id=auth.uid()) then raise exception 'Ya perteneces a un hogar'; end if;
  insert into hogar_profiles(user_id,name,email) values(auth.uid(),coalesce(nullif(trim(display_name),''),'Jessica'),coalesce(auth.jwt()->>'email','')) on conflict(user_id) do update set name=excluded.name;
  insert into hogares(name,created_by) values(coalesce(nullif(trim(hogar_name),''),'Nuestro hogar'),auth.uid()) returning * into h;
  insert into hogar_members(hogar_id,user_id,role) values(h.id,auth.uid(),'owner');
  insert into hogar_data(hogar_id,updated_by) values(h.id,auth.uid());
  return query select h.id,h.invite_code;
end $$;

create or replace function public.hogar_join(code text, display_name text)
returns uuid language plpgsql security definer set search_path=public
as $$ declare hid uuid; begin
  if auth.uid() is null then raise exception 'Debes iniciar sesión'; end if;
  if exists(select 1 from hogar_members where user_id=auth.uid()) then raise exception 'Ya perteneces a un hogar'; end if;
  select id into hid from hogares where invite_code=upper(trim(code));
  if hid is null then raise exception 'Código inválido'; end if;
  if (select count(*) from hogar_members where hogar_id=hid) >= 2 then raise exception 'Este hogar ya tiene dos integrantes'; end if;
  insert into hogar_profiles(user_id,name,email) values(auth.uid(),coalesce(nullif(trim(display_name),''),'Mateo'),coalesce(auth.jwt()->>'email','')) on conflict(user_id) do update set name=excluded.name;
  insert into hogar_members(hogar_id,user_id,role) values(hid,auth.uid(),'member');
  return hid;
end $$;

create or replace function public.hogar_context()
returns table(hogar_id uuid, hogar_name text, invite_code text, user_name text)
language sql stable security definer set search_path=public
as $$ select h.id,h.name,h.invite_code,p.name from hogar_members m join hogares h on h.id=m.hogar_id left join hogar_profiles p on p.user_id=m.user_id where m.user_id=auth.uid() limit 1 $$;

alter table hogar_profiles enable row level security;
alter table hogares enable row level security;
alter table hogar_members enable row level security;
alter table hogar_data enable row level security;
create policy "perfil propio o pareja" on hogar_profiles for select using(user_id=auth.uid() or exists(select 1 from hogar_members me join hogar_members partner on partner.hogar_id=me.hogar_id where me.user_id=auth.uid() and partner.user_id=hogar_profiles.user_id));
create policy "hogar miembros" on hogares for select using(hogar_is_member(id));
create policy "miembros del hogar" on hogar_members for select using(hogar_is_member(hogar_id));
create policy "datos leer" on hogar_data for select using(hogar_is_member(hogar_id));
create policy "datos actualizar" on hogar_data for update using(hogar_is_member(hogar_id)) with check(hogar_is_member(hogar_id));
grant execute on function hogar_create(text,text) to authenticated;
grant execute on function hogar_join(text,text) to authenticated;
grant execute on function hogar_context() to authenticated;
