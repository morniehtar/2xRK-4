#! /usr/bin/gnuplot

set encoding iso_8859_1
set tmargin 1
set tics out
set nokey
set grid

set style line 1 lt rgb "#cd1200" lw 2 pt 3 ps 0.5 #Red, thick
set style line 2 lt rgb "#cd1200" lw 1.5 pt 3 ps 0.5 dt 2 #Red, thin, dashed
set style line 3 lt rgb "#048700" lw 2 pt 3 ps 0.5 #Green, thick
set style line 4 lt rgb "#048700" lw 1.5 pt 3 ps 0.5 dt 2 #Green, thin, dashed

plot "./output.dat" using 1:2 smooth csplines linestyle 1, \
"./output.dat" using 1:3 smooth csplines linestyle 2, \
"./output.dat" using 1:4 smooth csplines linestyle 3, \
"./output.dat" using 1:5 smooth csplines linestyle 4, \

pause mouse close

