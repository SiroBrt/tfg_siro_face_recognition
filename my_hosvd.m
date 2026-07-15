function [U1,U2,U3,S,s1,s2,s3]=my_hosvd(A)
% Compute the HOSVD of a 3-way tensor A
[U1,s1,~]=svd(unfold3(A,1),"econ");
[U2,s2,~]=svd(unfold3(A,2),"econ");
[U3,s3,~]=svd(unfold3(A,3),"econ");
S=my_tmul(my_tmul(my_tmul(A,U1,1),U2,2),U3,3);