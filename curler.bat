set url=%1
set login=%2
set password=%3
set linestocut=%4
curl --insecure -i %url% -u %login%:%password% > temp.txt
more +%linestocut% temp.txt > curler_output.txt