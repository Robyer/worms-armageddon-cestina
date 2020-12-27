@ECHO OFF

mkdir "output"

cd ../strings
copy "Czech.txt" "../tools/Czech.txt"

cd ../tools
sfk replace Czech.txt -bylist na_zastupne_znaky.txt -yes

move "Czech.txt" "../installer/output/Czech.txt"
