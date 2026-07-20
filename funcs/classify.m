function [best_p,best_e] = classify(T,z)
% Given a tensor of people with emotions and a z column of that tensor,
% finds who it is (from the given options)
[U1,U2,U3,S,s1,s2,s3] = my_hosvd(T);
B = my_tmul(S,U2,2);
z_hat = transpose(U1)*z;

best_diff = inf;
best_p = 0;
best_e = 0;
H = transpose(U3);
for e = 1:size(T,2)
    [Q,R] = qr(reshape(B(:,e,:),[size(T,1),size(T,3)]));
    R_e = R(1:size(T,3),:);
    Q_e = Q(:,1:size(T,3));
    x = R_e\(transpose(Q_e)*z_hat);
    
    for p = 1:size(T,3)
        h_p = H(:,p);
        if norm(x-h_p) < best_diff
            best_e = e;
            best_p = p;
            best_diff = norm(x-h_p);
        end
    end
end