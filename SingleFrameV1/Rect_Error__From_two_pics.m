%Read images
        numImages = 48;
        for i = 1:numImages
            
            try
    
% T1 = imread(fullfile('C:\Users\t.bagramyan\Desktop\Rect', sprintf('left%02d.bmp', i)));
% T2 =  imread(fullfile('C:\Users\t.bagramyan\Desktop\Rect', sprintf('right%02d.bmp', i)));

T1 = imread(fullfile('C:\Users\t.bagramyan\Documents\MATLAB\DC OneIm', sprintf('af_left_%02d_rec.bmp', i)));
T2 = imread(fullfile('C:\Users\t.bagramyan\Documents\MATLAB\DC OneIm', sprintf('af_right_%02d_rec.bmp', i)));

% J1 = imrotate(imread(fullfile('C:\Users\t.bagramyan\Desktop\Test1', sprintf('af_left_%02d_rec.bmp', i))),90);
% J2 =  imrotate(imread(fullfile('C:\Users\t.bagramyan\Desktop\Test1', sprintf('af_right_%02d_rec.bmp', i))),90);
        
% Collect interest points for each image
blobsT1 = detectSURFFeatures(rgb2gray(T1));
blobsT2 = detectSURFFeatures(rgb2gray(T2));       
% blobsJ1 = detectSURFFeatures(rgb2gray(J1));
% blobsJ2 = detectSURFFeatures(rgb2gray(J2));

% Find point correspondences
[featuresT1, validBlobsT1] = extractFeatures(rgb2gray(T1), blobsT1);
[featuresT2, validBlobsT2] = extractFeatures(rgb2gray(T2), blobsT2);
% [featuresJ1, validBlobsJ1] = extractFeatures(rgb2gray(J1), blobsJ1);
% [featuresJ2, validBlobsJ2] = extractFeatures(rgb2gray(J2), blobsJ2);

% Determine indexes of matching features
indexPairsT = matchFeatures(featuresT1, featuresT2,'Metric', 'SAD', ...
    'MatchThreshold', 5);
% indexPairsJ = matchFeatures(featuresJ1, featuresJ2,'Metric', 'SAD', ...
%         'MatchThreshold', 5);

% Retrieve locations of matched points for each image
testPointsT1 = validBlobsT1(indexPairsT(:,1),:);
testPointsT2 = validBlobsT2(indexPairsT(:,2),:);
% testPointsJ1 = validBlobsJ1(indexPairsJ(:,1),:);
% testPointsJ2 = validBlobsJ2(indexPairsJ(:,2),:);       

% Remove outliers and calculate errors
erTT = abs(testPointsT1.Location(:,2)-testPointsT2.Location(:,2));
% erJ = abs(testPointsJ1.Location(:,2)-testPointsJ2.Location(:,2));

ERRTT(i) = prctile(erTT(erTT<=prctile(erTT,75)),90);
% ERRJ(i) = prctile(erJ(erJ<=prctile(erJ,75)),90);
        
            catch
%                  disp('no such file')
            end
    end        

% % Plot errors
% plot(1:numImages,ERRJ, '-',1:numImages,ERRTT,'--');
plot(ERRTT);