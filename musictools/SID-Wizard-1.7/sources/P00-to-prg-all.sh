#linux bash-script for converting all .P00 files in a directory to .prg

for f in *.P00 ; do SWMconvert $f ${f%.*}.prg ; done ;
