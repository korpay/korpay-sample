# Korpay React Native Expo 샘플 프로젝트

이 프로젝트는 네이티브 코드가 포함된 커스텀 모듈(`react-native-intent-app-launcher`)을 사용합니다.
따라서 **Expo Go에서는 실행되지 않습니다.** 아래 가이드에 따라 **Expo PreBuild**를 생성하여 실행해야 합니다.

1. **서버 구동**:
   - 어느 서버를 사용하나 상관 없지만 샘플 프로젝트에서는 php 서버를 기준으로 제작되었습니다.
   - `php-sample` 프로젝트를 80 포트로 실행해주세요.
   - **주의:** Android 에뮬레이터에서 로컬 서버 접속 시 `localhost` 대신 `10.0.2.2`를 사용해야 할 수 있습니다.

2. **패키지 설치**:
   ```bash
   npm install
   ```

3. **Info.plist 스키마 추가**:
   - iOS에서 외부 결제 앱(ISP, 앱카드 등)을 실행하려면, 허용할 앱의 URL 스키마를 미리 등록해야 합니다. app.json 파일의 ios.infoPlist.LSApplicationQueriesSchemes 항목에 필요한 스키마를 추가하세요.

4. **Prebuild**:
   ```bash
   npx expo prebuild --clean
   ```

5. **실행**:
   ```bash
   npx expo run:android --device
   npx expo run:ios --device
   ```

### 참고 사항

로컬 개발 환경 등에서 **HTTP 통신을 사용하는 경우**, 플랫폼별로 아래 설정이 필요합니다.

#### Android

HTTP 통신을 허용하려면 `AndroidManifest.xml`에 아래 설정을 추가해야 합니다.

```xml
android:usesCleartextTraffic="true"
```

#### iOS

HTTP 통신을 허용하려면 app.json 또는 Info.plist에 아래 설정을 추가해야 합니다.

```plist
NSAllowsArbitraryLoads = true
```