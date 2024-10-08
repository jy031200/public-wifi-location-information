# public-wifi-location-information
서울시 공공 와이파이 위치 정보 웹사이트입니다. 
이 웹사이트는 OpenAPI와 서블릿을 활용하며 연습용으로 제작되었습니다.

OpenAPI는 서울 열린데이터광장에서 서울시 공공 와이파이 위치 정보 OpenAPI를 사용했습니다.

![스크린샷 2024-08-27 011558](https://github.com/user-attachments/assets/0080370e-128b-4fd1-b521-0a71ddf7a0b5)

## 주요기능
### 홈
- 홈 화면으로 돌아옵니다: 애플리케이션의 기본 화면으로 돌아가며, 다른 기능을 선택할 수 있습니다.
### Open API 와이파이 정보 가져오기
- Open API에서 와이파이 정보를 가져옵니다: 서울시의 공공 와이파이 정보가 포함된 Open API를 호출하여 최신 와이파이 데이터를 가져옵니다. 이 데이터는 웹 애플리케이션에서 사용자에게 제공됩니다.
### 내 위치 가져오기
- 현재 내 위치의 위도, 경도 좌표를 가져옵니다: 사용자의 현재 위치를 기반으로 위도와 경도 좌표를 자동으로 가져옵니다. 이 기능을 통해 사용자는 자신의 현재 위치를 기반으로 데이터를 조회할 수 있습니다.
### 근처 WIFI 정보 보기
- 현재 내 위치를 기반으로 근처 WIFI 정보를 가져옵니다: 사용자가 가져온 현재 위치 좌표를 기준으로, 근처의 공공 와이파이 정보를 검색하고 화면에 표시합니다. 이를 통해 사용자에게 가까운 와이파이 핫스팟을 쉽게 찾을 수 있습니다.

### 추가 예정 기능
- 위치 히스토리 목록: 사용자가 조회한 위치의 히스토리를 목록으로 제공하는 기능입니다.
- 자세한 정보: 와이파이 정보 클릭 시 자세한 정보를 제공하는 기능입니다.
- 북마크 관련 기능: 사용자가 관심 있는 와이파이 위치를 북마크하고 쉽게 접근할 수 있는 기능입니다.
