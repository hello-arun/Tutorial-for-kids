# VASP-Tutorial

Some commonly used VASP scripts

## Basic Strucuture

Any vasp run need following files

| File Name | Description |
| ---: | :--- |
| POSCAR | Crystal stucture file for VASP |
| POTCAR | PseudoPotential file |
| KPOINTS | K-Mesh grid file optinal but it is better to provide it |
| INCAR | VASP parameter scripts |
| OPTCELL | This file is optional but it useful during ionic relaxation |


## Keywords

Most important keywords to search for in VASP `OUTCAR` file.

|Keyword|Description|
|---:|:---|
|NIONS|Total no of atoms|
|TOTEN|Total energy|
|NKPTS|Total no of K-Points|
|reached req accuracy | To check convergence | 

## Errors

Some common errors 

```
internal error in subroutine SGRCON: Found some non-integer element in rotation matrix
```

limiting digits in the poscar file can help in this case

## Useful scripts

### To merge XDATCAR
```bash
files="XDATCAR-1 XDATCAR"
outFile="XDATCAR-final"
num=0
rm $outFile
for file in $files; do 
    awk -v num="$num" '/Direct config/{$3=$3+num}{print}' $file >> $outFile
    count=$(grep "Direct config" $file  | tail -1 | awk '{print $3}')
    num=$((num+count))
done
```
