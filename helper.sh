ORANGE=$'\e[33m'
GREEN=$'\e[32m'
RED=$'\e[31m'
NC=$'\e[0m'

sp="/-\|"
sc=0

spin() {
  printf "\b${sp:sc++:1}"
  ((sc==${#sp})) && sc=0
}

endspin() {
  printf "\r%s\n" "$@" | sed 's/.$//'
}

startloading() {
  while :;do spin;sleep 0.1;done &
  trap "kill $!" EXIT
}

endloading() {
  kill $! && trap " " EXIT
  endspin
}
