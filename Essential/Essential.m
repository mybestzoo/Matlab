clc; clear;

numImages =1;

IL  = cell(1, numImages);
IR = cell(1, numImages);
NewRot = cell(1,numImages);

for i = 1:numImages
    
    try
        
% Read images    
IL{i} = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test3', sprintf('test_left_%02d.bmp', i)));
IR{i} = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test3', sprintf('test_right_%02d.bmp', i)));

%Intrinsics Test1
Kl = [3700.82892306015 0 2214.70983479010;
    0 3704.67628906163 1609.70890674429;
    0 0 1];

Kr = [3728.24007153751 0 2113.44365959795;
    0 3729.89267149350 1658.71651579994;
    0 0 1];

%Extrinsics Test1
R = [0.999755884799654	0.00576021325556484	-0.0213305122233765;
-0.00593532775294702	0.999949129465737	-0.00815538872028626;
0.0212824503506128	0.00828000144711887	0.999739215437261];

t = [-0.0193201564283955;0.000137894249766687;0.000162530467599130];

% %Intrinsics Test2
% Kl = [2433.97387923278 0 1284.63040068900;
%     0 2400.57991882680 908.786317866895;
%     0 0 1];
% 
% Kr = [2429.07884007142 0 1260.79059241961;
%     0 2395.89908692337 919.297173536795;
%     0 0 1];
% 
% %Extrinsics Test2
% R = [0.999974845437973 0.00152324010283433 -0.00692735381592019;
%     -0.00151467820170875 0.999998082790403 0.00124103402977067;
%     0.00692923092753410 -0.00123051010028269 0.999975235495183];
% 
% t = [0.00900244665216581;-0.000121551138686878;-0.000378623884487651];


% %Camera matrices
% Pl = NKl*[eye(3) zeros(3,1)];
% Pr = NKr*[NR t];

%match points
[ml,mr,er] = match(IL{i},IR{i});

%to homogeneous coordinates
m1 = [ml;ones(1,size(ml,2))];
m2 = [mr;ones(1,size(mr,2))];

% %Fundamental matrix from camera matrices
% F1 = (inv(Kr))'*star(t)*R*inv(Kl);

%Fundamental matrix from matlab
F2 = estimateFundamentalMatrix(ml',mr');

E = Kr'*F2*Kl;

% Ml = NormalizedCoordinates(m1,Kl);
% Ml = Ml(1:2,:);
% Mr = NormalizedCoordinates(m2,Kr);
% Mr = Mr(1:2,:);

% Sampson error
%Er = sampson(E,Ml,Mr);

% Pl = Kl*[eye(3) zeros(3,1)];%= Kl*[eye(3) t]*[[R zeros(3,1)];[0 0 0 1]];
% Pr = Kr*[R t];
% 
% Pplus = [inv(Kl); [0 0 0]];
% C = [0;0;0;1];
% 
% Ftrue = star(Pr*C)*Pr*Pplus;%(inv(Kr)')*R*(Kl')*star(Kl*R'*t);
% 
% % er = sampson(F,ml,mr);
% % ER = sampson(Ftrue,ml,mr);
% 
P = getCameraMatrix(E);

    for j=1:4
        r = vrrotmat2vec(P(:,1:3,j));
        r1 = vrrotmat2vec(-P(:,1:3,j));
        if abs(real(r(4)))<pi/2-0.01
            NewRot{i}=P(:,1:3,j);
        else
            if abs(real(r1(4)))<pi/2-0.01
                NewRot{i}=-P(:,1:3,j);
            end
        end
    end

% for j=1:4
%         r = vrrotmat2vec(P(:,1:3,j));
%         if 0.01<abs(real(r(4)))<pi/2-0.01
%             NewRot{i}=P(:,1:3,j);
%         else
%     
% end
    catch
    end
end

% % To check that angles are small
% for i = 2:numImages
% try
% u = vrrotmat2vec(NewRot{i});
% abs(real(u(4)))*180/pi
% catch
% end
% end

% %Rectification with F1
% cameraParams1 = cameraParameters('IntrinsicMatrix',Kl);
% cameraParams2 = cameraParameters('IntrinsicMatrix',Kr);
% stereoParams = stereoParameters(cameraParams1,cameraParams2,R,t);
% [Jl1,Jr1] = rectifyStereoImages(IL,IR, stereoParams,'OutputView','full');

% Rectification with F1
% [t1, t2] = estimateUncalibratedRectification(F1, ...
%   ml', mr', size(IR));
% tform1 = projective2d(t1);
% tform2 = projective2d(t2);
% I1Rect = imwarp(IL, tform1, 'OutputView', imref2d(size(IL)));
% I2Rect = imwarp(IR, tform2, 'OutputView', imref2d(size(IR)));
% pts1Rect = transformPointsForward(tform1, ml');
% pts2Rect = transformPointsForward(tform2, mr');
% figure;
% showMatchedFeatures(I1Rect, I2Rect, pts1Rect, pts2Rect);
% legend('Inlier points in rectified I1', 'Inlier points in rectified I2');

% %Rectification with F2
% stereoParams = stereoParameters(cameraParams1,cameraParams1,P(:,1:3,2),P(:,4,2));
% [Jl2,Jr2] = rectifyStereoImages(IL,IR, stereoParams);

% % %Rectification with F2
% [t1, t2] = estimateUncalibratedRectification(F2, ...
%   ml', mr', size(IR));
% tform1 = projective2d(t1);
% tform2 = projective2d(t2);
% I1RectT = imwarp(IL, tform1, 'OutputView', imref2d(size(IL)));
% I2RectT = imwarp(IR, tform2, 'OutputView', imref2d(size(IR)));
% pts1Rect = transformPointsForward(tform1, ml');
% pts2Rect = transformPointsForward(tform2, mr');
% figure;
% showMatchedFeatures(I1RectT, I2RectT, pts1Rect, pts2Rect);
% legend('Inlier points in rectified I1', 'Inlier points in rectified I2');
