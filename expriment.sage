attach("arora_ge.sage")
n_= 30
t = n_**(0.5)
pp= (1-1/t)**(t)
print ("Probability of subsamples no error",pp)
p = 1/(n_**(0.5))
print ("error rate is" , p)
X = GeneralDiscreteDistribution([1-p, p]);# Non-uniform distribution
D = UniformSampler(0, 0) # no error
q = ZZ(next_prime(n_**2))
print ("modulus q is ",q)
m=2*int(n_**(1.5))+ 1 # produce the samples
num_sub= int(n_**(0.5)) + 1
print ("number of original samples",m)
print ("number of sub_samples",num_sub)
lwe = LWE(n=n_, q=next_prime(n_**2), D=D)
print ("secret key is",lwe._LWE__s)
Original_sample = [lwe() for _ in range(m)]
#print ("original samples with no error",Original_sample)
Non_uniform_sample = [(sample[0],sample[1] + X.get_random_element()) for sample in Original_sample]
#print ("Non_uniform_samples",Non_uniform_sample)
cnt = 0;
sub_samples_no_error_num = 0
for i in range(0,100):# iteration for many times in order to get success
	Sub_set = Subsets(m,num_sub).random_element()
	#print("Sub_set is",Sub_set)
	sub_samples = []
	sub_samples_no_error = true
	for j in Sub_set:
		sub_samples.append(Non_uniform_sample[j-1])
		if Non_uniform_sample[j-1][1]!= Original_sample[j-1][1]:
			sub_samples_no_error = false;
	#print ("sub_samples",sub_samples)
	if sub_samples_no_error == true:
		print("sub_samples_no_error")
		sub_samples_no_error_num = sub_samples_no_error_num + 1
	else:
		print("sub_samples have error")
		continue
	new_tuple = [x + y for x in sub_samples for y in Non_uniform_sample]
	temp=[]
	for sample in new_tuple:
		#zyx=[]
		t=[]
		b=[]
		for j in range(0,n_):
			t.append(sample[0][j] + sample[2][j])
		b.append(t)
		b.append(sample[1]+sample[3])
		temp.append(b)
#	print("temp",temp)
	new_samples = temp
	print ("number of new_samples",len(new_samples))
#	print ("new_samples",new_samples)
	flag = true 
	res = arora_ge(n_,len(new_samples),new_samples,2);
	print ("the key we find is", res)
	for j in range(0,n_):
		if res[j] != lwe._LWE__s[j]:
			flag = false;
	if flag == true:
		cnt = cnt + 1
		print("success")
	#	break
print ("sub_samples_no_error_num",sub_samples_no_error_num)
print ("success times",cnt)

#new_samples = lwe_sample_amplify(n_,m, L,k)
#arora_ge(n_,len(new_samples),new_samples,d+k-1)