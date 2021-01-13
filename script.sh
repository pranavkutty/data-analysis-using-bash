mkdir -p $1

echo -e "logs to be saved in $1 folder in current directory"
echo "Starting download..."

wget "https://zenodo.org/record/3227177/files/SSH.tar.gz?download=1" -O "$1/sshlog.tar.gz"

tar -xvzf "$1/sshlog.tar.gz" -C $1

echo "Logs downloaded and unzipped"

echo "--------------------Starting analysis----------------------"

echo "No. of break-in attempts: "
grep -c "POSSIBLE BREAK-IN ATTEMPT!" $1/SSH.log

echo "No. of invalid certificate attempts: "
grep -c "Certificate invalid" $1/SSH.log

echo "Server listening on the following ports:"
grep "Server listening on" $1/SSH.log | grep -o "port [0-9][0-9][0-9]*" | grep -o "[0-9][0-9][0-9]*"

echo "Number of accepted connections:"
grep -c "Accepted password for" $1/SSH.log

echo "Daily hour based error counts: "
echo " Time                Errors"

i=0
j=0

for i in {0..2}
do
    for j in {0..9}
    do
        echo " $i$j:00 - $i$j:59   :   `grep "error" $1/SSH.log | grep \ $i$j:[0-9][0-9]* | wc -l`"
        if [ $i == 2 -a $j == 3 ]
        then
            break
        fi
    done
done
