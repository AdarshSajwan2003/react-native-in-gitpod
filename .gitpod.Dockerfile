FROM gitpod/workspace-full-vnc
SHELL ["/bin/bash", "-c"]

ENV ANDROID_HOME=/home/gitpod/androidsdk

# Install packages
USER root
RUN install-packages build-essential libkrb5-dev gcc make gradle android-tools-adb android-tools-fastboot

# Install Open JDK
USER root
RUN apt update \
    && apt install openjdk-17-jdk -y 

# Install SDK Manager
USER gitpod
RUN  wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
    && mkdir -p $ANDROID_HOME/cmdline-tools/latest \
    && unzip commandlinetools-linux-*.zip -d $ANDROID_HOME \
    && rm -f commandlinetools-linux-*.zip \
    && mv $ANDROID_HOME/cmdline-tools/bin $ANDROID_HOME/cmdline-tools/latest \
    && mv $ANDROID_HOME/cmdline-tools/lib $ANDROID_HOME/cmdline-tools/latest

RUN echo "export ANDROID_HOME=$ANDROID_HOME" >> /home/gitpod/.bashrc \
    && echo 'export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools:$PATH' >> /home/gitpod/.bashrc

    
# Install Android Image version 30
USER gitpod
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-30" "emulator"
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "system-images;android-30;google_apis;x86_64"
RUN echo no | $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd -n avd28 -k "system-images;android-30;google_apis;x86_64"


# misc deps

# For Qt WebEngine on docker
ENV QTWEBENGINE_DISABLE_SANDBOX 1
