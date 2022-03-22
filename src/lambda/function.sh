# writes given text parameters to stderr 
function echoerr() { 
  echo "$@" 1>&2; 
}

# returns a list of files (executables) accessible via $PATH
function handler () {
  EVENT_DATA=$1
  echoerr "EVENT_DATA: $EVENT_DATA"
  echoerr "PATH: $PATH"

  # format response as json object
  RESPONSE="{\"runtime\": {\"environment\": {"
  RESPONSE+="\"system_date\": \"$(date)\","
  RESPONSE+="\"path\": \"$PATH\","

  PATHLIST=$(for i in $(echo $PATH | sed -e 's/\:/\ /g'); do echo "\"$i\": \"$(ls $i | tr "\n" " ")\","; done)
  echoerr "PATH_MEMBERS: $PATHLIST"

  RESPONSE+="\"path_members\": {$(echo $PATHLIST | sed 's/.$//')}"
  RESPONSE+="}}}"

  echo $RESPONSE
}
