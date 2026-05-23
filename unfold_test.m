% unfold3 funciona similar pero ordena las cosas distinto y no tengo un
% estandar con el que comparar

clear;clc;
%rng(2)


tamano = [3,4,2];
D=round(rand(tamano)*10);


for k=1:3
    original = unfold(tensor(D),k); 
    mine = tt_unfold(D,k);
    if original==mine
        disp(sprintf('k=%i ok\n',k))
    else
        disp("original")
        disp(original)
        
        disp("mine")
        disp(mine)
        
        disp("diff")    
        disp(original-mine)
    end
end


