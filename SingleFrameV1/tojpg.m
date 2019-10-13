numImages = 48;

I  = cell(1, numImages);

%% For each frame

for i = 2:numImages
    
    try
        
    I{i} = imread(fullfile('C:\Users\t.bagramyan\Documents\MATLAB\DC', sprintf('af_DC_%02d.bmp', i)));
    
    fileleft = sprintf('af_left_%02d_rec.jpg',i);
    imwrite(I{i},fileleft,'jpg');
    
    catch
        
    end
end    