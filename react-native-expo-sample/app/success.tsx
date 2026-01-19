// app/success.tsx
import React from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';

export default function SuccessScreen() {
    const router = useRouter();
    const params = useLocalSearchParams();
    const { orderNumber } = params;

    const goHome = () => {
        if (router.canGoBack()) {
            router.dismissAll();
        }
        router.replace('/');
    };

    return (
        <View style={styles.container}>
            <Text style={styles.title}>결제 완료</Text>
            <Text style={styles.text}>주문번호: {orderNumber}</Text>

            <Pressable style={styles.button} onPress={goHome}>
                <Text style={styles.buttonText}>홈으로 돌아가기</Text>
            </Pressable>
        </View>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#fff' },
    title: { fontSize: 24, fontWeight: 'bold', marginBottom: 20 },
    text: { fontSize: 16, marginBottom: 40 },
    button: { padding: 15, backgroundColor: '#007AFF', borderRadius: 8 },
    buttonText: { color: '#fff', fontSize: 16 },
});