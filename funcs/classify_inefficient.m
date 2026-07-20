function [best_p,best_e] = classify_inefficient(T,z)
% Given a tensor of people with emotions and a z column of that tensor,
% finds who it is (from the given options)
[U1,U2,U3,S,~,~,~] = my_hosvd(T);
C = my_tmul(my_tmul(S,U1,1),U2,2);

best_diff = inf;
best_p = 0;
best_e = 0;
H = transpose(U3);
for e = 1:size(T,2)
    C_e = reshape(C(:,e,:),[size(T,1),size(T,3)]);
   
    x = lsqr(C_e,z);
    for p = 1:size(T,3)
        h_p = H(:,p);
        if norm(x-h_p) < best_diff
            best_e = e;
            best_p = p;
            best_diff = norm(x-h_p);
        end
    end
end