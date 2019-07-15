from sage.crypto.lwe import UniformSampler
from sage.crypto.lwe import LWE
def arora_ge(n_,m,L,d):
#n_   dimension
#m    number of samples
#L    samples
#d    degree of errors    
    q = ZZ(next_prime(n_**2))
 #   print ("q is ",q)

    P=PolynomialRing(GF(q), n_,var_array=['z'],sparse=False )
    P.inject_variables()
    f1 = P.gens()
    test=[]
    for i in range(n_):
        test.append(1)
    test_vector=vector(test)
    monomial_set = [P({tuple(a):1}) for a in WeightedIntegerVectors(d,test_vector)]
    for i in range(d-1,-1,-1):
        monomial_set += [P({tuple(a):1}) for a in WeightedIntegerVectors(i,test_vector)]
   # print monomial_set      
    number_of_var= binomial(n_+d,d)
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
        PPP= (GF(q)(L[j][1])- PP)
        for k in range(1,d):
            PPP= PPP*(GF(q)(L[j][1])- PP- k)
           # print PPP
        coef_k=[]
        for mono in monomial_set:
                 coef_k.append(PPP.monomial_coefficient(mono))
        matrix[j]=coef_k
    yy=matrix.column(number_of_var-1)
    yy=-yy
   # print yy
    matrix.delete_columns([number_of_var-1])
  #  print matrix
    yyy = matrix \ yy
    key_found = []
    for i in range(n_):
        key_found.append(GF(q)(yyy[number_of_var-2-i]))
   # print ("the key we find is ",key_found)
    return key_found
