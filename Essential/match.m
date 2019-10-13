function [ml,mr,outliers_num] = match(IL,IR)
% %% Read Images
% IL = imread('C:\Users\t.bagramyan\Documents\MATLAB\DC\images\test0.bmp');
% IR = imread('C:\Users\t.bagramyan\Documents\MATLAB\DC\images\test1.bmp');


%% Match points
% Collect interest points for each image
% blobs1 = detectBRISKFeatures(rgb2gray(IL),'MinContrast',0.1,'NumOctaves',4);
% blobs2 = detectBRISKFeatures(rgb2gray(IR),'MinContrast',0.1,'NumOctaves',4);

blobs1 = detectSURFFeatures(rgb2gray(IL));%,'MetricThreshold', 1000);%,'NumOctaves',4);
blobs2 = detectSURFFeatures(rgb2gray(IR));%,'MetricThreshold', 1000);%,'NumOctaves',4);

% Find point correspondences
[features1, validBlobs1] = extractFeatures(rgb2gray(IL), blobs1);
[features2, validBlobs2] = extractFeatures(rgb2gray(IR), blobs2);

% Determine indexes of matching features
indexPairs = matchFeatures(features1, features2,'Metric', 'SAD','MatchThreshold', 5);%;,'MaxRatio', 0.6);

% Retrieve locations of matched points for each image
ml = validBlobs1(indexPairs(:,1),:).Location';
mr = validBlobs2(indexPairs(:,2),:).Location'; 

before = size(ml,2);

% % Remove outliers that have y-coord. difference more than 90-percentile
er = abs(ml(2,:)-mr(2,:));
% 
ml(:,er>prctile(er,90)) = [];
mr(:,er>prctile(er,90)) = [];

after = size(ml,2);

outliers_num = before-after;
% 
% save('C:\Users\t.bagramyan\Documents\MATLAB\DC\data\test_pairs.mat','ml','mr')

%showMatchedFeatures(IL,IR,ml',mr');