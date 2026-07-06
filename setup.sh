#!/bin/bash
set -e

echo "⚡ MLX Hub One-Click Auto-Installer ⚡"
echo "---------------------------------------"

# 1. 임시 작업 폴더 생성 및 최신 DMG 다운로드
TEMP_DIR=$(mktemp -d)
DMG_PATH="$TEMP_DIR/mlx-hub.dmg"
REPO="Gorita/mlx-hub"

echo "🔍 GitHub 릴리즈 저장소에서 최신 버전을 찾는 중..."
# GitHub API를 통해 최신 릴리즈의 .dmg 다운로드 링크 획득
LATEST_URL=$(curl -s https://api.github.com/repos/$REPO/releases/latest | grep "browser_download_url.*dmg" | cut -d '"' -f 4)

if [ -z "$LATEST_URL" ]; then
    echo "⚠️ 최신 릴리즈 정보를 가져오지 못했습니다. 폴백 주소로 진입합니다."
    LATEST_URL="https://github.com/Gorita/mlx-hub/releases/download/v0.2.0/mlx-hub_0.2.0_aarch64.dmg"
fi

echo "📥 DMG 파일 다운로드 중..."
curl -L -o "$DMG_PATH" "$LATEST_URL"
echo "✅ 다운로드 완료."

# 2. 다운로드한 DMG 볼륨 마운트
echo "💿 DMG 이미지 마운트 중..."
# 마운트 후 볼륨 경로(/Volumes/MLX Hub 등)를 동적으로 추출
MOUNT_POINT=$(hdiutil mount "$DMG_PATH" | grep -o "/Volumes/[^'$'\n']*" | head -n 1)

if [ -z "$MOUNT_POINT" ]; then
    echo "❌ DMG 마운트에 실패했습니다."
    exit 1
fi
echo "✅ 마운트 지점 확인: $MOUNT_POINT"

# 3. 앱 번들 응용 프로그램 폴더로 복사
echo "📦 응용 프로그램(/Applications) 폴더로 앱 복사 중..."
# 기존 설치본이 있을 경우 덮어쓰기 복사
cp -R "$MOUNT_POINT/mlx-hub.app" /Applications/

# 4. 마운트 해제 및 임시 청소
echo "🧹 마운트 해제 및 임시 파일 정리 중..."
hdiutil detach "$MOUNT_POINT" -quiet
rm -rf "$TEMP_DIR"

# 5. Gatekeeper 격리 해제(xattr) 처리
echo "🔒 보안 시스템에 등록하여 격리 경고를 해제합니다..."
xattr -d com.apple.quarantine /Applications/mlx-hub.app 2>/dev/null || sudo xattr -d com.apple.quarantine /Applications/mlx-hub.app

echo "---------------------------------------"
echo "🎉 MLX Hub 설치 및 보안 설정이 완료되었습니다!"
echo "🚀 런치패드나 응용 프로그램 폴더에서 mlx-hub 앱을 실행해 주세요."
