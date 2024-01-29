. /etc/trbprt.conf
echo "Trbprt => Checking for update"
PORT=($(ls /usr/share/trbprt/database | sed 's/[0-9]*//g' | tr -d '.' | tr -d -))
for i in "${PORT[@]}";
do
    if [ $i = 'xwayland' ]; then
      continue 1
    else
      :
    fi
    if [ $i = 'beta' ]; then
      continue 1
    else
      :
    fi
    PORTVERSION=$(ls /usr/share/trbprt/database | grep $i)
    . $PORTSDIR$i/PORTLIKE
    if [ $FETCHINGTYPE = 'GIT' ]; then
      PORTCHK="$(git ls-remote --refs --tags $URL | cut --delimiter='/' --fields=3 | tr -d 'v' | grep -v rc | grep -v beta | sort --version-sort | tail --lines=1)"
    else
      PORTCHK="$VERSION"
    fi
    if [ "$i $PORTCHK" = "$PORTVERSION" ]; then
      echo "Trbprt => $i has current version"
    else
      echo "Trbprt => $i has available update"
      touch portlikeupgradehintcache
    fi
done
if [ "$(ls portlikeupgradehintcache)" = 'portlikeupgradehintcache' ]; then
  rm portlikeupgradehintcache
  echo -n "Trbprt => Do you want update these ports? [Y/n] "
  read input
  if [ "$input" = 'Y' ]; then
   for i in "${PORT[@]}";
   do
      if [ $i = 'xwayland' ]; then
         continue 1
      else
         :
      fi
      if [ $i = 'beta' ]; then
         continue 1
      else
         :
      fi
      cd $PORTSDIR$i
      trbprt install
      
   done
  elif [ "$input" = 'y' ]; then
   for i in "${PORT[@]}";
   do
     if [ $i = 'xwayland' ]; then
        continue 1
     else
        :
     fi
     cd $PORTSDIR$i
     trbprt install
   done
  elif [ "$input" = 'N' ]; then
   exit
  elif [ "$input" = 'n' ]; then
   exit
  elif [ "$input" = "" ]; then
   for i in "${PORT[@]}";
   do
      if [ $i = 'xwayland' ]; then
         continue 1
      else
         :
      fi
     cd $PORTSDIR$i
     trbprt install
   done
  else
   echo "Trbprt => Your decision is invaild exiting..."
  fi
else
  exit
fi