# MLX Hub Releases ⚡️

Apple Silicon에 최적화된 MLX Hub의 공식 배포 저장소입니다.

## 📦 다운로드 안내

최신 버전의 MLX Hub 설치 파일(.dmg)은 상단의 **[Releases]** 탭에서 다운로드하실 수 있습니다.

## 📡 외부 앱 연동 가이드 (Developer Guide)

외부 앱(예: `daddy-keep-working`)에서 MLX Hub를 조작하거나 상태를 구독하려면 다음 규격을 사용하십시오.

### 1. 앱 실행 트리거 (Custom URI Scheme)
앱이 설치된 경우, 아래 스킴을 호출하여 앱을 활성화하거나 실행할 수 있습니다.
- **URI Scheme**: `mlx-hub://`
- **사용 예시 (Terminal)**: `open mlx-hub://`

### 2. 실시간 상태 구독 (Unix Domain Socket)
MLX 서버의 상태가 변경될 때마다 실시간으로 데이터를 푸시받을 수 있습니다.
- **소켓 경로**: `/tmp/mlx-hub.sock`
- **데이터 형식**: Newline-delimited JSON (NDJSON)
- **통신 플로우**:
  1. 소켓 연결 즉시 **현재 최신 상태** 1회 수신.
  2. 이후 서버 시작/정지/설치 등 **상태 변화 발생 시마다** 새로운 JSON 패킷 수신.

---
*본 저장소는 배포 전용이며, 모든 소스 코드는 Private 저장소에서 관리됩니다.*
