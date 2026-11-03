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
