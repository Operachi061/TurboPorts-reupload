printf "Checking if git is available -> "
if [ "$(ls /usr/bin/git)" = "/usr/bin/git" ]; then
    echo "yes"
else
    echo "no"
    echo "Git is not available exiting."
    exit
fi
printf "Checking if curl is available -> "
if [ "$(ls /usr/bin/curl)" = "/usr/bin/curl" ]; then
    echo "yes"
else
    echo "no"
    echo "Curl is not available exiting."
    exit
fi
printf "Checking if e2fsprogs is available -> "
if [ "$(ls /usr/bin/mkfs.ext2)" = "/usr/bin/mkfs.ext2" ]; then
    echo "yes"
else
    echo "no"
    echo "e2fsprogs is not available exiting."
    exit
fi
printf "Checking if zstd is available -> "
if [ "$(ls /usr/bin/zstd)" = "/usr/bin/zstd" ]; then
    echo "yes"
else
    echo "no"
    echo "zstd is not available exiting."
    exit
fi
printf "Checking if util-linux is available -> "
if [ "$(ls /usr/bin/fallocate)" = "/usr/bin/fallocate" ]; then
    echo "yes"
else
    echo "no"
    echo "util-linux is not available exiting."
    exit
fi
make
cp -r ./src/usr/bin/trbprt /usr/bin/

if [ "$(ls /etc/trbprt.conf)" = "/etc/trbprt.conf" ]; then
   :
else
   cp ./src/etc/trbprt.conf /etc/trbprt.conf
fi
cp ./USING.trbpkg ~/
echo "Done"
echo "You can check USING.trbpkg file in you home directory! Write 'cat ~/USING.trbpkg'. "