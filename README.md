# Overview

This project implements an AWS Lambda function using a custom runtime and executes a handler 
written as a Bourne shell script (/bin/sh). Deployment of Lambda function and associated security
setup is implemented using Terraform. 

AWS Lambda custom runtime can allow application developers who have atypical use-cases or to execute
serverless functions using non-standard runtime engines that isn't offered by Lambda (e.g. running 
a Perl runtime). It also offers an ability to run arbitrary Linux shell scripts or binary executables 
wrapped by simple shell scripts. 

See here for more information on custom runtime: https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html

# Testing

**Invoke Lambda from CLI**
```shell
aws lambda invoke --function-name lambda_sh --invocation-type RequestResponse --payload '{"param1": "test"}' test_response.json --log-type Tail && cat test_response.json
```

**Invoke Lambda and retrieve logs**
```shell
aws lambda invoke --function-name lambda_sh --invocation-type RequestResponse --payload '{"param1": "test"}' test_response.json --log-type Tail --query 'LogResult' --output text |  base64 -d
```

**Lambda will return a response object that should look similar to this**
```json
{
  "runtime": {
    "environment": {
      "system_date": "Tue Mar 22 17:11:12 UTC 2022",
      "path": "/usr/local/bin:/usr/bin/:/bin:/opt/bin",
      "path_members": {
        "/usr/local/bin": "",
        "/usr/bin/": "[ alias arch awk base64 basename bash bashbug bashbug-64 bg ca-legacy captoinfo cat catchsegv cd certutil chcon chgrp chmod chown cksum clear cmsutil comm command cp crlutil csplit curl cut date db_archive db_checkpoint db_deadlock db_dump db_dump185 db_hotbackup db_load db_log_verify db_printlog db_recover db_replicate db_stat db_tuner db_upgrade db_verify dd df dgawk dir dircolors dirname du echo egrep env expand expr factor false fc fg fgrep find fmt fold gawk gencat getconf getent getopts grep groups head hostid iconv id igawk info infocmp infokey infotocap install jobs join ldd link ln locale localedef logname ls lua luac makedb md5sum mkdir mkfifo mknod mktemp modutil mv nice nl nohup nproc nss-policy-check numfmt od oldfind p11-kit paste pathchk pgawk pinky pk12util pldd pr printenv printf ptx pwd read readlink realpath reset rm rmdir rpcgen rpm rpm2cpio rpmdb rpmkeys rpmquery rpmverify runcon sed seq setup-nsssysinit setup-nsssysinit.sh sh sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf signver sleep sort sotruss split sprof sqlite3 ssltap stat stdbuf stty sum sync tabs tac tail tee test tic timeout toe touch tput tr true truncate trust tset tsort tty tzselect umask unalias uname unexpand uniq unlink update-ca-trust users vdir wait wc who whoami xargs xmlcatalog xmllint yes ",
        "/bin": "[ alias arch awk base64 basename bash bashbug bashbug-64 bg ca-legacy captoinfo cat catchsegv cd certutil chcon chgrp chmod chown cksum clear cmsutil comm command cp crlutil csplit curl cut date db_archive db_checkpoint db_deadlock db_dump db_dump185 db_hotbackup db_load db_log_verify db_printlog db_recover db_replicate db_stat db_tuner db_upgrade db_verify dd df dgawk dir dircolors dirname du echo egrep env expand expr factor false fc fg fgrep find fmt fold gawk gencat getconf getent getopts grep groups head hostid iconv id igawk info infocmp infokey infotocap install jobs join ldd link ln locale localedef logname ls lua luac makedb md5sum mkdir mkfifo mknod mktemp modutil mv nice nl nohup nproc nss-policy-check numfmt od oldfind p11-kit paste pathchk pgawk pinky pk12util pldd pr printenv printf ptx pwd read readlink realpath reset rm rmdir rpcgen rpm rpm2cpio rpmdb rpmkeys rpmquery rpmverify runcon sed seq setup-nsssysinit setup-nsssysinit.sh sh sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf signver sleep sort sotruss split sprof sqlite3 ssltap stat stdbuf stty sum sync tabs tac tail tee test tic timeout toe touch tput tr true truncate trust tset tsort tty tzselect umask unalias uname unexpand uniq unlink update-ca-trust users vdir wait wc who whoami xargs xmlcatalog xmllint yes ",
        "/opt/bin": ""
      }
    }
  }
}
```
