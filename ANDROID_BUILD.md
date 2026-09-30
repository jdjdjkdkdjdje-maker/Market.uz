# Android APK yaratish

## Lokal export
- Godot 4.3 yoki yangiroq, OpenJDK 17 va Android SDK o‘rnating.
- Godot Editor Settings → Export → Android bo‘limida SDK/JDK yo‘llarini belgilang.
- Project → Export → Add → Android.
- Package/Unique Name: `com.uzfootball.game`
- Version Name: `1.0.0`
- Architectures: `arm64-v8a` yoqilgan, `armeabi-v7a` o‘chirilgan.
- Debug APK uchun Export Project tugmasini bosing.
- Google Play release uchun Project → Export → Android → Keystore bo‘limida shaxsiy release keystore ulang. Keystore'ni GitHub'ga yuklamang.

## GitHub Actions
`.github/workflows/android.yml` workflow'ini GitHub Actions sahifasidan `Run workflow` qiling. Build tugagach, **UZ-FOOTBALL-Android** artifactidan APKni yuklab oling. Release signing secrets ataylab qo‘shilmagan: xavfsizlik uchun shaxsiy keystore kerak.

## Qurilmada test
APKni Android 8.0+ qurilmaga o‘rnating. Birinchi ishga tushishda faylga ruxsat so‘ralmaydi; progress Godot `user://` ichida avtomatik saqlanadi.
