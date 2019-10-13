%% Read Images
IL = imread('C:\Users\t.bagramyan\Documents\MATLAB\DC\af_left_02_rec.bmp');
IR = imread('C:\Users\t.bagramyan\Documents\MATLAB\DC\af_right_02_rec.bmp');


%% Match points
% Collect interest points for each image
blobs1 = detectSURFFeatures(rgb2gray(IL));%, 'MetricThreshold', 2000);
blobs2 = detectSURFFeatures(rgb2gray(IR));%, 'MetricThreshold', 2000);

% Find point correspondences
[features1, validBlobs1] = extractFeatures(rgb2gray(IL), blobs1);
[features2, validBlobs2] = extractFeatures(rgb2gray(IR), blobs2);

% Determine indexes of matching features
indexPairs = matchFeatures(features1, features2,'Metric', 'SAD', ...
'MatchThreshold', 5);

% Retrieve locations of matched points for each image
ml = validBlobs1(indexPairs(:,1),:).Location';
mr = validBlobs2(indexPairs(:,2),:).Location'; 

% Remove outliers that have y-coord. difference more than 90-percentile
er = abs(ml(2,:)-mr(2,:));

ml(:,er>prctile(er,40)) = [];
mr(:,er>prctile(er,40)) = [];

%save('C:\Users\t.bagramyan\Documents\MATLAB\DC\data\test_pairs.mat','ml','mr')

showMatchedFeatures(IL,IR,ml',mr');