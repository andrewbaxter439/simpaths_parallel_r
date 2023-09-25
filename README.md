# Scripts to run `SimPaths` and process the results in parallel 

## Usage
Run in your terminal to copy the code to your machine

```bash
git clone git@github.com:MRC-CSO-SPHSU/simpaths_parallel.git
```

Copy `simpaths.jar` to `simpaths_parallel` and run the following:

```bash
cd simpaths_parallel
chmod +x ./do_full_run.sh
```

Typical use would be 
```bash
./do_full_run.sh -n 20 -p 150000 -s 2017 -e 2023 -g false
```

or 

```bash
./do_full_run.sh --batch_size=20 --population_size=150000 --start_year=2017 --end_year=2023 --gui=false
```

## Trailing commas
There is an additional step to clean the ouput data and prepare it to the next stage. 
Currently, `SimPaths` leaves trailing commas at the end of all lines in `*.csv` files which leads to an extra empty column during file reading.
To avoid this we run an extra script right after the simulation to remove aforementioned commas from the files.
This takes some extra time and relatively expensive in terms of computational resources but leads to correcly formatted data.
