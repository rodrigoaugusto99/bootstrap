- C:\dev\rodrigo\
- git clone https://github.com/rodrigoaugusto99/api_bootstrap.git project-name
- git clone https://github.com/rodrigoaugusto99/bootstrap.git app
- Remove-Item -Recurse -Force .git
- cd app + Remove-Item -Recurse -Force .git
- criar repositorio no github
- git remote add origin <link>
- criar projeto no firebase
- cd app + dart run change_app_package_name:main com.example.tal
- firebase login:use rodrigoaugusto051@gmail.com
- flutterfire configure --project=id-do-projeto
- keytool -genkey -v -keystore upload_keystore_nome_projeto.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
- gerar senha aleatoria
- keytool -list -v -alias upload -keystore C:\Users\rodri\upload_keystore_famous_quest.jks
- adicionar sha1 e sha256 no firebase console
- botar key em D:\keys e adicionar em password
- criar key.properties em /android

---

storePassword=SENHA_AQUI
keyPassword=SENHA_AQUI
keyAlias=upload
storeFile=D:\\keys\\upload_keystore_nome_projeto.jks

---

- fill /docs
