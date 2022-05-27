# This file was generated, do not modify it. # hide
using Symbolics, LinearAlgebra, Latexify # hide
function QuatMat(w) 	   # hide 
	[w[1] -w[2] -w[3] -w[4] # hide
	 w[2]  w[1] -w[4]  w[3] # hide
	 w[3]  w[4]  w[1] -w[2] # hide
	 w[4] -w[3]  w[2]  w[1]] # hide
end # hide
function hamprod(q,w) 	     	     # hide
	[q[1]*w[1]-q[2]*w[2]-q[3]*w[3]-q[4]*w[4] # hide
	 q[1]*w[2]+q[2]*w[1]+q[3]*w[4]-q[4]*w[3] # hide
	 q[1]*w[3]-q[2]*w[4]+q[3]*w[1]+q[4]*w[2] # hide
	 q[1]*w[4]+q[2]*w[3]-q[3]*w[2]+q[4]*w[1]] # hide
end # hide

@variables  a_x a_y a_z b_x b_y b_z q_0 q_1 q_2 q_3 LHS RHS

q = [q_0 q_1 q_2 q_3]
qconj = [q_0 -q_1 -q_2 -q_3]
a = [0 a_x a_y a_z]
b = [0 b_x b_y b_z]

LHS = dot(hamprod(hamprod(q,a),qconj),b)
RHS = dot(hamprod(q,a),hamprod(b,q))
equalitycheck = isequal(LHS,RHS)

@show(latexify(LHS)) # hide
@show(latexify(RHS)) # hide
@show(equalitycheck) # hide