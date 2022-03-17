// CRIVO DE ERASTOTENES PARALELO DE FORMA INGENUA

#pragma omp parallel for
for(int p=2; p*p<=n; p++) {
  if(prime[p] == true)
    #pragma omp parallel for 
    for(int i=p*2; i<=n; i += p)
      prime[i] = false;
}