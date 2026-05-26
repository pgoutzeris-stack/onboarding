alter table onboarding.user_progress
  add column if not exists completed_roots_todos jsonb not null default '[]'::jsonb;

comment on column onboarding.user_progress.completed_roots_todos is
  'Von ROOTS-Bearbeitern abgehakte Onboarding-To-dos pro Teilnehmer';

create policy "Manager aktualisiert Fortschritt"
  on onboarding.user_progress
  for update
  to authenticated
  using (onboarding.is_current_user_manager())
  with check (onboarding.is_current_user_manager());

alter publication supabase_realtime add table onboarding.user_progress;
