def lwe_sample_amplify(n_,m, L,num_amplify):
#n_ dimension     m sample number      
# L samples       num_amplify:  numbers of samples combined
	S = Subsets(m, num_amplify)
#	print S.list()
	new_samples=[]
	for s in S.list():
		k = 0
		temp = []
		new_a = []
		new_b = []
		for j in range(n_):
			sum_a = 0
			for i in range(len(s)):
				sum_a += L[s[i]-1][0][j]
			new_a.append(sum_a)
		sum_b = 0
		for i in range(len(s)):
			sum_b +=  L[s[i]-1][1]
		new_b.append(sum_b)
	#	print new_b
		new_vector= [[ _ for _ in new_a],sum_b ]
	#	print new_vector
		new_samples.append(new_vector)
	return new_samples



