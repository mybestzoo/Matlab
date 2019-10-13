% leftImageJ = imread(fullfile('C:\Users\t.bagramyan\Documents\MATLAB\DC\af_left_02_rec.bmp'));
% rightImageJ = imread(fullfile('C:\Users\t.bagramyan\Documents\MATLAB\DC\af_right_02_rec.bmp'));
leftImageT = imread(fullfile('C:\Users\t.bagramyan\Desktop\150714_DAD_Census\DAD_Census_Final\src\mbd_right_rec_001.bmp'));
rightImageT = imread(fullfile('C:\Users\t.bagramyan\Desktop\150714_DAD_Census\DAD_Census_Final\src\mbd_left_rec_001.bmp'));


% disparityMapJ = disparity(rgb2gray(leftImageJ), rgb2gray(rightImageJ), 'BlockSize', 5, 'DisparityRange', [-256 256], 'Method','SemiGlobal');
disparityMapT = disparity(rgb2gray(leftImageT),rgb2gray(rightImageT), 'BlockSize', 5, 'DisparityRange', [-48 48], 'Method','SemiGlobal');

% figure;
% subplot(1,2,1)
% imshow(disparityMapJ , [-256 256], 'InitialMagnification', 50)
% title('J')
% colormap gray;
% subplot(1,2,2)
imshow(disparityMapT , [-48 48], 'InitialMagnification', 50)
%title('T')
colormap gray;

% disparityMapT = disparityMapT+100;
% 
% fileleft = sprintf('af_DC_%02d.bmp',i);
%    imwrite(disparityMapT,gray,fileleft,'bmp');

% numImages = 48;
% 
% IL  = cell(1, numImages);
% IR = cell(1, numImages);
% 
% %% For each frame
% 
% for i = 5:9
%     
%     try
%         
%     IL{i} = imread(fullfile('C:\Users\t.bagramyan\Documents\MATLAB\DC', sprintf('af_left_%02d_rec.bmp', i)));
%     IR{i} = imread(fullfile('C:\Users\t.bagramyan\Documents\MATLAB\DC', sprintf('af_right_%02d_rec.bmp', i)));
%     
%     disparityMapT = disparity(rgb2gray(IL{i}), rgb2gray(IR{i}), 'BlockSize', 5, 'DisparityRange', [-64 64], 'Method','SemiGlobal');
% 
%     disparityMapT = disparityMapT+64;
%     
%     fileleft = sprintf('af_DC_%02d.bmp',i);
%     imwrite(disparityMapT,gray,fileleft,'bmp');
%     
%     catch
%     
%         disp('no such file')
%     end    
% end

