-- 김씨네한우 월드 — Supabase 초기 설정
-- Supabase 대시보드 > SQL Editor > New query 에 전체를 붙여넣고 Run 하세요.
--
-- 방문 기록 테이블: 손님이 입장할 때 한 줄씩 쌓입니다.
-- 무료 프로젝트가 '활동 없음'으로 일시정지되는 것을 막고, 방문자 수도 확인할 수 있어요.
-- 익명 방문자는 기록을 "추가"만 할 수 있고, 읽거나 지우거나 고칠 수는 없습니다.

create table if not exists public.visits (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now()
);

alter table public.visits enable row level security;

grant insert on public.visits to anon;

drop policy if exists "anyone can log a visit" on public.visits;
create policy "anyone can log a visit"
  on public.visits for insert
  to anon
  with check (true);

-- 방문자 수 확인용 (대시보드 SQL Editor에서 직접 실행):
-- select date_trunc('day', created_at) as day, count(*) from public.visits group by 1 order by 1 desc;

-- ------------------------------------------------------------
-- 고기 굽기 챌린지 랭킹 (v4에서 추가) — 이 아래만 다시 실행해도 됩니다.
-- 누구나 점수를 "추가"하고 랭킹을 "읽을" 수 있어요. 수정·삭제는 불가.
create table if not exists public.grill_scores (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 12),
  score int not null check (score between 0 and 300),
  created_at timestamptz not null default now()
);

alter table public.grill_scores enable row level security;

grant select, insert on public.grill_scores to anon;

drop policy if exists "anyone can read scores" on public.grill_scores;
create policy "anyone can read scores"
  on public.grill_scores for select
  to anon
  using (true);

drop policy if exists "anyone can add a score" on public.grill_scores;
create policy "anyone can add a score"
  on public.grill_scores for insert
  to anon
  with check (score between 0 and 300 and char_length(name) between 1 and 12);

create index if not exists grill_scores_week_idx on public.grill_scores (created_at desc, score desc);

-- ------------------------------------------------------------
-- 응원 방명록 (v5에서 추가) — 이 아래만 다시 실행해도 됩니다.
-- 누구나 글을 "추가"하고 "읽을" 수 있어요. 수정·삭제는 불가.
-- 부적절한 글은 Table Editor > guestbook 에서 is_hidden 을 true 로 바꾸면 바로 숨겨져요.
create table if not exists public.guestbook (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 12),
  message text not null check (char_length(message) between 1 and 60),
  color text not null default '#fff1a8' check (char_length(color) <= 9),
  is_hidden boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.guestbook enable row level security;

grant select, insert on public.guestbook to anon;

drop policy if exists "read visible notes" on public.guestbook;
create policy "read visible notes"
  on public.guestbook for select
  to anon
  using (is_hidden = false);

drop policy if exists "add a note" on public.guestbook;
create policy "add a note"
  on public.guestbook for insert
  to anon
  with check (is_hidden = false and char_length(message) between 1 and 60 and char_length(name) between 1 and 12);

-- 새 글이 게시판에 실시간으로 붙도록 Realtime에 등록
do $$ begin
  alter publication supabase_realtime add table public.guestbook;
exception when duplicate_object then null; end $$;
