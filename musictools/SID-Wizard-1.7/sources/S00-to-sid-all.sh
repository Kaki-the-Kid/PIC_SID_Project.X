#linux bash-script for converting all .S00 files in a directory to .sid

for f in *.S00 ; do SWMconvert $f ; done ;
