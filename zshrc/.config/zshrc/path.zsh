typeset -gxU path PATH

export ANDROID_HOME=$HOME/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

path+=(
    /home/chuufmaster/.local/bin
    /home/chuufmaster/.cargo/bin
    /home/chuufmaster/.dotnet/tools
    /opt/miktex/bin
    $HOME/.flutter-install/flutter/bin
    /usr/local/{sbin,bin}
    /{sbin,bin}
    /home/chuufmaster/android-sdk/platform-tools/
    /home/chuufmaster/.pub-cache/bin
    /home/chuufmaster/scripts
    /home/chuufmaster/COS326_Pracs/basex/bin
    /home/chuufmaster/.local/share/gem/ruby/3.3.0/bin
    $path
)

# export PATH
