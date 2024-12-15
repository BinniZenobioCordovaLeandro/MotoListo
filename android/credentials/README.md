# KEYSTORE

Keystore files are used to sign the application. The debug keystore is used to sign the application when running in debug mode. The release keystore is used to sign the application when running in release mode.

Also, PlayStore requires the application to be signed with a release keystore.

## Generate a new debug keystore

```bash
keytool -genkey -v -keystore debug.keystore -alias debugger -keyalg RSA -keysize 2048 -validity 10000 -storetype JKS -storepass debugger -keypass debugger
```

## Generate a new release keystore

```bash
keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000 -storetype JKS -storepass release -keypass release
```

## Configure PROPERTIES file

The keystore properties file is used to configure the keystore file to be used when signing the application.

The file is located at `android/key.properties`.

```properties
keyAlias=
keyPassword=
storeFile=../credentials/release.keystore
storePassword=

debug.keyAlias=
debug.keyPassword=
debug.storeFile=../credentials/debuger.keystore
debug.storePassword=
```

OBIOUSLY: change the passwords and aliases to your own.
