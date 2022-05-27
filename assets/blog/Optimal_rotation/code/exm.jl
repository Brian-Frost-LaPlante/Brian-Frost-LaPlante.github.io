# This file was generated, do not modify it. # hide
using Symbolics, LinearAlgebra, Latexify # hide
function hamprod(q,w) 	     	     # hide
	[q[1]*w[1]-q[2]*w[2]-q[3]*w[3]-q[4]*w[4] # hide
	 q[1]*w[2]+q[2]*w[1]+q[3]*w[4]-q[4]*w[3] # hide
	 q[1]*w[3]-q[2]*w[4]+q[3]*w[1]+q[4]*w[2] # hide
	 q[1]*w[4]+q[2]*w[3]-q[3]*w[2]+q[4]*w[1]] # hide
end # hide

function QuatModSq(q) # quaternion modulus squared
	q[1]^2+q[2]^2+q[3]^2+q[4]^2
end

@variables  q_0 q_1 q_2 q_3 w_0 w_1 w_2 w_3
qwmodsq = QuatModSq(hamprod([q_0 q_1 q_2 q_3],[w_0 w_1 w_2 w_3]))
qmodwmodsq = QuatModSq([q_0 q_1 q_2 q_3])*QuatModSq([w_0 w_1 w_2 w_3])
qwmod = latexify(sqrt(expand(qwmodsq))) # hide
qmodwmod = latexify(sqrt(expand(qmodwmodsq))) # hide
equalitycheck = isequal(qmodwmod,qwmod)
@show(equalitycheck)