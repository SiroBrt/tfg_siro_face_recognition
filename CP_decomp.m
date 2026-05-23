M=ones(3,4,2);
M(:,:,1) = [1 4 7 10; 2 5 8 11; 3 6 9 12];
M(:,:,2) = [13 16 19 22; 14 17 20 23; 15 18 21 24];
clc;clear;

sizes = [3,4,2];
R = 2

A = rand(sizes(1),R);
B = rand(sizes(2),R);
C = rand(sizes(3),R);
X = ktensor({A,B,C});
T = full(X);

new_X = cp_als(T,R);

T-full(new_X)


score(new_X,X)