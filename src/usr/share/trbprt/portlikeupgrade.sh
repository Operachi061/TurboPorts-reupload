. /etc/trbprt.conf
. $PORTSDIR$PORT/PORTLIKE
PORTVERSION=$(ls /usr/share/trbprt/database | grep $PORT)
echo "Trbprt => Checking availability port in portlist"
if [ "$PORTVERSION" = "" ]; then
   echo "Trbprt => Port is not available in database exiting..."
   exit
else
   echo "Trbprt => Port is available in database"
fi
echo "Trbprt => Checking for update"
if [ $FETCHINGTYPE = 'GIT' ]; then
   PORTCHK="$(git ls-remote --refs --tags $URL | cut --delimiter='/' --fields=3 | tr -d 'v' | grep -v rc | grep -v beta | sort --version-sort | tail --lines=1)"
else
   PORTCHK="$VERSION"
fi
if [ "$PORT $PORTCHK" = "$PORTVERSION" ]; then
    echo "Trbprt => $PORT has current version"
else
    echo "Trbprt => $PORT has available update"
    echo -n "Trbprt => Do you want upgrade this port? [Y/n] "
    read input
    if [ "$input" = 'Y' ]; then
       cd $PORTSDIR$PORT
       trbprt install
    elif [ "$input" = 'y' ]; then
       cd $PORTSDIR$PORT
       trbprt install
    elif [ "$input" = 'N' ]; then
       exit
    elif [ "$input" = 'n' ]; then
       exit
    elif [ "$input" = "" ]; then
       cd $PORTSDIR$PORT
       trbprt install
    else
       echo "Trbprt => Your decision is invaild exiting..."
    fi
fi