#ArchISO Init Script
this is an example of archiso init script

this script is separated to three parts :
* Init
  * install software
  * do something before chroot
* PostInit
  * initial something globally (grub, user account, locale, timezone, some package script, etc.)
* UserInit
  * initial environment of an user and root
