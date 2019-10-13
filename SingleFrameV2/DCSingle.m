% The main script DCSIngle.m
% 
% 1. Put intrinsic parameters Kl,Kr and translation vector t to section %%Camera parameters. 
% Additionally add the rotation matrix Rotation for comparison with static calibration results.
% 
% 2. Put images to the folder specified by dirname in section %%Get list of files.
% Be sure that all the left images have the name ending at _L.bmp and all the right images _R.bmp
% 
% 3. Choose the numerical parameter (the third parameter) for OutliersDBSCAN function in section %%Main routine. 
% The bigger the parameter the more outliers will be removed. Recommended values are 50-80. 
% 
% 4. Run the script. The outcome will consist of the following variables:
% 	J - vector containing number of iterations of the algorithm for each frame
% 	num_out - vector containing number of outliers for each image
% 	num_points - number of matched features for each image (after removing outliers)
% 	ImgsL, ImgsR - list of images
% 	RepK - vector of re-projection errors of DC for each frame
% 	Rep - vector of re-projection errors of SC for each frame
% 	RotKalman - cell containing rotation matrices for each frame (result of calibration)

clc; clear;

%% Camera parameters
Kl = [3682.80884439132	0	2055.01005967075
0	3695.16960266724	1565.11498282383
0	0	1];

Kr = [3699.16685749874	0	1953.52877994810
0	3711.41707442142	1573.51214758073
0	0	1];

Rotation = [0.999960972083268	0.00565825178573342	0.00678516742719483
-0.00567792743310037	0.999979721480090	0.00288405420637780
-0.00676871112917868	-0.00292246733602343	0.999972821497824];

t = [-2.0335825307969; 0.0428073763904747; -0.0104026784209155];

%% Get list of files
dirname = 'C:\Users\t.bagramyan\Desktop\New folder (2)\S9';
ImgsL = dir([dirname '/' '*_L.bmp']);
ImgsR = dir([dirname '/' '*_R.bmp']);

if size(ImgsL,1)==size(ImgsR,1)
    numImages = size(ImgsL,1);
else
    numImages = 0;
end

NewRot = cell(1,numImages);
NewRotK = cell(1,numImages);

%% For each frame
for i = 1:numImages
    i
    
RepK(i)=10;
        
IL = imread(fullfile(dirname, ImgsL(i).name));
IR = imread(fullfile(dirname, ImgsR(i).name));

%match points
[ml,mr] = match(IL,IR);

points_before = size(ml,2);

[ml mr] = OutliersDBSCAN(ml,mr,50);

num_points(i) = size(ml,2);

num_out(i) = points_before-num_points(i);

j=0;
while (RepK(i) > 2) && (j<20)
%split matched points into training and test set
if size(ml,2) <50
    trainl = ml;
    trainr = mr;

    testl = ml;
    testr = mr;
else
    
idx = randMix(size(ml,2));

trainl = ml(:,idx(1:ceil(size(idx,1))));
trainr = mr(:,idx(1:ceil(size(idx,1))));

testl = ml(:,idx(1:ceil(size(idx,1))));
testr = mr(:,idx(1:ceil(size(idx,1))));

% Rotation matrix from Kalman filter
[RotKalman{i}] = RotK(trainl,trainr,Kl,Kr,floor(size(trainl,2)/50));

RepK(i) = reprojection_error(testl,testr,Kl,Kr,RotKalman{i},t);
testRep(j+1) = RepK(i);
end
J(i) = j;
j=j+1;
end

Rep(i) = reprojection_error(testl,testr,Kl,Kr,Rotation,t);   

clearvars ml mr trainl trainr testl testr
end
clearvars -except J num_out num_points ImgsL ImgsR RepK Rep RotKalman