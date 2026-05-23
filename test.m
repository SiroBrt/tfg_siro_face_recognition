clear;clc;
%rng(2)


tamano = [3,4,2];
D=round(rand(tamano)*10);

[U1,U2,U3,S,s1,s2,s3] = my_hosvd(D)

hosvd(tensor(D),)