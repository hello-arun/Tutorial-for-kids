This is an example in which Polarisation and the Born effective charge for Pb in perovskite
PbTiO3 is calculated.

1) make a self-consistent calculation for a cubic structure of PbTiO3 in
   which the Pb atom has been displaced a small distance 0.01*a0 in the z
   axis (a0 is the lattice constant, 7.3699 bohr). 
   (input=`INCAR-scf.pw`, output=`OUTCAR-scf.pw`)

2) make a non-self-consistent calculation to compute the polarization
   (lberry=.true. in the input file `INCAR-nscf.pw`). In the ouput file `OUTCAR-nscf.pw`
   we find that the polarization (P) multiplied by the volume of the unit
   cell (Omega) is:

        Omega * P = 0.2884752 e.bohr

   while the distance the Pb atom has been displaced from the perfect cubic cell
   structure is

        r - r0 = 0.01 * 7.3699 bohr = 0.073699 bohr.

   Given that the Born effective charge is defined as

                    dP
        z* = Omega ----
                    dr

   we can use a finite differences approximation to get

              0.2884752 e.bohr
        z* = ------------------ = 3.91 e
                0.073699 bohr

   in good agreement with published results. For example, in Zhong, King-Smith
   and Vanderbilt, PRL 72, 3618 (1994) the value found is 3.90 e.