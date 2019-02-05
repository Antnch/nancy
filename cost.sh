#!/bin/bash

cat ./*/*/*.log | grep "Estimated AWS cost:" | awk -F'$' '{print $2}' | awk '
  BEGIN {
    c = 0;
    sum = 0;
  }
  $1 ~ /^[0-9]*(\.[0-9]*)?$/ {
    a[c++] = $1;
    sum += $1;
  }
  END {
    ave = sum / c;
    if( (c % 2) == 1 ) {
      median = a[ int(c/2) ];
    } else {
      median = ( a[c/2] + a[c/2-1] ) / 2;
    }
    OFS="\t";
    print "Sum:"sum, "Count:"c, "Avg:"ave, "Median:"median, a[0], a[c-1];
  }
'