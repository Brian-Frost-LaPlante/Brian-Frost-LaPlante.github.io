+++
title = "Quaternions and Volume Registration -- A Comprehensive Approach"
date = Date(2022, 05, 24)
hascode = false
rss = "quaternion"
tags = ["research"]
hasmath = true
mintoclevel=2
maxtoclevel=2
descr = """
@@row
@@container
~~~
<img class="left" style="width:30%;" src="/assets/Cayley Q8 quaternion multiplication graph.svg">
~~~
Suppose you have two point-sets in 3-D space, related by a rotation and translation -- in the presence of some noise, how can you determine this relationship given only the point-sets? This problem is one of *registration*, i.e. determining which points in each point-set correspond to one another. *Quaternions* are very useful for representing 3-D rotation, but their use in solving this registration problem is poorly, and sometimes **erroneously**  documented. In this post, I wish to provide a more comprehensive view of how quaternions function, and their role in volume registration, as well as correct one publication's major errors. Image: The product relationships for the quaternion basis elements, 1, i, j and k.
@@
@@

"""
+++

# {{title}}
@@row
@@container
~~~
<img class="left" style="width:30%;" src="/assets/Cayley Q8 quaternion multiplication graph.svg">
~~~
Suppose you have two point-sets in 3-D space, related by a rotation and translation -- in the presence of some noise, how can you determine this relationship given only the point-sets? This problem is one of *registration*, i.e. determining which points in each point-set correspond to one another. *Quaternions* are very useful for representing 3-D rotation, but their use in solving this registration problem is poorly, and sometimes **erroneously**  documented. In this post, I wish to provide a more comprehensive view of how quaternions function, and their role in volume registration, as well as correct one publication's major errors. Image: The product relationships for the quaternion basis elements, 1, i, j and k.
@@
@@

First I will describe the motivation for solving the 3D registration problem. Then, I will derive an algorithm for computing the optimal registration. Along the way, I will provide a comprehensive review of the algebra of quaternions, with special attention paid to *versors* used to define 3D rotations. I will then show some promising results on synthetic and *in vivo* volumes. Lastly, I will describe the many errors of the presentation of the algorithm derivation in Dolezal et al, 2020. Throughout this post, I will make use of Julia's Symbolics.jl computer algebra package.

## Motivation

Consider the following scenario -- you and your friend see your cat doing something adorable, and take picture of it at the same time. Now, looking at the pictures, could you tell me where the two cameras were positioned? In three dimensions, instead of images, these would be *volumes*, or 3D point-sets.

As I've discussed before on this blog, my research focuses on using OCT to reconstruct displacement measurements. This is done via measuring a single structure at multiple known angles. In practice, this is done by measuring vibrations within a large 3-D *volume* of positions, rotating the preparation, and then repeating the measurements at this new angle. To reconstruct the motions, we then must ask -- how are these two volumes related? Which positions correspond to one-another between volumes?

## Formulation in the special case of known correspondence

In OCT, as in many modalities, the angle greatly impacts the "lighting" of the image. That is, structures which are extremely bright at one orientation may appear dimmer at other orientations, as the object may be further from the focal point of the lens or obscured by other structures along the way. As a result, we choose to work with *binary* volumes, which are thresholded so that sufficiently bright pixels are represented by 1s and dimmer pixels are represented by 0s. For the remainder of this section, we follow the development of [Horn et al](http://graphics.stanford.edu/~smr/ICP/comparison/horn-hilden-orientation-josa88.pdf) closely.

Let's call the first volume point-set $X$, which we will represent as an $3 \times N_X$ matrix whose columns represent the $N_X$ coordinates at which there is sufficiently bright signal (a 1) in the first volume. Similarly, let $V$ be the second such set, size $3 \times N_V$. In practice, $N_X$ and $N_V$ will almost always be different, and we do not know how the points relate to one another. However, we can formulate the special case of the problem where we *do* know this relationship, and $N_X = N_V = N$.

In this case, we know that each point in $V$, $v_n$, is a rotated and translated version of the corresponding point in $X$, $x_n$. That is, we can write
\begin{equation}
	R(x_n) + t = v_n, \: n=1,2\ldots,N.
\end{equation}
The unknowns here are $R$ and $t$. $R$ is a rotation in three-dimensional space, which we are careful to write as a function rather than a matrix. This is a unitary linear operator, which has a matrix representation, but as we will show soon can also be represented by quaternions. The vector $t$ represents a translation.

In the presence of noise, this becomes an optimization problem, where we look to find $R$ and $t$ that minimize the mean square error:
\begin{align}
\epsilon_n(R,t) = &v_{n} - R(x_n)-t, \\
\epsilon(R,t) &= \sum_{n=1}^{N} ||\epsilon_n||^2.
\end{align}

## Solution for the translation vector

We are maximizing this real expression in two variables, $t$ and $R$. It is preferable to split this into *two* optimization problems, each in one variable. To do so, we first shift both $X$ and $V$ so that they are centered at their respective centers of mass. The centers of mass are

\begin{align}
\mu_X &= \frac{1}{N}\sum_{n=1}^N x_{n},\\
\mu_V &= \frac{1}{N}\sum_{n=1}^N v_{n},
\end{align}

and the new shifted coordinates are

\begin{align}
x_n' &= x_n-\mu_X,\\
v_n' &= v_n-\mu_V. 
\end{align}

Writing the error terms using these coordinates gives  
\begin{align}
\epsilon_n &= v_n'+\mu_V - R(x_n' + \mu_X) -t \\
&= v_n' - R(x_n') - (t+R(\mu_X)-\mu_V)\\
&= v_n' - R(x_n') - t',
\end{align}
where $t' = t+R(\mu_X)-\mu_V$ is independent of $n$. We have used the fact that $R$ is a linear operator. Now we can expand the squared error terms in the standard manner:
\begin{equation}
\epsilon = \sum_{n=1}^N ||v_n'-R(x_n')||^2 + N||t'||^2  - 2t'\sum_{n=0}^N (v_n'-R(x_n'))
\end{equation}
where we have made use of the fact that $t'$ is $n$-independent in the second and third term. First, we will tackle the third term: 
\begin{align}
\sum_{n=0}^N (v_n'-R(x_n')) &= \sum_{n=0}^N (v_n-\mu_V) - R\bigg(\sum_{n=0}^N(x_n-\mu_X)\bigg)\\
&= N\mu_V-N\mu_V - R(N\mu_X -N\mu_X)\\
&=0,
\end{align}
where we have employed the definitions of the centers of mass and primed coordinates, as well as $R(0)=0$. This means our error formula now has only two terms:
\begin{equation}
\epsilon = \sum_{n=1}^N ||v_n'-R(x_n')||^2 + N||t'||^2
\end{equation}
The first term is entirely independent of $t'$ (and $t$). The second term is minimized when $t' = 0$, or 
\begin{equation}
t = \mu_V - R(\mu_X).
\end{equation}
Conceptually, this formula is intuitive -- the optimal translation is the one that makes the centers of mass coincide! Note that while this formula depends on $R$, this form of $t'$ will minimize the last term of $\epsilon$ *no matter what $R$ is*. Moreover, it does not result in a further restriction on $R$. That is, the terms can safely be handled as two separate optimization problems (one of which we have now solved).

## Handling the rotation operator

To determine the optimal $R$, we look to the first term in our expression for $\epsilon$. That is, we want to minimize 
\begin{equation}
E(R) = \sum_{n=1}^N ||v_n'-R(x_n')||^2.
\label{roterror}
\end{equation}

Now if we were to treat $R$ as a unitary $3\times 3$ matrix, we would continue to procede down the path seen developed in Horn et al. The result is that if you define
\begin{equation}
H = \sum_{n=1}^N v_n' x_n'^T,
\end{equation}
the cross-covariance matrix of $X$ and $V$, then the optimal rotation is
\begin{equation}
R = H(H^T H)^{-1/2}.
\end{equation}
This can also be computed using the spectral value decomposition for $H$ (see the [Kabsch algorithm](https://en.wikipedia.org/wiki/Kabsch_algorithm)).

While this solution is sufficient, computing a matrix inverse square root or a spectral value decomposition is not ideal. Moreover, $3\times 3$ matrices are only the *second*-most elegant way to describe 3-D rotations. Let's put a pin in Equation 10 for now, and we'll derive a second way to minimize it.


## Representing rotations using **numbers**-- 2-D foundations

To tackle the problem above -- minimizing $E(R)$ -- with quaternions, we first need to learn what a quaternion even *is*. Let's start with the complex numbers, $a+bi\in \mathbb{C}$ where $a,b\in \mathbb{R}$ and $i^2 = -1$. This may seem elementary, but I believe this derivation is necessary to motivate the quaternions. Feel free to skip this if you feel comfortable already. 
Under this definition, the complex numbers form a **field**, i.e. a set of numbers with 

**a)** Associative and commutative addition and multiplication operations

**b)** Distributivity of multiplication over addition ($x(y+z) = xy + xz$)

**c)** A unique additive identity element ($0$)

**d)** A unique multiplicative identity element ($1$)

**e)** Unique additive and multiplicative inverses for every element (1/x and -x, save 0, which has no multiplicative inverse). 


It is easy to see that $\mathbb{C}$ forms a field. We can represent a complex number as an ordered pair of two real numbers $(a,b) = a+bi$, suggesting a representation as a two-vector in Cartesian space. This is called the rectangular form. In this form, addition corresponds to vector addition. What does multiplication correspond to? 

To see this, we need a *third* way to think about complex numbers -- polar form. We can write any two-vector in Cartesian space both as $z = (a,b)$, its rectangular components, or as $z = (r,\theta)$, its magnitude and phase in the standard 2-D sense, $r = ||z||$, $\theta = \text{arg}(z)$.

The product of two complex numbers $z_1=(a,b)$ and $z_2(x,y)$ in rectangular form is $z_1z_2=(ax-by,ay+bx)$. It can be quickly shown that in polar coordinates, this is precisely $z_1z_2 = (r_1r_2,\theta_1 + \theta_2)$. That is, multiplying two complex numbers 1) multiplies their magnitudes and 2) adds their phases. See the CAS code below, where $\texttt{zwcheck}$ is the product performed in this way, and $\texttt{zwpolar}$ is the product performed via standard complex product. They are equal by simple expansion: 

```julia:./code/exc
import Pkg; Pkg.add("Symbolics") #hide
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
```
\textoutput{./code/exc}

Now let's consider a new set, $\mathbb{C}_1 = \{z\in\mathbb{C} \text{ s.t. } ||z||=1\}$ -- the set of unit-magnitude complex numbers. This is the complex unit circle *group* -- it is not a field, because if you add two numbers in the set you get a number outside the set. Multiplication of any complex number by a vector $z_1\in\mathbb{C}_1$ corresponds to a *rotation* by the argument of $z_1$. Consider also a mapping $\phi:\mathbb{R}^2 \rightarrow \mathbb{C}$ defined by 
\begin{equation}
\phi((x,y)) = x + yi, \; (x,y)\in \mathbb{R}^2.
\end{equation}
This mapping $\phi$ is injective and surjective, so it has an inverse $\phi^{-1}:\mathbb{C}\rightarrow\mathbb{R}^2$ which maps back the complex pairs to their corresponding real vectors. The mapping is also magnitude- and phase-preserving, as magnitude and phase are identically defined for real vectors and complex numbers in rectangular form.

It is often desirable to rotate a 2-D vector, and this process is usually described by left-multiplication of the column vector by a unitary 2-D matrix, $U\in SO(2)$, the special orthogonal group. However, this matrix has four elements, which is a bit clunky and inelegant. We can see now that this rotation can just as well be described via multiplication by a unit complex vector. Let $w$ be real vector $v$ rotated counter-clockwise by $\theta$. Let $z_\theta\in\mathbb{C}_1$ be the unique unit complex number with argument $\theta$. Then 
\begin{equation}
w = \phi^{-1}(z_\theta\phi(v)).
\end{equation}
This elegant formulation allows each 2-D rotation to be uniquely described by a single unit complex number, as opposed to a $2\times 2$ matrix -- a two-parameter rotation, rather than a four-parameter rotation. 

## Enter Quaternions

Complex numbers are nice in 2-D registration problems as they allow us to rotate coordinate vectors in a compact and elegant manner, but unfortunately they do not work in our 3-D world. Our goal is instead to derive a set of numbers where multiplication corresponds to 3-D rotation under an invertible mapping, ideally more compact than the unitary matrices in $SO(3)$.

In my college complex analysis and modern algebra courses, I was introduced to the idea of *quaternions*, a four-dimensional extension of the complex numbers which is used to describe rotations in $\mathbb{R}^3$. In extending to higher dimensions, computations become complicated and you *lose multiplicative commutativity*. I tossed aside the concept as a pure-mathematics pipe dream, but now, five years later, I am reaping what I've sown.

@@row
@@container
~~~
<img class="right" style="width:50%;" src="/assets/Quaternion Figures/hamiltonbrick.jpg">
~~~
@@
@@

The quaternions, $\mathbb{H}$ (for Hamilton, their noble father), are defined as the four-dimensional set of numbers $a + b\mathbf{i} + c\mathbf{j} + d\mathbf{k}$, where $a,b,c,d\in\mathbb{R}$ and $\mathbf{i}$, $\mathbf{j}$ and $\mathbf{k}$ are called the *basic quaternions*. The basic quaternions satisfy the following relationship:
\begin{equation}
\mathbf{i}^2 = \mathbf{j}^2 = \mathbf{k}^2 = \mathbf{ijk} = -1.
\end{equation}



That is, each of the basic quaternions is, in a sense, an imaginary unit. How they differ from one another lies in the third term -- recalling that quaternions are *not commutative* under multiplication, this set of equalities actually gives **16 identities** for the products of quaternions. For example, $\mathbf{ij} = -\mathbf{k}$ while $\mathbf{ji} = \mathbf{k}$. 
It is very impotant to note that the quaternions are **not anticommutative** -- there is no quick way to determine $q_2q_1$ from $q_1q_2$ for two quaternions. You could think of this as analogous to matrix multiplications, which are similar in this regard.

We can add two quaternions componentwise, meaning quaternion addition is commutative and associative, has an identity element (0) and has additive inverses for every element (by negating every component). This means that $\mathbb{H}$ is an *abelian group* (or commutative group) under component-wise addition. 
@@row
@@container
~~~
<img class="left" style="width:18%;" src="/assets/Quaternion Figures/quattable.png">
~~~
@@
@@


We can multiply two quaternions by distributing the components, taking into account order of the basic quaternion products. This is called the Hamilton product. Note that the real coefficients are still commutative with the quaternions. Representing the real, $\mathbf{i}$, $\mathbf{j}$ and $\mathbf{k}$ components as components in a vector, we can write: 
```julia:./code/exh
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
```
\textoutput{./code/exh}


Where $r$ is just $1$. It can be seen from the expression above that this product is associative and distributes over addition, but is not commutative. This means $\mathbb{H}$ is not a field. However, we will show that you can *divide* quaternions, so that all non-zero quaternions have unique multiplicative inverses. This makes $\mathbb{H}$ a *division ring*, which is similar to a field (described above) barring only the commutativity of multiplication. 


We will now develop quaternion division. It is conventional to write quaternions as column vectors consisting of their four real coefficients,

\begin{equation}
q = a + b\mathbf{i} + c\mathbf{j} + d\mathbf{k} = \begin{pmatrix}a\\b\\c\\d\end{pmatrix}.
\end{equation}

For such a $q$, we define its *conjugate*, $q^*$ as follows:
\begin{equation}
q^* = \begin{pmatrix}a\\-b\\-c\\-d\end{pmatrix}. 
\end{equation}
This is analogous to the complex conjugate. We define the *norm* or *modulus* of a quaternion in the same was as that of a four-vector: 

\begin{equation}
||q||^2 = a^2 + b^2 + c^2 + d^2 = qq^*.
\end{equation}
Showing the second equality is not too difficult from the definition of quaternion product. One clear upshot of this is that the modulus of a scalar (real) quaternion is $||a||=|a|$. The modulus is multiplicative, which means that if $q_1$ and $q_2$ are two quaternions, then
\begin{equation}
||q_1 q_2|| = ||q_1||\;||q_2||.
\end{equation}
Showing this is not challenging with a computer algebra system, but is a pain by hand. We show this for the square modulus which is simpler to visualize:

```julia:./code/exm
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
```
\show{./code/exm}

Of course, as the moduli are real numbers, this commutes. Now we define the unit sphere group in quaternion space, more commonly called the *versors*. I will denote them as $\mathbb{V}$, defined as 
\begin{equation}
\mathbb{V} = \{q\in\mathbb{H}\text{ s.t. } ||q|| = 1\}.
\end{equation}
The versors form a group under multiplication, by the multiplicativity of the modulus. It can be shown that the product between a versor and its conjugate is $1$ -- the multiplicative identity! That is, if $q_0$ is a versor, then

\begin{equation}
q_0 q_0^* = 1.
\end{equation}

This allows us to define versor division, i.e. for versor $q_0$, its inverse is $q^*$. We will now use this to define quaternion division. We can write any non-zero quaternion $q$ as the product of its norm and a versor,
\begin{equation}
q = ||q|| \frac{q}{||q||}.
\end{equation}
The versor on the right has an inverse which is its own conjugate, and scalar multiplication can be absorbed into the conjugate, so we can write

\begin{align}
q \frac{q^*}{||q||^2} &= \frac{||q||}{||q||}\frac{q}{||q||}\frac{q^*}{||q||} \\
&= \frac{q}{||q||}\bigg(\frac{q}{||q||}\bigg)^* \\
&= 1.
\end{align}

This defines the quaternion multiplicative inverse and thereby quaternion division:

\begin{equation}
q^{-1} = \frac{q^*}{||q||^2}.
\end{equation}

Finally, quaternions can be mapped to matrices in an incredible way! Let $M:\mathbb{H}\rightarrow \mathbb{R}^{4\times 4}$ be defined by

\begin{align}
&M(q) = Q = \begin{pmatrix} a&-b&-c&-d\\ b&a& -d&c \\ c&d&a&-b\\d&-c&b&a\end{pmatrix}, \\
&M^{-1}(Q) = q = \begin{pmatrix} Q_{1,1}\\Q_{2,1}\\Q_{3,1}\\Q_{4,1} \end{pmatrix}.
\end{align}

We use capital letters to denote corresponding matrices for our quaternions. This formalism is *incredibly* important for our development, so be sure you follow along. This mapping is an *isomorphism*, which means that $M$ is invertible and for any quaternions $q_1$ and $q_2$, we have $M(q_1 q_2) = M(q_1)M(q_2),$ $M(q_1 +q_2) = M(q_1) + M(q_2)$. 

Another incredible feature of this representation is that it allows us to treat quaternions as real column vectors. Consider the boring mapping $G:\mathbb{H}\rightarrow\mathbb{R}^4$ defined as
\begin{equation}
G\begin{pmatrix}a\\b\\c\\d\end{pmatrix} = \begin{pmatrix}a\\b\\c\\d\end{pmatrix}.
\end{equation}
It is clear that the inverse of $G$ will look exactly the same, but will map from real vectors to quaternions. One can think of it as "reading the quaternion as a vector." Then I can write for any two quaternions
\begin{align}
q_1q_2 = G^{-1}(M(q_1)G(q_2)).
\end{align}
That is, I map the first quaternion to a real matrix and the second to a vector. Their product is a vector, which I can read as a quaternion through the inverse mapping of $G$ (which *looks* like an identity mapping). An abuse of notation would be to write this as:
\begin{align}
q_1 q_2 = Q_1q_2,
\end{align}
where we are reading $q_2$ as a real vector and the output of the right-hand side as a quaternion. That is, the $G$ and $G^{-1}$ mappings are to be inferred.

Below, we show that the Hamming product, the product through multiplying quaternion matrices, and the product of a quaternion matrix and a quaternion column vector are **the same**:

```julia:./code/ex1
using Symbolics, LinearAlgebra, Latexify # hide
function QuatMat(w) 	     	     # Create matrix form of a quaternion
	[w[1] -w[2] -w[3] -w[4]
	 w[2]  w[1] -w[4]  w[3]
	 w[3]  w[4]  w[1] -w[2]
	 w[4] -w[3]  w[2]  w[1]]
end
function Mat2Quat(A) 	     	     # Grab quaternion from matrix form
	[A[1,1] A[2,1] A[3,1] A[4,1]]
end
function hamprod(q,w) 	     	     # hide
	[q[1]*w[1]-q[2]*w[2]-q[3]*w[3]-q[4]*w[4] # hide
	 q[1]*w[2]+q[2]*w[1]+q[3]*w[4]-q[4]*w[3] # hide
	 q[1]*w[3]-q[2]*w[4]+q[3]*w[1]+q[4]*w[2] # hide
	 q[1]*w[4]+q[2]*w[3]-q[3]*w[2]+q[4]*w[1]] # hide
end # hide

@variables  q_0 q_1 q_2 q_3 w_0 w_1 w_2 w_3

MatProdMethod = Mat2Quat(QuatMat([q_0 q_1 q_2 q_3])*QuatMat([w_0 w_1 w_2 w_3]))
HamProdMethod = hamprod([q_0 q_1 q_2 q_3],[w_0 w_1 w_2 w_3])
ColProdMethod = QuatMat([q_0 q_1 q_2 q_3])*[w_0;w_1;w_2;w_3]
@show(latexify(transpose(MatProdMethod))) # hide
@show(latexify(HamProdMethod)) # hide
@show(latexify(ColProdMethod)) # hide
```
\textoutput{./code/ex1}




We also have $M(q^*) = M(q)^T$ (this is clear from the definition. This allows us to turn the quaternion multiplication into real matrix multiplication, which allows us to use known theorems from linear algebra. 


## Quaternion representations of 3-D rotations

Finally, we will use quaternions to represent 3-D rotations, analagously to how we used complex numbers to describe 2-D rotations. First, lets define a mapping $T:\mathbb{R}^3 \rightarrow \mathbb{H}$ by
\begin{equation}
T\begin{pmatrix}x\\y\\z\end{pmatrix} = \begin{pmatrix}0\\x\\y\\z\end{pmatrix}.
\end{equation}
Let $u = (u_x\;u_y\;u_z)^T$ be the axis (as a unit vector) about which we would like to rotate vector $v = (v_x,v_y,v_z)^T$, and let $\theta$ be the angle by which we would like to rotate $v$. The matrix $R$ in $SO(3)$ that decribes this rotation is
\begin{equation}
R = \begin{pmatrix} \cos\theta + u_x^2(1-\cos\theta)&u_xu_y(1-\cos\theta)-u_z\sin\theta&u_xu_z(1-\cos\theta)+u_y\sin\theta \\ u_yu_x(1-\cos\theta)+u_z\sin\theta & \cos\theta+u_y^2(1-\cos\theta) & u_yu_z(1-\cos\theta)-u_x\sin\theta \\ u_zu_x(1-\cos\theta)-u_y\sin\theta &u_zu_y(1-\cos\theta) + u_x\sin\theta & \cos\theta + u_z^2(1-\cos\theta)\end{pmatrix}
\end{equation}

This alone should make it clear that the rotation matrix is an ugly animal to work with. Instead, we would like to work with *quaternions*. A rotation is a unitary linear operation, so it cannot change the norm of the input. As such, we will specifically work with versors (quaternions with unit magnitude).


We can write the vector $w$ which is $v$  *conjugated by* versor $q$ as 
\begin{equation}
\begin{pmatrix}0\\w\end{pmatrix} = q\begin{pmatrix}0\\v\end{pmatrix}q^*.
\end{equation}

One can show that for $q=a+b\mathbf{i} + c \mathbf{j} + d\mathbf{k}$, this expression can equivalently be written as 

\begin{equation}
w = Rv = \begin{pmatrix}1-2(c^2 + d^2)&2(bc-da)&2(bd+ca) \\ 2(bc+da)&1-2(b^2+d^2)&2(cd-ba) \\ 2(bd-ca)&2(cd+ba)&1-2(b^2+c^2)\end{pmatrix}v.
\end{equation}

Check out the expressions below -- they are equal if you insist $q$ is unit norm:

```julia:./code/exR
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
```
\textoutput{./code/exR}

Letting 
\begin{equation}
q = \cos\frac{\theta}{2}+ (u_x\mathbf{i} + u_y\mathbf{j} + u_z\mathbf{k})\sin\frac{\theta}{2},
\end{equation}
we have that the matrix $R$ generated via conjugation by $q$ is precisely the rotation matrix about axis $u$ by angle $\theta$ presented above. This can be seen by plugging in the coefficients and making use of trigonometric identities, as well as the fact that $u$ is a unit vector.

This gives us a four-parameter *versor* method for computing rotations, as opposed to the nine-parameter behemoth of using the $SO(3)$ representation. I believe this is the more compact and elegant way to tackle the problem at hand.

## Solving for the optimal rotation operator -- the quaternion way

Did you forget what we were doing? We were looking for a quaternion method to solve Equation 10 above, as opposed to the referenced $SO(3)$ method. This method is poorly documented, and I believe it is high time to change that fact. 

The *solution* is presented rather elegantly in [Besl and McKay](https://graphics.stanford.edu/courses/cs164-09-spring/Handouts/paper_icp.pdf), but it is not derived. The authors cite [Horn et al](http://graphics.stanford.edu/~smr/ICP/comparison/horn-hilden-orientation-josa88.pdf), who we followed to derive both the optimal translation vector and Equation 10. However, they follow from this point to derive the optimal rotation *matrix* in $SO(3)$. This is precisely what we are trying to avoid.

The authors also cite [Faugeras and Hebert](https://journals.sagepub.com/doi/abs/10.1177/027836498600500302), who *do* present a quaternion method, but arrive at a different form of the solution than Besl and McKay (they formulate an eigenvalue *minimization* problem, while Besl and McKay formulate an eigenvalue *maximization* problem). 

[Benjemaa and Schmitt](https://link.springer.com/content/pdf/10.1007/BFb0054732.pdf) do provide a derivation of a solution analogous to that of Besl and McKay, but with a slightly different framing of the problem. Moreover, the notation is a bit inelegant and the approach is hard to follow.

Finally, [Dolezal et al](https://www.springerprofessional.de/en/computational-complexity-of-kabsch-and-quaternion-based-algorith/18021414) in their 2020 EANN conference paper attempt to arrive at the same result, but make an upsetting amount of theoretical errors. I will cover this in more detail shortly.

I will follow the first step of Faugeras' approach, and then abandon all literature and do everything on my own. Let's begin with Equation 10 again, but we will write the rotation operator in terms of a quaternion $q$:

\begin{equation}
E(q) = \sum_{n=1}^N ||\mathbf{v}_n' - q\mathbf{x}_n'q^*||^2,
\end{equation}
where $\mathbf{v}_n' = T(v_n')$ and $\mathbf{x}_n' = T(x_n')$ -- that is, they are the quaternion representations of these vectors. As the expression inside the modulus has real component 0, the quaternion modulus is identical to the two-norm of the corresponding vectors. This means $E(q)=E(R)$, as desired. We are looking for versor $q$ that minimizes this expression.

To begin, we use the fact that the quaternion modulus is multiplicative, and multiply by the squared modulus of $q$. As $q$ is a versor, this is equivalent to multiplying by 1. Using the fact that for versors, $qq^* = 1$, this allows us to write:
\begin{align}
E(q) = E(q) ||q||^2 &= \sum_{n=1}^N ||\mathbf{v}_n' - q\mathbf{x}_n'q^*||^2||q||^2\\
&= \sum_{n=1}^N ||\mathbf{v}_n'q - q\mathbf{x}_n'q^*q||^2\\
&= \sum_{n=1}^N ||\mathbf{v}_n'q - q\mathbf{x}_n'||^2.
\end{align}
From here, we expand out the squared norm. This turns out to be identical to expanding the square norm of a vector difference, where the quaternion *dot product* is identical to the dot product on $\mathbb{R}^n$ (this is not hard to show by writing out terms, if you are interested). Note that this means the dot product is commutative. We have
\begin{align}
E(q) &= \sum_{n=1}^N ||\mathbf{v}_n'q||^2 + \sum_{n=1}^N ||q\mathbf{x}_n'||^2 - 2\sum_{n=1}^N q\mathbf{v}_n'\cdot \mathbf{x}_n' q \\
& = \sum_{n=1}^N ||\mathbf{v}_n'||^2 ||q||^2 + \sum_{n=1}^N ||q||^2||\mathbf{x}_n'||^2 - 2\sum_{n=1}^N q\mathbf{v}_n'\cdot \mathbf{x}_n' q \\
&= \sum_{n=1}^N ||\mathbf{v}_n'||^2 + \sum_{n=1}^N ||\mathbf{x}_n'||^2 - 2\sum_{n=1}^N q\mathbf{v}_n'\cdot \mathbf{x}_n' q.
\end{align}
We have used the multiplicativitiy of the quaternion modulus and the fact that $q$ is a versor. The first two terms are $q$-independent, so minimizing $E$ is equivalent to minimizing the third term. The term is negative, so this is equivalent to *maximizing* the negative of this term. That is,
\begin{equation}
\arg\!\min_q E(q) = \arg\!\max_q \sum_{n=1}^N q\mathbf{v}_n' \cdot \mathbf{x}_n' q.
\end{equation}
Maximizing the term on the right is our new goal. First, we will use our matrix representation of quaternions to map this quaternion expression to one containing only real matrices and vectors:
\begin{align}
q\mathbf{v}_n' \cdot \mathbf{x}_n' q &= Q\mathbf{v}_n'\cdot\mathbf{X}_n'q\\
&=(\mathbf{X}_n'q)^TQ\mathbf{v}_n' \\ 
&= q^T\mathbf{X}_n'^TQ\mathbf{v}_n.
\end{align}
To proceed, we need one more identity. This looks *close* to the form of a quadratic form $q^TAq$, which invites optimization via eigendecomposition. However, to arrive at this form, we would need to swap the order of $\mathbf{v}_n'$ and $Q$, which is illegal! We instead must use the restrictions in place to arrive at a new matrix, $\hat{\mathbf{V}}_n'$, such that $Q\mathbf{v}_n' = \hat{\mathbf{V}}_n'q$.

We will work this out "by hand" here, despite its seeming silliness, because this is not present in *any* literature I have found. If $q = (a\;b\;c\;d)^T$ and $\mathbf{v}_n' = (0\;\mathbf{v}_{x,n}'\;\mathbf{v}_{y,n}'\;\mathbf{v}_{z,n}')^T$, we can write
\begin{align}
Q\mathbf{v}_n' &= \begin{pmatrix} a&-b&-c&-d\\ b&a& -d&c \\ c&d&a&-b\\d&-c&b&a\end{pmatrix}\begin{pmatrix} 0 \\ \mathbf{v}_{x,n}' \\ \mathbf{v}_{y,n}' \\ \mathbf{v}_{z,n}'\end{pmatrix}\\
& \\
&= \begin{pmatrix} -b\mathbf{v}_{x,n}' -c\mathbf{v}_{y,n}'-d\mathbf{v}_{z,n}'\\ a\mathbf{v}_{x,n}' -d\mathbf{v}_{y,n}'+c\mathbf{v}_{z,n}'\\d\mathbf{v}_{x,n}' +a\mathbf{v}_{y,n}'-b\mathbf{v}_{z,n}'\\-c\mathbf{v}_{x,n}' +b\mathbf{v}_{y,n}'+a\mathbf{v}_{z,n}'\end{pmatrix} \\
& \\
&=\begin{pmatrix} 0&-\mathbf{v}_{x,n}'&-\mathbf{v}_{y,n}'&-\mathbf{v}_{z,n}'\\ \mathbf{v}_{x,n}'&0&\mathbf{v}_{z,n}'&-\mathbf{v}_{y,n}' \\ \mathbf{v}_{y,n}'&-\mathbf{v}_{z,n}'&0&\mathbf{v}_{x,n}'\\ \mathbf{v}_{z,n}'& \mathbf{v}_{y,n}'&-\mathbf{v}_{x,n}'&0\end{pmatrix}\begin{pmatrix} a \\ b \\ c\\ d \end{pmatrix}\\
& \\
& = \hat{\mathbf{V}}_n'q.
\end{align}
This is *not* merely the transpose of $\mathbf{V}_n'$. Now we can write the expression to be maximized as 
\begin{align}
\sum_{n=1}^N q^T \mathbf{X}_n'^T\hat{\mathbf{V}_n'}q &= q^T S q,\\
\text{where } S &= \sum_{n=1}^N \mathbf{X}_n'^T\hat{\mathbf{V}_n'}.
\end{align}

Pulling the $n$-independent vector-form versors $q$ and $q^T$ out of the sum turns this into a quadratic form. It can be shown computationally that $S$ is a symmetric matrix (I used a computer algebra systemi just to make sure). 

The problem comes down to maximizing a quadratic form defined by a symmetric matrix, constrained by $||q||=1$. The solution to this sort of problem is well-known, and is derived through the spectral theorem. The spectral theorem states that any symmetric matrix $S$ is *unitarily diagonalizable* by a matrix $P$ whose columns are the unit eigenvectors of $S$. Moreover, the entries on the diagonal of the diagonal matrix $D = P^T S P$ are the eigenvalues of $S$. $P$ is orthonormal, so $P^T = P^{-1}$. Letting $\hat{q}=P^Tq$, we can write the quadratic form above as 
\begin{align}
q^T S q &= q^T P (P^T S P) P^T q \\
&= \hat{q}^TD\hat{q} \\
&= \lambda_1 \hat{q}_1^2 + \lambda_2 \hat{q}_2^2 + \lambda_3 \hat{q}_3^2 + \lambda_4 \hat{q}_4^2,
\end{align}
where the $\lambda_i$ are the eigenvalues of $S$ and the elements of $\hat{q}$ are, by definition of $P$, the projections of $q$ onto the eigenvectors of $S$. We write $\hat{q}_i = e_i\cdot q$ where $e_i$ is the unit eigenvector of $S$ corresponding to eigenvalue $\lambda_i$. 
Without loss of generality, assume $\lambda_1$ is the largest eigenvalue of $S$. Because $q$ is of unit norm, it can be seen that the expression above will reach its maximum value when $q^T S q = \lambda_1$. This occurs if $\hat{q}_1 = e_1\cdot q = 1$, or $q = e_1$.
That is, **the optimal rotation quaternion** $q$  **is the unit eigenvector of** $S$  **corresponding to the largest eigenvector**.

Now we have found the optimal rotation in terms of quaternions, incredibly, via solving a *real* eigenvalue problem! This is the wonder of representing quaternions as real matrices. In contrast, using $SO(3)$ matrices, we would have to compute a spectral value decomposition. Generally speaking, eigendecomposition is significantly faster than SVD.

## An attractive closed form for $S$
We can write this matrix, as Besl and McKay do, in terms of the cross-covariance matrix very neatly. I will mimic their notation. The $3\times 3$ cross-covariance matrix is
\begin{equation}
\Sigma = \sum_{n=1}^N v_n'x_n'^T.
\end{equation}
Its antisymmetric component (times 2) is $A = \Sigma-\Sigma^T$. Let $\Delta = (A_{2,3}\; A_{3,1}\; A_{1,2})^T$. Then we can write our matrix of import as
\begin{equation}
S = \begin{pmatrix}tr(\Sigma)&\Delta^T\\ \Delta& \Sigma+\Sigma^T -tr(\Sigma)I_3 \end{pmatrix},
\end{equation}
where $I_3$ is the $3\times 3$ identity matrix.
Note that in both the $SO(3)$ and quaternion methods, we must compute the cross-correlation matrix. This formula for $S$ makes it clear that no other significant computation is required to arrive at $S$. The concurrence between this expression and the one derived above can be shown, but is best done via a computer algebra system. We do so below, showing the summands in Equation 51 rather than the entire $S$ matrix. This is equivalent to showing equality of the sums. SBesl is a summand in Equation 51, and SFrost is a summand in Equation 48:

```julia:./code/exb
using Symbolics, LinearAlgebra, Latexify # hide
function QuatMat(w) 	     	     # hide 
	[w[1] -w[2] -w[3] -w[4] # hide
	 w[2]  w[1] -w[4]  w[3] # hide
	 w[3]  w[4]  w[1] -w[2] # hide
	 w[4] -w[3]  w[2]  w[1]] # hide
end # hide

@variables  x_1 x_2 x_3 v_1 v_2 v_3 SIGMA A DELTA SBesl SFrost

x = [x_1;x_2;x_3]
v = [v_1;v_2;v_3]
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
```
\textoutput{./code/exb}



## The case of unknown correspondence
All of this was to determine the optimal translation and rotation when the correspondence of the points between the sets is already known -- that is, the points are already registered. Part of our problem is actually registering the points! Don't worry, this won't take too long...

We present Besl and McKay's algorithm. Suppose we start with sets $X$ and $V$ each with a different number of points. For each of the $N_X$ points in $X$, we will find the nearest point to it in $V$, consider those two points registered. This allows us to define a new registered point set of $N_X$ ordered points in $V$:

\begin{equation}
\mathcal{C}(X,V) = P = \{p_i\}_{i=1}^{N_X}, \text{ where} 
\end{equation}
\begin{equation}
p_i =  \arg\!\max_{v \in V} ||v - x_i||^2.
\end{equation}


We call the ordered set of such points $P = \mathcal{C}(X,V)$ the set of closest points in $V$ to $X$, and write it as a $3 \times N_X$ matrix. Now we are in the special case where we have two equally sized registered sets of points, so we can use the algorithms described above!

Of course, this is very naive at first glance -- assuming that the nearest points are registered is clearly invalid in even the most basic of examples. However, in an *iterative* algorithm, we can perform the registration again after our first rotation and translation to gain a better sense of the true registration. 

At each iteration, we will change the target/registered set $P$ based on the formula above, then carry out our algorithm as described above. This is:

**Initialize** $q_0 = (1\;0\;0\;0)^T$, $t_0 = (0\;0\;0)^T$, $X_0 = X$, and $k$=0. The following steps are then repeated, iterating over $k$ until convergence is achieved.

**1 --** Compute the closest points in $V$ to $X_{k}$, $W_{k} = \mathcal{C}(X_k,V)$, as well as the mean squared error $E_{k}$. **Terminate** the algorithm if $E_{k}$ is sufficiently small.

**2 --** Compute the optimal rotation $R_k$ and translation $t_k$ for these vectors via either the quaternion or $SO(3)$ methods described above.

**3 --** Apply the rotation and translation: $X_{k+1} = R_k(X) + t_k$.

This algorithm will converge to a local mean squared error minimum. While this is proven by Besl and McKay, this should already be convincing -- at each $k$ the error between $W_k$ and $X_k$ is minimized via the closest points operation $\mathcal{C}$, and then the error between $X_{k+1}$ and $W_{k}$ is minimized by finding the optimal rotation and translation (as proven above). It should be clear that this "chain of minimization" will never increase the error.

## Results for OCT volumes -- Synthetic ellipsoids

I have seen promising results using this algorithm, both using synthesized "perfect" data and real data from the round window membrane from an *in vivo* gerbil experiment. I will present the perfect data first. Unless otherwise stated, all volumes are displayed with MATLAB's volume viewer, and all computations are done with MATLAB. I made heavy use of the MATLAB image processing toolbox.

@@row
@@container
~~~
<img class="left" style="width:50%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/Disk Volume.PNG">
~~~
I began with a volume scan of a speaker membrane, which is thick, reflective and flat. I then thresholded this data by index to form an ellipsoidal solid, as shown to the left. We will rotate, translate and add noise to this volume. This will generate a second volume, which we will try to register with the first.
@@
@@

Below we plot the two volumes, initial and transformed, on top of one another. These are not binary volumes, but rather unsigned integers. We have to turn these into binary volumes so we can form two lists of indices, $V$ and $X$. We also should note that the algorithm has super-linear complexity in $N$, so we want to reduce the number of points in $V$ and $X$ as much as possible without losing the information necessary to register the volumes.

@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/Volumes On Top.PNG">
~~~
@@
@@


Our solution is to **a)** downsample the volume so that there are fewer total points; **b)** median filter the volume to denoise -- we are not concerned with fine features, so this is ok; **c)** threshold the image to make it a binary one containing only the most reflective structures; **d)** segment the volume, as registering one segment in the volumes should be equivalent to registering the volumes in total; **e)** perform edge detection, as registering the segment's edges is equivalent to registering the segment, which is equivalent to registering the entire volumes.

@@row
@@container
~~~
<img class="right" style="width:50%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/EdgeDetected.png">
~~~
@@
@@
It is much easier to look at cross-sections, as humans have a hard time visualizing three-dimensional objects from images alone (weak). Here is a single cross-section of the two volumes after the process above has been employed. The effects of translation and rotation are visible through these two images. We call these two sets of 3-D edge points $V$ (unrotated) and $X$ (rotated/translated). In this case, $V$ contains 10150 points and $X$ contains 9971 points, whereas the thresholded images have about 100000 points.

@@row
@@container
~~~
<img class="left" style="width:75%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/W0.PNG">
~~~
Let's consider the first step in the algorithm, where we start by computing the first pairing between $X$ and a subset of $V$ called $W_0$. The set $W_0$ is shown to the left, which we can see is all on one side of the ellipsoid. This is because the rotated ellipsoid $X$ is on one side of $V$, so all of the points on $X$ are nearer to these points than ones on the opposite side. This should "fill out" as we proceed across more iterations.
@@
@@

@@row
@@container
~~~
<img class="right" style="width:100%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/First Rotation.png">
~~~
The next step is that we compute the first optimal rotation and translation to register $X$ with $W_0$, yielding $X_1 = R_1(X_0) + t_1$. The image to the right presents an example cross-section containing $V$ in red, $X$ in blue, $X_1$ in white and the new nearest set $W_1$ in yellow. You can see that the white ellipsoid, the first registration attempt, is nearer to the correct shape of $V$ than the original $X$. The new nearest set, $W_1$, is no longer on only one side of the ellipsoid. Note that this rotation does not preserve cross-sections, so do not be misled!.
@@
@@

Finally, we will Consider what happens after 100 iterations. The figure below is of the same type as that above. The white cross-section -- the approximate registration after 100 iterations -- is nearly right on top of the target volume $V$! This is exactly what we want. To be sure this holds across all cross-sections, we plot the two volumes on top of each other below. They are directly on top of each other, near-indistinguishable. On my not-so-great computer, 100 iterations took 85 seconds. 

@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/100 Rotations.png">
~~~
@@
@@
@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/Volumes On Top 100 iterations.PNG">
~~~
@@
@@

Finally, let's look at the convergence of the mean square error. The figure below shows that in this idealized example, the error approaches zero quite rapidly. The figure below this one, however, tells an interesting story. Although the error remains *very* low, changing by tiny fractions of a percentage point after 25 iterations, the translation and quaternion vectors actually change very significantly after this point -- $t_y$ and $t_z$, for example, change by 50\% between 25 and 100 iterations. This is because the geometry of the problem. 
@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/MSE.png">
~~~
@@
@@

@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/Convergences.png">
~~~
@@
@@

This means that converged error is not actually the best metric for converged registration. Instead, we should determine converges by percent change in *every* element of $q$ and $t$. This effect exaggerated because of the geometry of this problem, but is necessary to watch out for. Below, we show the convergence curves after 300 iterations, after which all parameters have converged.

@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/Speaker Ellipsoid/Convergences 300.png">
~~~
@@
@@

## Results for OCT volumes -- an *in vivo* gerbil cochlea

@@row
@@container
~~~
<img class="right" style="width:50%;" src="/assets/Quaternion Figures/RWM/RWM anatomy.jpg">
~~~
In our lab's *in vivo* gerbil experiments, we take vibration measurements through the round window membrane (RWM). The RWM is a transparent structure atttached to the bony wall of the cochlea, through which the organ of Corti can be seen (see the anatomical diagram to the right). The OCT beam cannot penetrate the bony wall, as it is not sufficiently transparent. This means that portions of the organ of Corti may be visible at some angles but not others. 
@@
@@

However, the RWM and bony wall's surface *always* get light. This means that when we are trying to register two cochlear volumes, while we are only interested in *vibrations* within the organ of Corti, we will *register* using the RWM and bony wall. Consider the volume scan below, presented in the ThorImage software. It is a bit challenging to parse, but the band spiraling downward (in $z$) is the organ of Corti. The top part is RWM and bone.

@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/RWM/RWM Thorimage.PNG">
~~~
@@
@@


@@row
@@container
~~~
<img class="left" style="width:60%;" src="/assets/Quaternion Figures/RWM/Volumes On Top.PNG">
~~~
That means that in our pre-processing, we need to segment out the RWM and bony wall. I have rotated and translated one RWM volume, added noise and then carried out this pre-processing. The segmented RWM and bone volumes are presented atop one another in the image to the left.

This is very hard to parse because the shapes are far more abstract. However, the cross-sectional images are much easier to visualize. Below are the registered cross-sections after 300 iterations, the error over iterations and the registered volumes on top of one another. 
@@
@@


@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/RWM/Cross-sections registered.png">
~~~
@@
@@

@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/RWM/MSE RWM.png">
~~~
@@
@@

@@row
@@container
~~~
<img class="left" style="width:100%;" src="/assets/Quaternion Figures/RWM/Volumes On Top Registered.PNG">
~~~
@@
@@

Note that convergence is slower, and due to the more abstract shapes, noise affects the minimum error more. This is beautiful and promising operation for *in vivo* cochlear volumes!


## My gripes with Dolezal et al

I am very dissapointed in a conference paper published by [Dolezal et al](https://www.springerprofessional.de/en/computational-complexity-of-kabsch-and-quaternion-based-algorith/18021414) in the Proceedings of the $21^\text{st}$ EANN 2020 Conference, which includes massive falsehoods in computing the optimal quaternion rotation matrix. I will walk through all of them here.

**1 -- Inventing a quaternion dot product identity** 

Start with their Equation 10, which is an expanded version of the error equation we provided above. They correctly say they should maximize the second term, then write the following in Equation 11:

\begin{equation}
\text{\textbf{FALSE:  }}q a_i q^* \cdot b_i = (q a_i)\cdot (b_i q)
\end{equation}

where $q$, $a_i$ and $b_i$ are quaternions. This statement implies that quaternions distribute in an interesting manner across dot product, even when $a_i$ and $b_i$ have only vector parts.

This is verifiably false, as I will show with the CAS below:

```julia:./code/exD
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
```
\textoutput{./code/exD}



**2 -- Falsely claiming a matrix is symmetric to apply the spectral theorem** 

The authors then give the correct forms for quaternion matrix representations (as seen in my presentation above) in equations 12 and 13. If their Equation 11 were correct, their expression of the dot product as a quadratic form in $q$ would be valid (their Equation 14).

However, they claim that the matrix $N_i = A_i^T B_i$ is symmetric, where $A_i$ and $B_i$ represent the matrix form of the quaternions $a_i$ and $b_i$. Taking this product gives a matrix which is clearly *not* symmetric! In fact, its off-diagonal elements are *skew-symmetric*! See below:

```julia:./code/ex1
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
```
\textoutput{./code/ex1}

We thereby cannot employ the spectral theorem and cannot say the maximum eigenvalue's unit eigenvector is the optimum quaternion, as they do in their Equation 15. 

**3 -- Falsifying a matrix product, and a probable typo** 

How do they get around this? They simply falsify an expression for $N_i$ not equal to $A_i^T B_i$. That is, their equation 16 is simply not $A_i^TB_i$ We computed this above. 

They also claim that the matrix they present is symmetric, but it can clearly be seen that the $(3,4)$ and $(4,3)$ entries are not equal! Sure, this could just be a typo. In fact, correcting for the minus sign in the $(3,4)$ entry, their $N$ matrix is precisely that presented in my Equation 43, and in Besl and McKay! 

It is more than likely that the authors simply (mis)copied the final matrix from a publication similar to Besl and McKay, and then fabricated a mathematical reasoning to pretend to arrive at the correct result. The rest of their publication seems to carry around this sign error.

Their result -- that the computational complexities of the $SO(3)$ and quaternion-based algorithms are the same -- is consistent with what I've seen empirically. The two methods seem to take similar amounts of time to run in my environment. My gripe is not with their result, but their presentation.

My anger comes from the fact that a derivation of the optimum quaternion like the one I have presented above is very difficult to find. Having to gain familiarity with quaternion arithmetic to attack this problem, I was stalled and confused by this article. 

Ultimately, in deriving the result on my own, I recognized that almost all of their steps contained major errors, and I think that this should not have been published in its current form. It is not correct and it is not fair to the reader, especially in this context where the material is very difficult to find elsewhere.


I know it is not likely, but I would like to call on Springer Nature to publish at least an errata for this publication. Hopefully my accurate and comprehensive presentation, while lengthy, could help people in my position who are looking for a derivation of this type. 
