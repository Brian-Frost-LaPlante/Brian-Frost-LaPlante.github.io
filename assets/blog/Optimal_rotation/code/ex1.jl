# This file was generated, do not modify it. # hide
using Symbolics, LinearAlgebra, Latexify # hide
function QuatMat(w) 	     	     # hide 
	[w[1] -w[2] -w[3] -w[4] # hide
	 w[2]  w[1] -w[4]  w[3] # hide
	 w[3]  w[4]  w[1] -w[2] # hide
	 w[4] -w[3]  w[2]  w[1]] # hide
end # hide

@variables  a_x a_y a_z b_x b_y b_z
AtB = latexify(transpose(QuatMat([0 a_x a_y a_z]))*QuatMat([0 b_x b_y b_z]))
@show(AtB) # hide