function longMatrix = tt_unfold(Tensor,k)
%Unfolds the tensor along the k mode according to tensor toolbox
sizes = size(Tensor);
if k==1
    longMatrix = Tensor(:,:,1);
    for i = 2:sizes(3)
        longMatrix = cat(2,longMatrix,Tensor(:,:,i));
    end
elseif k==2
    longMatrix = transpose(Tensor(:,:,1));
    for i = 2:sizes(3)
        longMatrix = cat(2,longMatrix,transpose(Tensor(:,:,i)));
    end
elseif k==3
    longMatrix = transpose(reshape(Tensor(:,1,:),[sizes(1),sizes(3)]));
    for i = 2:sizes(2)
        longMatrix = cat(2,longMatrix,transpose(reshape(Tensor(:,i,:),[sizes(1),sizes(3)])));
    end

end

