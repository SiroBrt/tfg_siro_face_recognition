% subjects {37,38,109-118} have a missing photo

clear;clc;

for p = 1:200
    for e = 1:14
        img_name = "datasets/FEI_face_database/combined/"+ num2str(p) + "-" + num2str(e,'%02d') +".jpg";
        img = imread(img_name);
        z = double(img(:));
        if all(z<10)
            disp("problem in person "+ p + ", emotion " + e)
        end
    end
end