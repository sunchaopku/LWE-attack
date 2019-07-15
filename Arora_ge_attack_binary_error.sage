from sage.crypto.lwe import UniformSampler
from sage.crypto.lwe import LWE
D = UniformSampler(0, 1) # binary distribution
n_=3
q = ZZ(next_prime(n_**2))
print ("q is ",q)
lwe = LWE(n=3, q=next_prime(n_**2), D=D); 
print lwe
print ("secret key is",lwe._LWE__s)
m=n_*n_
L = [lwe() for _ in range(m)] # produce the samples
print L
P=PolynomialRing(GF(q), n_,var_array=['z'],sparse=False )
P.inject_variables()
f1 = P.gens()
test=[]
for i in range(n_):
    test.append(1)
test_vector=vector(test)
print test_vector
monomial_set = [P({tuple(a):1}) for a in WeightedIntegerVectors(2,test_vector)]
monomial_set += [P({tuple(a):1}) for a in WeightedIntegerVectors(1,test_vector)]
monomial_set += [P({tuple(a):1}) for a in WeightedIntegerVectors(0,test_vector)]
print monomial_set
number_of_var= binomial(n_+2,2)
matrix = Mat(GF(q),m,number_of_var).random_element()
y=[]
for j in range(m):
    for i in range(n_):
        a = L[j][0][i]
        if i ==n_-1:
            y.append(0)
        if i ==0:
            PP=(GF(q)(a))*f1[i]
        else:
            PP=PP + (GF(q)(a))*f1[i]
    PPP= (GF(q)(L[j][1])- PP)*(GF(q)(L[j][1])- PP-1)
    print PPP
    coef_k=[]
    for mono in monomial_set:
             coef_k.append(PPP.monomial_coefficient(mono))
    print coef_k
    matrix[j]=coef_k
print ("matrix",matrix)
yy=matrix.column(number_of_var-1)
yy=-yy
matrix.delete_columns([number_of_var-1])
print ("yy is",yy)
print matrix \ yy
yyy = matrix \ yy
key_found = []
for i in range(n_):
    key_found.append(GF(q)(yyy[number_of_var-2-i]))
print ("secret key is",lwe._LWE__s)
print ("the key we find is ",key_found)
