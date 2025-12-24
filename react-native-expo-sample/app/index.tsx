
import { Alert, Linking, Platform, StyleSheet } from 'react-native';
import * as AppLauncher from 'react-native-intent-app-launcher';
import { SafeAreaView } from 'react-native-safe-area-context';
import { WebView } from 'react-native-webview';
import { ShouldStartLoadRequest } from 'react-native-webview/lib/WebViewTypes';
import { openAppStoreByScheme } from '../utils/iosUtils';

const openIsoApp = async (url: string): Promise<void> => {
  const isAppInstalled = await Linking.canOpenURL(url);

  if (isAppInstalled) {
    await Linking.openURL(url);
    return;
  }

  const scheme = url.split('://')[0];
  const opened = openAppStoreByScheme(scheme);

  if (!opened) {
    Alert.alert('오류', '스토어 정보를 찾을 수 없습니다.');
  }

};

const openAndroidApp = async (url: string): Promise<void> => {
  try {
    const opened = await AppLauncher.openAndroidApp(url);

    if (!opened) {
      const packageName = await AppLauncher.extractAndroidPackageName(url);

      if (!packageName) {
        Alert.alert('오류', '패키지 정보를 찾을 수 없습니다.');
        return;
      }

      const storeUrl = `market://details?id=${packageName}`;
      const isStoreAvailable = await Linking.canOpenURL(storeUrl);

      if (isStoreAvailable) {
        await Linking.openURL(storeUrl);
      } else {
        Alert.alert('오류', '스토어 정보를 찾을 수 없습니다.');
      }

    }
  } catch (e) {
    console.error('Android intent handling error', e);
    Alert.alert('오류', '앱 실행 중 오류가 발생했습니다.');
  }

}


export default function HomeScreen() {

  const onShouldStartLoadWithRequest = (
    event: ShouldStartLoadRequest
  ): boolean => {
    const url = event.url;

    if (
      url.startsWith('http') ||
      url.startsWith('https') ||
      url.startsWith('about')
    ) {
      return true;
    }

    if (Platform.OS === 'android') {
      openAndroidApp(url);
      return false;
    }

    if (Platform.OS === 'ios') {
      openIsoApp(url);
      return false;
    }

    return true;
  };

  return (
    <SafeAreaView style={styles.container}>

      <WebView
        style={styles.container}
        javaScriptEnabled={true}
        setSupportMultipleWindows={false}
        originWhitelist={['*']}
        onShouldStartLoadWithRequest={onShouldStartLoadWithRequest}
        source={{ uri: 'http://localhost:80/auth.php' }}
      />

    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1
  },

});
