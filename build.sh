./stop.sh

acme ./src/$1.asm
#mega65-master -prg ./build/$1.prg -prgmode 65 > /dev/null &
m65 -F -r ./build/$1.prg

