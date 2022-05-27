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

@variables  a b c d v_x v_y v_z

QMatMethod = Mat2Quat(QuatMat([a b c d])*QuatMat([0 v_x v_y v_z])*QuatMat([a -b -c -d]))
QMatMethodW = QMatMethod[2:4]
RMat = [1-2(c^2+d^2) 2*(b*c-d*a)   2*(b*d+c*a)
		2*(b*c+d*a)  1-2*(b^2+d^2) 2*(c*d-b*a)
		2*(b*d-c*a)  2*(c*d+b*a)   1-2*(b^2+c^2)]
RMatMethodW = RMat*[v_x;v_y;v_z]
@show(latexify(QMatMethodW)) # hide
@show(latexify(RMatMethodW)) # hide