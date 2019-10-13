% Rectification (only right image) without calibration (only correspondences)
clc; clear;

numImages =48;

IL  = cell(1, numImages);
IR = cell(1, numImages);

%% For each frame

for i = 1:numImages
    
  try
    
    IL{i} = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test2\original', sprintf('af_left_%02d.bmp', i)));
    IR{i} = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test2\original', sprintf('af_right_%02d.bmp', i)));

disp('---------------------------------- rectifying...')

width = size(IR{i},2) ;
height = size(IR{i},1);

[ml,mr] = match(IL{i},IR{i});

showMatchedFeatures(IL{i},IR{i},ml',mr');
m1 = ml;
m2 = mr;

TL = eye(3);
TR = compRecOneT(ml,mr,width,height);

disp('---------------------------------- warping...')

% find the smallest bb containining both images
bb = mcbb(size(IL{i}),size(IR{i}), TL, TR);

tformL = projective2d(TL);
tformR = projective2d(TR);

for c = 1:3

%     Warp LEFT
     [JL(:,:,c),bbL] = imwarpT(IL{i}(:,:,c), TL, 'bilinear', bb);
    
%     Warp RIGHT
     [JR(:,:,c),bbR] = imwarpT(IR{i}(:,:,c), TR, 'bilinear', bb);

end

% JL = imwarp(IL{i}, tformL, 'OutputView', imref2d(size(IL{i})));
% 

% JR = imwarp(IR{i}, tformR,'OutputView', imref2d(size(IR{i})));

% L = imcrop(JL,[0 0 size(JL,2)+1-36 size(JL,1)]);
% R = imcrop(JR,[36 0 size(JR,2) size(JR,1)]);

% transform the points to visualize them together with the rectified images
% pts1Rect = transformPointsForward(tformL, m1');
% pts2Rect = transformPointsForward(tformR, m2');

% figure;
% showMatchedFeatures(JL, JR, pts1Rect, pts2Rect);
% legend('Inlier points in rectified I1', 'Inlier points in rectified I2');




%% -------------------- SAVE FILES

% JL = imresize(JL,0.5);
% JR = imresize(JR,0.5);

fileleft = sprintf('af_left_%02d_rec.bmp',i);
imwrite(JL,fileleft,'bmp');
fileright = sprintf('af_right_%02d_rec.bmp',i);
imwrite(JR,fileright,'bmp');

disp(['wrote rectified images']);

  catch
        disp('no such file')
  end    
clearvars JL JR ml mr L R
end


