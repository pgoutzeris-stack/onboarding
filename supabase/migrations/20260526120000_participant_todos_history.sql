alter table onboarding.user_progress
  add column if not exists participant_todos jsonb not null default '[]'::jsonb;

comment on column onboarding.user_progress.participant_todos is
  'Bearbeitbare ROOTS-To-do-Liste pro Teilnehmer: [{id,text,owner,section,phase,sort_order}]';

create table if not exists onboarding.participant_todo_history (
  id uuid primary key default gen_random_uuid(),
  participant_user_id uuid not null references auth.users(id) on delete cascade,
  snapshot jsonb not null,
  changed_by uuid references auth.users(id) on delete set null,
  changed_by_name text not null default '',
  change_type text not null default 'autosave',
  created_at timestamptz not null default now()
);

create index if not exists participant_todo_history_user_created_idx
  on onboarding.participant_todo_history (participant_user_id, created_at desc);

alter table onboarding.participant_todo_history enable row level security;

create policy "Manager liest Todo-Verlauf"
  on onboarding.participant_todo_history
  for select
  to authenticated
  using (onboarding.is_current_user_manager());

create policy "Manager schreibt Todo-Verlauf"
  on onboarding.participant_todo_history
  for insert
  to authenticated
  with check (onboarding.is_current_user_manager());

comment on table onboarding.participant_todo_history is
  'Autosave-Snapshots der bearbeitbaren Teilnehmer-To-do-Listen inkl. Bearbeiter-Name';
