# Useful one-line commands for bash

## Gnuplot

*Note: if using on Archie, first load module gnuplot*

- Gnuplot plotting from terminal:
```
  gnuplot -p -e "plot 'filename' u 1:2"
```

- Plot with pipe:
  ```
  awk '/remaining/{print $2,  $9}' D2.out | gnuplot -p -e "plot '-'" 
  ```
  - (plots remaining time vs. Timestep of Namd output)  
    Generalised:
    ```
    awk '/pattern/{print $1,  $2}' filename | gnuplot -p -e "plot '-'" 
    ```
    - awk emulates grep here, $2, $9 – string separated by spaces ($0 is a full string)
    - gnuplot: -p : persist, -e : execute one command in "", plot '-' : plot from pipe (works on UNIX only)

- Quick statistics with Gnuplot:
  ```
  gnuplot -e "stats 'filename' u 2"
  ```
  2 refers to column 2 of the file, use this for example to calculate average number of hydrogen bonds from hbonds.dat

## Head & tail

- Print 1st ten lines: 
  ```
  head –n 10 filename
  ```
- Print everything except 1st 10 lines: 
  ```
  tail -n +11 filename
  ```
