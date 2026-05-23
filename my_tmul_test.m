clear;clc;
%rng(2)


tamano = [3,4,2];
D=round(rand(tamano)*10);
other_size = 4;

for k=1:3
    U = round(rand([other_size,tamano(k)])*10);
    original = ttm(tensor(D),U,k);
    mine = tensor(my_tmul(D,U,k));
    if find((original==mine)==0)
        disp("original")
        disp(original)
        
        disp("mine")
        disp(mine)
        
        disp("diff")    
        disp(original-mine)
    else
        fprintf('k=%i ok\n\n',k)
        
    end
end


