% Matches features on the left and right images.
% Input - images IL and IR
% Output - matrix ml and matrix mr
% Matrices ml and mr consist of coordinates of corresponding features on the left and right images
% Author: Tigran Bagramyan

function [ml,mr] = match(IL,IR)
%% Read Images
% IL = imread('C:\Users\t.bagramyan\Documents\MATLAB\DC\images\test0.bmp');
% IR = imread('C:\Users\t.bagramyan\Documents\MATLAB\DC\images\test1.bmp');

%% Match points
% Collect interest points for each image

% With BRISK algorithm
% blobs1 = detectBRISKFeatures(rgb2gray(IL),'MinContrast',0.1,'NumOctaves',4);
% blobs2 = detectBRISKFeatures(rgb2gray(IR),'MinContrast',0.1,'NumOctaves',4);

% With SURF algorithm
blobs1 = detectSURFFeatures(rgb2gray(IL));%,'MetricThreshold', 3000);%,'NumOctaves',4);
blobs2 = detectSURFFeatures(rgb2gray(IR));%,'MetricThreshold', 3000);%,'NumOctaves',4);

% Find point correspondences
[features1, validBlobs1] = extractFeatures(rgb2gray(IL), blobs1);
[features2, validBlobs2] = extractFeatures(rgb2gray(IR), blobs2);

% Determine indexes of matching features
indexPairs = matchFeatures(features1, features2,'Metric', 'SAD','MatchThreshold', 5);%;,'MaxRatio', 0.6);

% Retrieve locations of matched points for each image
ml = validBlobs1(indexPairs(:,1),:).Location';
mr = validBlobs2(indexPairs(:,2),:).Location'; 