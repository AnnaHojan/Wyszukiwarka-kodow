set url=%1
set login=%2
set password=%3
curl --insecure -i %url% -u %login%:%password% > temp.txt
more +21 temp.txt > curler_output.txt