import { Linking } from "react-native";

const appStoreMap = new Map<string, string>([
    ['citimobileapp', 'https://apps.apple.com/app/id1179759666'],
    ['cloudpay', 'https://apps.apple.com/app/id847268987'],
    ['com.wooricard.wcard', 'https://apps.apple.com/app/id1499598869'],
    ['hdcardappcardansimclick', 'https://apps.apple.com/app/id702653088'],
    ['ispmobile', 'https://apps.apple.com/app/id369125087'],
    ['kakaotalk', 'https://apps.apple.com/app/id362057947'],
    ['kb-acp', 'https://apps.apple.com/app/id695436326'],
    ['kbbank', 'https://apps.apple.com/app/id373742138'],
    ['lotteappcard', 'https://apps.apple.com/app/id688047200'],
    ['lpayapp', 'https://apps.apple.com/app/id1036098908'],
    ['monimopay', 'https://apps.apple.com/app/id379577046'],
    ['monimopayauth', 'https://apps.apple.com/app/id379577046'],
    ['mpocket.online.ansimclick', 'https://apps.apple.com/app/id535125356'],
    ['naversearchthirdlogin', 'https://apps.apple.com/app/id393499958'],
    ['newsmartpib', 'https://apps.apple.com/app/id1470181651'],
    ['nhallonepayansimclick', 'https://apps.apple.com/app/id1177889176'],
    ['nhappcardansimclick', 'https://apps.apple.com/app/id1177889176'],
    ['payco', 'https://apps.apple.com/app/id924292102'],
    ['shinhan-sr-ansimclick', 'https://apps.apple.com/app/id572462317'],
    ['supertoss', 'https://apps.apple.com/app/id839333328'],
    ['yonseipay', 'https://apps.apple.com/us/app/id1026609372']
]);

export async function openAppStoreByScheme(
    scheme: string
): Promise<boolean> {
    const url = appStoreMap.get(scheme);

    if (!url) {
        return false;
    }

    try {
        await Linking.openURL(url);
        return true;
    } catch {
        return false;
    }
}
