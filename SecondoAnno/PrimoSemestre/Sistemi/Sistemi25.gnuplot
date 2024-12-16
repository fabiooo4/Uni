set table "Sistemi25.table"; set format "%.5f"
set format "%.7e";; set table $meta; set dummy t; set logscale x 10; set xrange [1*0.01:100*1]; set samples 200; plot  0+(t < sqrt((0 )**(2) + (0)**(2)) ? -20*log10(sqrt((0 )**(2) + (0)**(2))) : -20*log10(t) ); set table "Sistemi25.table"; plot "$meta" using ($1/(1)):($2); 
