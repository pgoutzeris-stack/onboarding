create or replace function onboarding.is_current_user_manager()
returns boolean
language sql
stable
security definer
set search_path = onboarding, users, public
as $$
  select coalesce(
    (select app_role in ('admin', 'editor', 'member')
     from users.profiles
     where id = auth.uid()),
    false
  );
$$;

create policy "Manager liest alle Fortschritte"
  on onboarding.user_progress
  for select
  to authenticated
  using (onboarding.is_current_user_manager());

comment on function onboarding.is_current_user_manager() is 'Admin/Editor duerfen Onboarding-Fortschritt aller Leser einsehen';
