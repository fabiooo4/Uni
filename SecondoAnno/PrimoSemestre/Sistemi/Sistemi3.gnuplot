set table "Sistemi3.table"; set format "%.5f"
set format "%.7e";; set table $meta; set dummy t; set logscale x 10; set xrange [0.001*1:10*1]; set samples 200; plot  0+0-(-20*log10(sqrt((-0.5)**(2) + (t - (0))**(2))))+(-20*log10(sqrt((0)**(2) + (t - (0))**(2))))+(20*log10(abs(2))); set table "Sistemi3.table"; plot "$meta" using ($1/(1)):($2); 
