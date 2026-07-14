function new_T = aprox_tensor(T,k)
    [U1,U2,U3,S,s1,s2,s3]=my_hosvd(T);
    new_T = zeros(size(T));
    for i = 1:k
        new_T = new_T + my_tmul(my_tmul(my_tmul(S(:,:,i),U1,1),U2,2),U3(:,i),3)
    end
end