#!/bin/bash
for sf in fd gauss mp mv; do

for se in 0.005 0.010 0.015 0.020 0.025 0.030 \
0.035 0.040; do

cat > $sf.$se.in << EOF
&CONTROL
calculation = 'scf'
restart_mode = 'from_scratch'
pseudo_dir = '/home/sanskar/Pseudo/'
outdir = './output/'
prefix = 'graphene'
/
&SYSTEM
ibrav = 4
a = 2.465325374
c = 7.80
nat = 2
ntyp = 1
occupations = 'smearing'
smearing = '$sf'
degauss = $se
ecutwfc = 40
/
&ELECTRONS
mixing_beta = 0.7
conv_thr = 1.0D-6
/
ATOMIC_SPECIES
C 12.01017  C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS (crystal)
C  0.616653019   0.283346981   0.500000000
C  0.283346981   0.616653019   0.500000000
K_POINTS (automatic)
  10 10 1 0 0 0
EOF
  
mpirun -np 2 pw.x <$sf.$se.in> $sf.$se.out

awk -v var="$sf" -v se="$se" '/!/{printf "%-6s %1.3f %s\n", var, se, $5}' "$sf.$se.out" >> calc-smearing.dat

done
done
   
