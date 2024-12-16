set table "Sistemi33.table"; set format "%.5f"
set format "%.7e";; set table $meta; set dummy t; set logscale x 10; set xrange [1*0.01:100*1]; set samples 200; plot  0+((0  > 0 ? (0 > 0 ? ((-atan2((t - (0)),-(0 )))-(floor((-atan2((t - (0)),-(0 )))/(2*pi))*(2*pi))) : (-atan2((t - (0)),-(0 )))) : (-atan2((t - (0)),-(0 ))))*180/pi); set table "Sistemi33.table"; plot "$meta" using ($1/(1)):($2); 
