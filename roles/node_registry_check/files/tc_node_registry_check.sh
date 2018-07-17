PORT=$1
HOST=$2
TIMEOUT_IN_SEC=${3:-1}
VALUE_IF_OPEN=${4:-"The registry $2":"$1 is connected"}
VALUE_IF_CLOSED=${5:-"The registry $2":"$1 is unreachable"}
 
function eztern()
{
  if [[ $1 = "$2" ]]
  then
    echo $3
  else
    echo $4
  fi
}
 
function eztimeout() { perl -e 'alarm shift; exec @ARGV' "$@"; }
 
function testPort()
{
 
  # find out if port is open using telnet
  # by saving telnet output to temporary file
  # and looking for "Escape character" response
  # from telnet
  FILENAME="/tmp/__port_check_$(uuidgen)"
  RESULT=$(timeout $TIMEOUT_IN_SEC telnet $HOST $PORT &> $FILENAME; cat $FILENAME | tail -n1|awk '{print $1$2}')
  rm -f $FILENAME;
  SUCCESS=$(eztern "$RESULT" "Escapecharacter" "$VALUE_IF_OPEN" "$VALUE_IF_CLOSED")
 
  echo "$SUCCESS"
}
 
testPort
