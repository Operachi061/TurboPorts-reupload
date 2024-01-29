trbpris(){
    printf "\033[0;32mTrbpris => \033[0;0m"; echo "Jailing port"
    mount --bind /dev $CHROOTDIR/dev
    mount --bind /dev/pts $CHROOTDIR/dev/pts
    mount -t proc proc $CHROOTDIR/proc
    mount -t sysfs sysfs $CHROOTDIR/sys
    mount -t tmpfs tmpfs $CHROOTDIR/run
    chroot "$CHROOTDIR" /usr/bin/env -i    \
        HOME=/root                         \
        TERM="$TERM"                       \
        PS1='Trbpris => # '                \
        PATH=/usr/bin:/usr/sbin            \
        /bin/bash -c "export PREFIX=/turboports/ports/$PORTNAME-$VERSION; . /turboports/trbprt.conf; cd /turboports/ports/$PORTNAME; . ./PORTLIKE; export CFLAGS; export CXXFLAGS; export MAKEFLAGS; export CC; export CXX; cd ./$SRCNAME; build" 
    printf "\033[0;32mTrbpris => \033[0;0m"; echo "Turning off jail"
    umount $CHROOTDIR/dev/pts
    umount $CHROOTDIR/{dev,proc,sys,run}
}
trbprtinf(){
   printf "\033[0;33mTrbprt => \033[0;0m"
}
prepare(){
    trbprtinf; echo "Root check"
    if [ $(whoami) = 'root' ]; then
        trbprtinf; echo "Root is enabled, installing is continued."
    else
        trbprtinf; echo "Root is not enabled, installing is stoped."
        exit
    fi
    if [ $FETCHINGTYPE = 'GIT' ]; then
        trbprtinf; echo "Choosing GIT type fetching"
        FETCH="git clone $URL $FETCHDIR$SRCNAME"
    elif [ $FETCHINGTYPE = 'CURL' ]; then
        trbprtinf; echo "Choosing CURL type fetching"
        FETCH="curl $URL $FETCHDIR$SRCNAME"
    else
        trbprtinf; echo 'Writed fetching type is invaild'
        exit
    fi
    if [ $FETCHINGTYPE = 'GIT' ]; then
        MOVESOURCE="cp -r $FETCHDIR$SRCNAME ."
    elif [ $FETCHINGTYPE = 'CURL' ]; then
        MOVESOURCE="cp $FETCHDIR$SRCNAME .; tar xvf ./$SRCNAME"
    else
        trbprtinf; echo 'Writed fetching type is invaild'
        exit
    fi
    trbprtinf; echo "Checking package availability"
    if [ "$(ls $FETCHDIR | grep $SRCNAME)" = "$SRCNAME" ]; then
        trbprtinf; echo "Source named '$SRCNAME' is available, installing is continued"
        $MOVESOURCE
    else
        trbprtinf; echo "Source named '$SRCNAME' is not available, downloading source is being now."
        $FETCH
        $MOVESOURCE
    fi
    if [ "$(ls $FETCHDIR | grep $SRCNAME)" = "$SRCNAME" ]; then
        :
    else
        trbprtinf; echo "Source named '$SRCNAME' is again not available, installing is stoped."
        rm -rf $FETCHDIR$SRCNAME
        exit
    fi
    if [ "$TRBPRIS" = 'true'  ]; then
     for i in "${DEPENDENCIES[@]}";
     do
      if [ "$(ls /usr/share/trbprt/database | grep $i >/dev/null 2>&1)" != : ]; then
          trbprtinf; echo "Dependency named '$i' is installed, installation is continued"
          
      else
          trbprtinf; echo "Dependency named '$i' is not installed, installation is stoped and dependency is be installed"
          cd $PORTSDIR/$i
          trbprt build --debug
          cd $PORTSDIR/$PORTNAME
      fi
     done
    elif [ "$TRBPRIS" = 'false' ]; then
     for i in "${DEPENDENCIES[@]}";
     do
      if [ "$(ls /usr/share/trbprt/database | grep $i >/dev/null 2>&1)" != : ]; then
          trbprtinf; echo "Dependency named '$i' is installed, installation is continued"
      else
          trbprtinf; echo "Dependency named '$i' is not installed, installation is stoped and dependency is be installed"
          cd $PORTSDIR/$i
          trbprt build --debug
          cd $PORTSDIR/$PORTNAME
      fi
     done
    else
      :
    fi
    trbprtinf; echo "Building port"
    if [ "$TRBPRIS" = 'true'  ]; then
        if [ $FETCHINGTYPE = 'GIT' ]; then
           trbprtinf; echo "Copying files to trbpris"
           mkdir $CHROOTDIR/turboports/ports/$PORTNAME
           cp $PORTSDIR/PORTLIKE $CHROOTDIR/turboports/ports/$PORTNAME
           cp $PORTSDIR/../trbprt.conf $CHROOTDIR/turboports/
           mv ./$SRCNAME $CHROOTDIR/turboports/ports/$PORTNAME
           cd $CHROOTDIR/turboports/ports/$PORTNAME/$SRCNAME
        elif [ $FETCHINGTYPE = 'WGET' ]; then
           mkdir $CHROOTDIR/turboports/ports/$PORTNAME
           cp $PORTSDIR/$PORTNAME/PORTLIKE $CHROOTDIR/turboports/ports/$PORTNAME
           cp $PORTSDIR/../trbprt.conf $CHROOTDIR/turboports/
           mv ./$DECOMPRESSED_SRC_DIR $CHROOTDIR/turboports/ports/$PORTNAME
           cd $CHROOTDIR
           SOURCES="$(find ./$PREFIX/*)"
           echo "${SOURCES[@]}" > $CHROOTDIR/turboports/ports/$PORTNAME/sources
           cd $CHROOTDIR/turboports/ports/$PORTNAME/$DECOMPRESSED_SRC_DIR
        else
           trbprtinf; echo 'Writed fetching type is invaild'
           exit
        fi
    elif [ "$TRBPRIS" = 'false' ]; then 
       if [ $FETCHINGTYPE = 'GIT' ]; then
           cd ./$SRCNAME
        elif [ $FETCHINGTYPE = 'WGET' ]; then
           cd ./$DECOMPRESSED_SRC_DIR
        else
           trbprtinf; echo 'Writed fetching type is invaild'
           exit
        fi
    else
        :
    fi
}
clean(){
    if [ "$TRBPRIS" = 'true' ]; then
       rm $CHROOTDIR/turboports/trbprt.conf
       cd $PORTSDIR
       if [ $FETCHINGTYPE = 'GIT' ]; then
           trbprtinf; echo "$PORTNAME-$VERSION Finish!"
           if [ $INSTALL = 'true' ]; then
                cd ..
                cp -r $PREFIX .
                trbprt package $PORTNAME-$VERSION
                trbprt install $PORTNAME-$VERSION
                rm -rf $CHROOTDIR/turboports/ports/$PORTNAME $PREFIX ./$PORTNAME-$VERSION
            else
                :
           fi
       else
           trbprtinf; echo "$PORTNAME-$VERSION Finish!"
       fi
    elif [ "$TRBPRIS" = 'false' ]; then
       if [ $FETCHINGTYPE = 'GIT' ]; then
           trbprtinf; echo "$PORTNAME-$VERSION Finish!"
           if [ $INSTALL = 'true' ]; then
                cd ..
                cp -r $PREFIX .
                trbprt package $PORTNAME-$VERSION
                trbprt install $PORTNAME-$VERSION
                rm -rf $SRCNAME $PREFIX ./$PORTNAME-$VERSION
            else
                :
           fi
       else
           trbprtinf; echo "$PORTNAME-$VERSION Finish!"
       fi
    else
        :
    fi
} 
