import sage.crypto.lwe
from sage.crypto.lwe import balance_sample, samples, Regev
n_=3
lwe=sage.crypto.lwe.Regev(n=n_)
print lwe
print ("secret key is",lwe._LWE__s)
m=n_*5
CC= int(sqrt(n_*log(n_,2)))
print ("CC is")
print CC
L = [lwe() for _ in range(m)]
q = ZZ(next_prime(n_**2))
#list(map(L1, L))
print L
Real_error = [ZZ(a.dot_product(lwe._LWE__s)-c ) for (a,c) in L]
flag=1;
for i in range(m):
    	if Real_error[i]>q//2:
    		Real_error[i]= Real_error[i]-q;
    	if abs(Real_error[i])>CC:
    		flag=0;
print ("Real_error is",Real_error)
if flag==1:
	print ("Abs of real key is within CC ")
V = VectorSpace(GF(q), n_);
print V
for s in V:
    Error = [ZZ(a.dot_product(s)-c ) for (a,c) in L]
    flag=1
    for i in range(m):
    	if Error[i]>q//2:
    		Error[i]= Error[i]-q;
    	if abs(Error[i])>CC:
    			flag=0;
    if flag==1:
    	print Error
    	print("the really secret is",lwe._LWE__s)
    	print ("the secret we find is",s)
print ("finished")
#in regev's definition, q = ZZ(next_prime(n**2))