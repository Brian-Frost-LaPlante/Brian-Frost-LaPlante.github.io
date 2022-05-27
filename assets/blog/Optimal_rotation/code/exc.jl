# This file was generated, do not modify it. # hide
using Symbolics, LinearAlgebra, Latexify # hide
function cprod(z,w) 	     	     # Complex product
	[(z[1]*w[1]-z[2]*w[2]) (z[1]*w[2]+z[2]*w[1])]
end
function polar(z) 	     	     	 # polar form from rectangular form
	[sqrt(z[1]^2 + z[2]^2) atan(z[2],z[1])]
end

@variables  z_r z_i w_r w_i
zwpolar = latexify(polar(cprod([z_r z_i],[w_r w_i])))
pz = polar([z_r z_i])
pw = polar([w_r w_i])
zwcheck = latexify([pz[1]*pw[1] pz[2]+pw[2]])
@show(zwcheck)# hide
@show(zwpolar)# hide