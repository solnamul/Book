# 📚 도서 검색 앱 (Book Tracker)

간단한 도서 검색 및 북마크 앱 📖

네트워크 통신을 이용해서 서버에서 랜덤 포켓몬 이미지를 불러오고, 연락처를 저장하는 앱.

## 구현 목록

Lv.1 `UITabBarController`을 사용하여 2개의 탭을 구현, 탭 바와 각 화면에 해당하는 VC 생성 및 화면 전환 연결만 구현

Lv.2 `UISearchBar`, `UITextField` 등을 활용해 화면 구성 및 KAKAO API를 이용한 검색 기능 구현

Lv.3 CoreData CRUD를 이용한 책 담기 기능 구현 및 상세 페이지 구현
- title
- authors
- contents
- thumbnail 등 사용

Lv.4 최근 검색한 책 저장 구현

## 앱 미리보기
![image](https://github.com/user-attachments/assets/e17fdf41-3c91-4308-98f9-f73590cf911d)

## 커밋컨벤션

- feat : Screen, Component, 기능 추가 및 수정 (큰 변경사항 위주) / 이미지 추가
- update : 간단한 변경 사항
- refactor : 코드 정리 및 단순화 / 간단한 스타일 수정 / 폴더 및 파일 이름이나 위치 변경 / 주석 및 콘솔 관리 / fontello 변경
- fix : 버그 수정
- delete : 폴더, 파일 삭제
- docs : 문서 추가, 수정, 삭제 (ex. README.md)
- test : 테스트 코드 작성, 수정, 삭제
- chore : 패키지/라이브러리 추가, 버전 변경, 삭제
