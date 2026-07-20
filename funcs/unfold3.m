function longMatrix = unfold3(Tensor,k)
%Unfolds the tensor along the k mode according to "Matrix methods in data mining"
sizes = size(Tensor);
if k==1
    longMatrix = reshape(Tensor(:,1,:),[sizes(1),sizes(3)]);
    for i = 2:sizes(2)
        longMatrix = cat(2,longMatrix,reshape(Tensor(:,i,:),[sizes(1),sizes(3)]));
    end
elseif k==2
    longMatrix = transpose(Tensor(:,:,1));
    for i = 2:sizes(3)
        longMatrix = cat(2,longMatrix,transpose(Tensor(:,:,i)));
    end
elseif k==3
    longMatrix = transpose(reshape(Tensor(1,:,:),[sizes(2),sizes(3)]));
    for i = 2:sizes(1)
        longMatrix = cat(2,longMatrix,transpose(reshape(Tensor(i,:,:),[sizes(2),sizes(3)])));
    end

end

