typeset -gxU path PATH

export ANDROID_HOME=$HOME/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

path+=(
    /home/chuufmaster/.local/bin
    /home/chuufmaster/.cargo/bin
    /home/chuufmaster/.dotnet/tools
    /opt/miktex/bin
    /usr/bin/flutter/bin
    /usr/local/{sbin,bin}
    /{sbin,bin}
    /home/chuufmaster/android-sdk/platform-tools/
    /home/chuufmaster/.pub-cache/bin
    $path
)

# export PATH
