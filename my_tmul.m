function result = my_tmul(Tensor, Matrix, k)
%Takes a matrix and a tensor and performs their k-mode multiplication
sizes_tensor = size(Tensor);
sizes_matrix = size(Matrix);
if sizes_matrix(2) ~= sizes_tensor(k)
    disp("error during matrix-tensor multiplication");
    result = zeros(sizes_tensor);
    return
end

new_size=sizes_tensor;
new_size(k)=sizes_matrix(1);
result = zeros(new_size);
if k==1
    for i1 = 1:new_size(2)
        for i2 = 1:new_size(3)
            result(:,i1,i2)=reshape(Matrix*reshape(Tensor(:,i1,i2),[sizes_matrix(2),1]),[1,new_size(1),1]);
        end
    end
elseif k==2
    for i1 = 1:new_size(1)
        for i2 = 1:new_size(3)
            result(i1,:,i2)=reshape(Matrix*reshape(Tensor(i1,:,i2),[sizes_matrix(2),1]),[1,new_size(2),1]);
        end
    end
else
    for i1 = 1:new_size(1)
        for i2 = 1:new_size(2)
            result(i1,i2,:)=reshape(Matrix*reshape(Tensor(i1,i2,:),[sizes_matrix(2),1]),[1,new_size(3),1]);
        end
    end
end



