#!/bin/bash

quantity="eamp"           #the variable in the scf file to change valeus you can name it random  to calculate without any change
values="0.0000 0.0020 0.0040 0.0060 0.0080 0.0100 0.0120 0.0140 0.0160"      # when you want to calculate without any change just put any single value here
np=4 # No of Processors
plot_num=0

# Some key value pair do not change it
# If you are using any value outside these two please specify the tag below
plot_num_tags[0]="chden"      ## 0 means chden
plot_num_tags[11]="potential" ## 11 means potential 
############################
tag=${plot_num_tags[${plot_num}]}
echo $tag
scriptDIR=$PWD
baseDIR=`readlink -f ../../`
ppDIR=$baseDIR/postProcessing
srcDIR=$baseDIR/$quantity/
outDIR=$ppDIR/$quantity/avg/$tag/

echo "baseDIR : $baseDIR"
echo "scriptDIR : $scriptDIR"
echo "ppDIR     : $ppDIR"
echo "srcDIR    : $srcDIR"
echo "outDIR    : $outDIR"

echo "----> START <----" >> $scriptDIR/jobs.sh 
echo `date` >> $scriptDIR/jobs.sh 


cd $srcDIR
mkdir -p $outDIR
for value in $values
do
echo $value >> $outDIR/list.sh

#awk -v value="$value" -v quantity="$quantity" '$0 ~ quantity {$3 = value} {print}' ./scf.in > ./$quantity/$value/scf.in



cat > $srcDIR/$value/pp.avg_$tag.in <<EOF
&INPUTPP
outdir='./out',
plot_num = ${plot_num}
filplot = "avg_$tag"
/
EOF

cat > $srcDIR/$value/avg.$tag.in <<EOF
1
avg_$tag
1.D0
150
3
1.000000
EOF

cat > $srcDIR/$value/runAvg_$tag.sh << EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=$np
#SBATCH --partition=batch
#SBATCH -J Avg_Pot
#SBATCH -o Job_Avg_$tag.out
#SBATCH -e Job_Avg_$tag.err
#SBATCH --time=0:15:00

#Loading Modules:
module load quantumespresso/6.6

# mpirun -np \$(nproc) pw.x <scf.in> scf.out

pp.x <pp.avg_$tag.in> pp.avg_$tag.out
average.x <avg.$tag.in> avg.$tag.out
(awk '/Fermi energy/ || /highest occupied/{ print "#"\$0 }' scf.out  && cat avg.dat ) > temp
mv temp avg_$tag.dat
rm avg.dat
cp avg_$tag.dat $outDIR/$value.dat
EOF

cd $srcDIR/$value
echo "$quantity $value" >> $scriptDIR/jobs.sh 
sbatch runAvg_$tag.sh >> $scriptDIR/jobs.sh
echo " " >> $scriptDIR/jobs.sh 
done
echo "# ------> <------" >> $outDIR/list.sh
echo "----> End <----" >> $scriptDIR/jobs.sh 