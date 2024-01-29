. /usr/share/trbprt/portlikefunctions.sh; . /etc/trbprt.conf; . $PWD/PORTLIKE;
INSTALL="true"
if [ $FETCHINGTYPE = 'GIT' ]; then
    VERSION=$(git ls-remote --refs --tags $URL | cut --delimiter='/' --fields=3 | tr -d 'v' | grep -v rc | grep -v beta | sort --version-sort | tail --lines=1)
fi
if [ "$TRBPRIS" = 'true' ]; then
    PREFIX="$CHROOTDIR/turboports/ports/$PORTNAME-$VERSION"
    if [ "$(ls $CHROOTDIR/turboports/ports | grep $PORTNAME-$VERSION)" = "$PORTNAME-$VERSION" ]; then
        trbprtinf; echo "Prefix found"
    else
        trbprtinf; echo "Prefix not found, creating prefix directory"
        mkdir $PREFIX
    fi
else
    PREFIX="$PWD/$PORTNAME-$VERSION"
    if [ "$(ls $PWD | grep $PORTNAME-$VERSION)" = "$PORTNAME-$VERSION" ]; then
        trbprtinf; echo "Prefix found"
    else
        trbprtinf; echo "Prefix not found, creating prefix directory"
        mkdir $PREFIX
    fi
fi
export CFLAGS
export CXXFLAGS
export MAKEFLAGS
export CC
export CXX
if [ "$(ls $PWD | grep $PORTNAME-$VERSION)" = "$PORTNAME-$VERSION" ]; then
    trbprtinf; echo "Prefix found"
else
    trbprtinf; echo "Prefix not found, creating prefix directory"
    mkdir $PREFIX
fi
if [ "$DEBUG" = '1' ]; then
    prepare
    if [ "$TRBPRIS" = 'true' ]; then
        trbpris
    else
        build
        if [ "$(ls $PREFIX)" = "" ]; then
            trbprtinf; echo "Building interrupted, exiting"
        else
            :
        fi
    fi
    clean
else
    trbprtinf; echo "If process of installation port is end to make sure please check file named 'turboportslog' "
    printf "\rTrbprt => Preparing $PORTNAME                                                                "
    prepare >./turboportslog 2>&1
    touch $PWD/portlikecache
    printf "\rTrbprt => Building $PORTNAME                                                                 "
    if [ "$TRBPRIS" = 'true' ]; then
        trbpris >./turboportslog 2>&1
        if [ "$(ls $PREFIX)" = "" ]; then
            trbprtinf; echo "Building interrupted, exiting"
        else
            :
        fi
    else
        build >./turboportslog 2>&1
        if [ "$(ls $PREFIX)" = "" ]; then
            trbprtinf; echo "Building interrupted, exiting"
        else
            :
        fi
    fi
    rm $PWD/portlikecache
    printf "\rTrbprt => Cleaning $PORTNAME                                                                 "
    echo " "
    clean >./turboportslog 2>&1
fi