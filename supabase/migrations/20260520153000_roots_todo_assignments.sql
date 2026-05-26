alter table onboarding.user_progress
  add column if not exists roots_todo_assignments jsonb not null default '{}'::jsonb;

comment on column onboarding.user_progress.roots_todo_assignments is
  'Zuordnung ROOTS-To-do-ID zu Bearbeiter-User-ID (UUID als Text)';
