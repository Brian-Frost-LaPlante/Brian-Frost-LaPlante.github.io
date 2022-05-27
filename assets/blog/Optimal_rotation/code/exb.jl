# This file was generated, do not modify it. # hide
using Symbolics, LinearAlgebra, Latexify # hide
function QuatMat(w) 	     	     # hide 
	[w[1] -w[2] -w[3] -w[4] # hide
	 w[2]  w[1] -w[4]  w[3] # hide
	 w[3]  w[4]  w[1] -w[2] # hide
	 w[4] -w[3]  w[2]  w[1]] # hide
end # hide

@variables  x_1 x_2 x_3 v_1 v_2 v_3 SIGMA A DELTA SBesl SFrost

x = [x_1;x_2;x_3]
XMat = QuatMat([0;x])
VMatHat = [0   -v_1 -v_2 -v_3
		   v_1  0    v_3 -v_2
		   v_2 -v_3  0    v_1
		   v_3  v_2 -v_1  0]
SIGMA = v*transpose(x)
A = SIGMA - transpose(SIGMA)
DELTA = [A[2,3];A[3,1];A[1,2]]
SBesl = [tr(SIGMA) transpose(DELTA)
     DELTA SIGMA+transpose(SIGMA)-tr(SIGMA)*[1 0 0;0 1 0;0 0 1]]
SFrost = transpose(XMat)*VMatHat
@show latexify(SBesl)
@show latexify(SFrost)
@show isequal(SBesl,SFrost)