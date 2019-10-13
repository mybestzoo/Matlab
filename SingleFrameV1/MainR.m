clc; clear;

numImages =  1;

for i = 1:numImages
    
    IL = imread('roomL.jpg');
    IR = imread('roomR.jpg');
    
%     IL = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test5\S12\Left', sprintf('Image%02d.bmp', i)));
%     IR = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test5\S12\Right', sprintf('Image%02d.bmp', i)));
    
    disp('---------------------------------- matching...')
    
    [ml,mr] = match(IL,IR);
    
    disp('---------------------------------- rectifying...')

    width = size(IR,2) ;
    height = size(IR,1);
    
%     TL = eye(3);
    [TL TR] = compRecOne(ml,mr,width,height);
    
    disp('---------------------------------- warping...')
    
    % find the smallest bb containining both images
%     bb = [0,0,size(IL,2),size(IL,1)];
    bb = mcbb(size(IL),size(IR), TL, TR);

%     tformL = projective2d(TL);
%     tformR = projective2d(TR);

    for c = 1:3

    %     Warp LEFT
       [JL(:,:,c),bbL] = imwarpT(IL(:,:,c), TL, 'bilinear', bb);       
    
    %     Warp RIGHT
       [JR(:,:,c),bbR] = imwarpT(IR(:,:,c), TR, 'bilinear', bb);

    end
    
    disp('---------------------------------- disparity map...')
    
    a = -512;
    b = 512;
    
    D = disparity(rgb2gray(JL), rgb2gray(JR), 'BlockSize', 5, 'DisparityRange', [a b], 'Method','SemiGlobal');
    marker_idx = (D == -realmax('single'));
    D(marker_idx) = min(D(~marker_idx));
%     D = D*255/max(max(D));

    imshow(D , [a b], 'InitialMagnification', 50)

    colormap jet;
    
    % -------------------- SAVE FILES

    %imwrite(D,fullfile('C:\Users\t.bagramyan\Desktop\Depthmap', sprintf('Image%02d.bmp', i)),'bmp');

    %disp('wrote disparity map');
    
    %clearvars 'JL' 'JR'

end