# Benchmarks for Montgomery Multiplication

## MONTE_REDUCTION_SUB_KARATSUBA
```
median clock cycles:     12411.6 (1246328000.0*10^6)
mean clock cycles:         12441.5 (1249331808.0*10^6)

median wall-clock time: 51.930 ms
mean wall-clock time:   52.055 ms

maximum stack usage:      3584 b

median multiplications:   283544
mean multiplications:     283862.5
median squarings:         142412
mean squarings:           142492.3
median inversions:            56
mean inversions:              56.4
median square tests:          18
mean square tests:            18.3
```
---
```
loaded db: a15 (Apple A15)
now testing private 
csidh_private
  1668.46 ns 
fastest  1375.00 ns 
     0.00 ms 
fastest     0.00 ms 
 21526.00 instructions 
  5746.00 cycles 
     3.75 instructions/cycles 
now the key exchange 
csidh
 50888862.41 ns 
fastest 50294667.00 ns 
    50.89 ms 
fastest    50.29 ms 
 688798073.00 instructions 
 176239039.00 cycles 
     3.91 instructions/cycles
```
## MONTE_REDUCTION_SCHOOLBOOK
```
median clock cycles:     13835.8 (1389349000.0*10^6)
mean clock cycles:         13780.8 (1383820092.0*10^6)

median wall-clock time: 57.890 ms
mean wall-clock time:   57.659 ms

maximum stack usage:      3568 b

median multiplications:   283713
mean multiplications:     282634.4
median squarings:         141844
mean squarings:           142002.0
median inversions:            57
mean inversions:              56.4
median square tests:          18
mean square tests:            18.2
```
---
```
loaded db: a15 (Apple A15)
now testing private 
csidh_private
  1627.21 ns 
fastest  1333.00 ns 
     0.00 ms 
fastest     0.00 ms 
 21478.00 instructions 
  5596.00 cycles 
     3.84 instructions/cycles 
now the key exchange 
csidh
 46681269.66 ns 
fastest 45591542.00 ns 
    46.68 ms 
fastest    45.59 ms 
 596896128.00 instructions 
 159757133.00 cycles 
     3.74 instructions/cycles 
```

## MONTE_REDUCTION_KARATSUBA
```
median clock cycles:      9417.3 (945651000.0*10^6)
mean clock cycles:          9431.9 (947124772.0*10^6)

median wall-clock time: 39.402 ms
mean wall-clock time:   39.464 ms

maximum stack usage:      3792 b

median multiplications:   283758
mean multiplications:     282441.9
median squarings:         141453
mean squarings:           141592.5
median inversions:            56
mean inversions:              56.0
median square tests:          18
mean square tests:            18.1
```
---
```
loaded db: a15 (Apple A15)
now testing private 
csidh_private
  1331.43 ns 
fastest  1042.00 ns 
     0.00 ms 
fastest     0.00 ms 
 21492.00 instructions 
  5519.00 cycles 
     3.89 instructions/cycles 
now the key exchange 
csidh
 37395797.29 ns 
fastest 36723125.00 ns 
    37.40 ms 
fastest    36.72 ms 
 648965509.00 instructions 
 128611788.00 cycles 
     5.05 instructions/cycles 
```

## MONTE_MUL
```
median clock cycles:     13017.7 (1307197000.0*10^6)
mean clock cycles:         13024.0 (1307829224.0*10^6)

median wall-clock time: 54.467 ms
mean wall-clock time:   54.493 ms

maximum stack usage:      3008 b

median multiplications:   283572
mean multiplications:     283492.9
median squarings:         142621
mean squarings:           141932.4
median inversions:            56
mean inversions:              56.1
median square tests:          18
mean square tests:            18.1
```
---
```
loaded db: a15 (Apple A15)
now testing private 
csidh_private
  1230.28 ns 
fastest  1041.00 ns 
     0.00 ms 
fastest     0.00 ms 
 21528.00 instructions 
  5564.00 cycles 
     3.87 instructions/cycles 
now the key exchange 
csidh
 55353099.42 ns 
fastest 54505875.00 ns 
    55.35 ms 
fastest    54.51 ms 
 904849479.00 instructions 
 190994113.00 cycles 
     4.74 instructions/cycles
```