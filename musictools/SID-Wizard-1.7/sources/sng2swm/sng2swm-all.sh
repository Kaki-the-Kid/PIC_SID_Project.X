#linux bash-script for converting all .sng files in a directory to .swm

for f in *.sng; 
do 
 sng2swm $f ${f%.*}.swm; 
done 
