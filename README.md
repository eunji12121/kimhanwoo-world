# 김씨네한우 월드

김씨네한우 브랜드 홍보용 3D 메타버스. 브라우저에서 바로 접속해 정육점·선물세트관·목장을 돌아다니고, 다른 방문자와 실시간으로 만날 수 있습니다.

- 화면: `index.html` 한 파일 (Three.js, CDN 로드)
- 실시간 접속: Supabase Realtime (broadcast + presence)
- 배포: Vercel — `main` 브랜치에 올리면 자동 배포

## 처음 설정
Supabase 대시보드 → SQL Editor 에서 `setup.sql` 을 한 번 실행하세요 (방문 기록 테이블).

## 자주 바꾸는 곳
`index.html` 상단의 `BRAND` 설정에서 이름·색·메뉴·선물세트·대사를, `SUPABASE` 설정에서 프로젝트 주소와 키를 바꿀 수 있어요.
