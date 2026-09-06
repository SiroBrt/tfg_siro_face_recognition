clear;clc;


%% initial parameters

outliers = [37,38,109,110,111,112,113,114,115,116,117,118]; % people missing a photo
non_outliers = 1:200;
non_outliers(outliers) = [];



resolution = 6*[3,4];
people = 50; 
chosen_people = randperm(200-length(outliers),people);
chosen_people = non_outliers(chosen_people);

emotions = 1:13;
% a bit of a cheat for easier recognition: all facing forward-ish
%easy_emotions = [4,5,6,11,12,13,14];
%emotions = easy_emotions;
%% Create dataset
tic
T = process_images(resolution,chosen_people,emotions);
global U1
global U3
global B
[U1,U2,U3,S,~,~,~] = my_hosvd(T);
B = my_tmul(S,U2,2);

disp("training time = " + toc)
%% classify image (z)
function [best_p, best_e] = mini_classify(z,T) 
global U1
global U3
global B
z_hat = transpose(U1)*z;

best_diff = inf;
best_p = 0;
best_e = 0;
H = transpose(U3);

if size(T,1) > size(T,3)
    % normally it's this case, but maybe we have a lot of people in low resolution
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
else
    C = my_tmul(B,U1,1);
    for e = 1:size(T,2)
        C_e = reshape(C(:,e,:),[size(T,1),size(T,3)]);

        [~, x] = evalc('lsqr(C_e,z);'); % to avoid all the messages of lsqr

        for p = 1:size(T,3)
            h_p = H(:,p);
            if norm(x-h_p) < best_diff
                best_e = e;
                best_p = p;
                best_diff = norm(x-h_p);
            end
        end
    end
end
end



%% create image (z)
function [result,tiempo] = mini_attempt(chosen_people,emotions,resolution,T)
%chosen_e = randperm(length(emotions),1);
chosen_e = 14;
chosen_p = randperm(length(chosen_people),1);
tic
img_name = "datasets/FEI_face_database/combined/"+ num2str(chosen_people(chosen_p)) + "-" + num2str(chosen_e,'%02d') +".jpg";
img = imread(img_name);
img_mod = rgb2gray(imresize(img,resolution));
z = double(img_mod(:));
[best_p, best_e] = mini_classify(z,T);
tiempo = toc;
result = (best_p == chosen_p);


%disp("Chosen person: " + chosen_people(chosen_p) + " with emotion " + chosen_e)
%disp("detected person: " + chosen_people(best_p) + " with emotion " + emotions(best_e))
%disp(tiempo + "s")

end
%%
avg_time = 0;
avg_succ = 0;
tries = 30;
for i = 1:tries
    [succ, t] = mini_attempt(chosen_people,emotions,resolution,T);
    avg_succ = avg_succ + succ; 
    avg_time = avg_time + t; 
end
avg_time = avg_time / tries
avg_succ = avg_succ / tries
