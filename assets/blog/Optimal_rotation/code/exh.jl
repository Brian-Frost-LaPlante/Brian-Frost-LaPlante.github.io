# This file was generated, do not modify it. # hide
using Symbolics, LinearAlgebra, Latexify # hide
function hamprod(q,w) 	     	     # Hamilton product
	[q[1]*w[1]-q[2]*w[2]-q[3]*w[3]-q[4]*w[4]
	 q[1]*w[2]+q[2]*w[1]+q[3]*w[4]-q[4]*w[3]
	 q[1]*w[3]-q[2]*w[4]+q[3]*w[1]+q[4]*w[2]
	 q[1]*w[4]+q[2]*w[3]-q[3]*w[2]+q[4]*w[1]]
end

@variables  q_0 q_1 q_2 q_3 w_0 w_1 w_2 w_3 i j k
qw = hamprod([q_0 q_1 q_2 q_3],[w_0 w_1 w_2 w_3])
qw = latexify(qw[1]*1 + qw[2]*i + qw[3]*j + qw[4]*k)
@show(qw)# hide