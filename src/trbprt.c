/* Copyright (c) 2023 TurboPorts Operachi*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int main(int argc, char **argv) {
   void trbprtinf() { printf("\033[0;33mTrbprt => \033[0;0m"); }
   void rootcheck() {
      if (geteuid() != 0) {
         trbprtinf(); printf("Root is not enabled\n");
         exit(1);
      } else {
         NULL;
      }
   }
   void funarguments() {
      trbprtinf(); printf("Please write argument. Available arguments: build, version, remove, upgrade, portlist, compress, install.\n"
      "Usage: trbprt build <option>\n"
      "       trbprt version\n"
      "       trbprt install\n"
      "       trbprt package <Portname-version>\n"
      "       trbprt remove <Portname>\n"
      "       trbprt upgrade <option> <Portname>\n"
      "Options: build --debug --help\n"
      "         upgrade --all \n");
   }
   void funversion() { 
      printf(
      " ------------------------                                                                       \n"
      "/________     ___________/                                                                      \n"
      "         /###/                                                                                  \n"
      "        /###/                                                                                   \n"
      "       /###/                                                                                    \n"
      "      /###/                            _                                                        \n"
      "     /###/        __   __    _____    /#\\__   ____                                             \n"
      "    /###/        /##/ /##/  /#####/  /#####/ /####/                                             \n"
      "   /###/        /##/ /##/  /##/ #/  /##/##/ /##/#/    Copyright (c) 2023-2023 Bartlomiej Litwin \n"
      "  /###/        /#######/  /##/     /##/##/ /####/                                               \n"
      " /###/                                                                                          \n"
      "/###/                    Ports                                                                  \n"
      "\n"
      "              TurboPorts 1.1.1 Version\n");
   }
   void funbuild() {
      if (argc > 2) {
         if (!strcmp(argv[2], "--debug")) {
            trbprtinf(); printf("Building port\n");
            system("DEBUG=1 sh /usr/share/trbprt/portlikesupport.sh");
         } else if (!strcmp(argv[2], "--help")) {
            trbprtinf(); printf("For building package you must be in directory with PORTLIKE file. \n");
         } else {
            NULL;
         } 
      } else {
        system("sh /usr/share/trbprt/portlikesupport.sh");
      }
   }
   void funupgrade() {
      if (argc > 2) {
         if (!strcmp(argv[2], NULL)) {
            trbprtinf(); printf("Please write name of port\n");
         } else if (!strcmp(argv[2], "--all")) {
            system("sh /usr/share/trbprt/portlikeupgradeall.sh");
         } else {
            char portupgrade[] = "PORT=";
            strcat(portupgrade, argv[2]);
            strcat(portupgrade, " sh /usr/share/trbprt/portlikeupgrade.sh");
            system(portupgrade);
         }
      }
   }
   void funremove() {
      rootcheck();
      if (argc == 2) {
         trbprtinf(); printf("Please write name of port\n");
      } else {
         char path[] = "ls /usr/share/trbprt/database | grep ";
         strcat(path, argv[2]);
         strcat(path, " >> check");
         system(path);
         FILE *port = fopen("./check", "r");
         char print[99];
         if (fgets(print, 10, port) == NULL) {
            trbprtinf(); printf("%s is not installed\n", argv[2]);
            return 0;
         }
         if (argc > 2) {
            int choose;
            trbprtinf(); printf("This port will be removed: %s\n", argv[2]);
            trbprtinf(); printf("Do you want remove this port? [Y/n] ");
            system("rm check");
            scanf("%c", &choose);
            if (choose == 89 | choose == 121) {
               trbprtinf(); printf("Removing\n");
               char portname[] = "rm -rf $(cat /usr/share/trbprt/database/";
               strcat(portname, argv[2]);
               strcat(portname, "*");
               strcat(portname, ")");
               system(portname);
               char portname2[] = "rm /usr/share/trbprt/database/";
               strcat(portname2, argv[2]);
               strcat(portname2, "*");
               system(portname2);
               trbprtinf(); printf("Removing is complete\n");
            } else {
               trbprtinf(); printf("Exiting\n");
               exit(1);
            }
         }
      }
   }
   void funpackage() {
      rootcheck();
      char one[99] = "fallocate -l $(echo $(echo $(du -sk ./"; strcat(one, argv[2]); strcat(one, " | cut -f1)+ 50 | bc)K) "); strcat(one, argv[2]); strcat(one, ".vpart >/dev/null 2>&1"); system(one);
      char two[99] = "mkfs.ext2 "; strcat(two, argv[2]); strcat(two, ".vpart >/dev/null 2>&1"); system(two);
      char three[99] = "mkdir "; strcat(three, argv[2]); strcat(three, "vpart"); system(three);
      char four[99] = "mount -o loop "; strcat(four, argv[2]); strcat(four, ".vpart "); strcat(four, argv[2]); strcat(four, "vpart"); system(four);
      char five[99] = "cp -r "; strcat(five, argv[2]); strcat(five, "/* "); strcat(five, argv[2]); strcat(five, "vpart"); system(five);
      char six[99] = "umount "; strcat(six, argv[2]); strcat(six, "vpart"); system(six);
      char seven[99] = "rm -r "; strcat(seven, argv[2]); strcat(seven, "vpart"); system(seven);
      char eight[99] = "tar -cf "; strcat(eight, argv[2]); strcat(eight, ".tar "); strcat(eight, argv[2]); strcat(eight, ".vpart >/dev/null 2>&1"); system(eight);
      char nine[99] = "zstd --ultra "; strcat(nine, argv[2]); strcat(nine, ".tar >/dev/null 2>&1"); system(nine);
      char ten[99] = "mv "; strcat(ten, argv[2]); strcat(ten, ".tar.zst " ); strcat(ten, argv[2]); strcat(ten, ".trbpkg"); system(ten);
      char eleven[99] = "rm -r "; strcat(eleven, argv[2]); strcat(eleven, ".tar"); system(eleven);
      char twelve[99] = "rm -r "; strcat(twelve, argv[2]); strcat(twelve, ".vpart"); system(twelve);
      trbprtinf(); printf("Packaging to .trbpkg completed!\n");
   }
   void funinstall() {
      rootcheck();
      int choose;
      if (argc > 2) {
         trbprtinf(); printf("This port will be installed: %s\n", argv[2]);
         trbprtinf(); printf("Do you want install this port? [Y/n] ");
         scanf("%c", &choose);
         if (choose == 89 | choose == 121) {
            trbprtinf(); printf("Installing %s\n", argv[2]);
            char per[3] = "\%";
            trbprtinf(); printf("Unpacking                -{->                             }- 1%s \r", per);
            fflush(stdout);
            char one[99] = "cp "; strcat(one, argv[2]); strcat(one, ".trbpkg " ); strcat(one, argv[2]); strcat(one, ".tar.zst"); system(one);
            trbprtinf(); printf("Unpacking                -{----->                         }- 29%s \r", per);
            fflush(stdout);
            char two[99] = "unzstd "; strcat(two, argv[2]); strcat(two, ".tar.zst >/dev/null 2>&1"); system(two);
            trbprtinf(); printf("Unpacking                -{--------->                     }- 37%s \r", per);
            fflush(stdout);
            char three[99] = "tar -xf "; strcat(three, argv[2]); strcat(three, ".tar"); system(three);
            trbprtinf(); printf("Unpacking                -{------------->                 }- 45%s \r", per);
            fflush(stdout);
            char four[99] = "rm "; strcat(four, argv[2]); strcat(four, ".tar"); system(four);
            trbprtinf(); printf("Unpacking                -{----------------->             }- 53%s \r", per);
            fflush(stdout);
            char five[99] = "rm "; strcat(five, argv[2]); strcat(five, ".tar.zst"); system(five);
            trbprtinf(); printf("Unpacking                -{--------------------->         }- 61%s \r", per);
            fflush(stdout);
            char six[99] = "mkdir "; strcat(six, argv[2]); strcat(six, "vpart"); system(six);
            trbprtinf(); printf("Unpacking                -{------------------------->     }- 68%s \r", per);
            fflush(stdout);
            char seven[99] = "mount -o loop "; strcat(seven, argv[2]); strcat(seven, ".vpart "); strcat(seven, argv[2]); strcat(seven, "vpart"); system(seven);
            trbprtinf(); printf("Unpacking                -{---------------------------->  }- 73%s \r", per);
            fflush(stdout);
            char sources[99] = "SOURCES="; strcat(sources, "$(find /usr/*); echo "); strcat(sources, "\"${SOURCES[@]}\""); strcat(sources, " > ./sourcesfile"); system(sources);
            trbprtinf(); printf("Unpacking                -{-----------------------------> }- 81%s \r", per);
            fflush(stdout);
            char eight[99] = "cp -r "; strcat(eight, argv[2]); strcat(eight, "vpart/*");strcat(eight, " /usr"); system(eight);
            trbprtinf(); printf("Unpacking                -{------------------------------>}- 100%s \r\n", per);
            fflush(stdout);
            char newsources[99] = "NEWSOURCES="; strcat(newsources, "$(find /usr/*); echo "); strcat(newsources, "\"${NEWSOURCES[@]}\""); strcat(newsources, " > ./newsourcesfile"); system(newsources);
            trbprtinf(); printf("Cleaning                 -{->                             }- 1%s \r", per);
            fflush(stdout);
            char newfile[999] = "NEWFILE=$(diff -u ./sourcesfile ./newsourcesfile | grep -v @ | grep + | sed '1d' | sed '1d' | sed 's/+//'); echo "; strcat(newfile, "${NEWFILE[@]}"); strcat(newfile, " >> /usr/share/trbprt/sources/database/"); strcat(newfile, argv[2]); system(newfile);
            trbprtinf(); printf("Cleaning                 -{------------->                 }- 45%s \r", per);
            fflush(stdout);
            system("rm sourcesfile newsourcesfile");
            trbprtinf(); printf("Cleaning                 -{----------------->             }- 53%s \r", per);
            fflush(stdout);
            char nine[99] = "umount "; strcat(nine, argv[2]); strcat(nine, "vpart"); system(nine);
            trbprtinf(); printf("Cleaning                 -{--------------------->         }- 61%s \r", per);
            fflush(stdout);
            char ten[99] = "rm -r "; strcat(ten, argv[2]); strcat(ten, "vpart"); system(ten);
            trbprtinf(); printf("Cleaning                 -{------------------------->     }- 68%s \r", per);
            fflush(stdout);
            char eleven[99] = "rm -r "; strcat(eleven, argv[2]); strcat(eleven, ".vpart"); system(eleven);
            trbprtinf(); printf("Cleaning                 -{-----------------------------> }- 81%s \r", per);
            fflush(stdout);
            char twelve[99] = "touch "; strcat(twelve, " /usr/share/trbprt/database/"); strcat(twelve, argv[2]); system(twelve);
            trbprtinf(); printf("Cleaning                 -{------------------------------>}- 100%s \r\n", per);
            fflush(stdout);
            trbprtinf(); printf("%s installed!\n", argv[2]);
         } else {
            trbprtinf(); printf("Exiting\n");
            exit(1);
         }
      }
   }
   if (argc > 1) {
      if (!strcmp(argv[1], "build")) {
         funbuild();
      } else if (!strcmp(argv[1], "upgrade")) {
         funupgrade();
      } else if (!strcmp(argv[1], "version")) {
         funversion();
      } else if (!strcmp(argv[1], "remove")) {
         funremove();
      } else if (!strcmp(argv[1], "portlist")) {
         system("ls /usr/share/trbprt/database | tr -d '.' | tr -d -");
      } else if (!strcmp(argv[1], "package")) {
         funpackage();
      } else if (!strcmp(argv[1], "install")) {
         funinstall();
      } else {
         trbprtinf(); printf("Your argument is invaild. \n");
         funarguments();
      }
   } else {
     funarguments();
   } 
}