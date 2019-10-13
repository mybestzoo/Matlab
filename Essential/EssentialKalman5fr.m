clc; clear;

numImages = 31;

% IL  = cell(1, numImages);
% IR = cell(1, numImages);
NewRot = cell(1,numImages);
NewRotK = cell(1,numImages);
xhat = cell(1,numImages);
xphat = cell(1,numImages);

%% Define the parameters for the Kalman filter
n = 9;      %number of state
q = 0;    %std of process 
r = 0.5*eye(n);
%         [1 0 0 0 0 0 0 0 0;
%          0 1 0 -1 0 0 0 0 0;
%          0 0 1 0 0 0 -1 0 0;
%          0 -1 0 1 0 0 0 0 0;
%          0 0 0 0 1 0 0 0 0;
%          0 0 0 0 0 1 0 -1 0;
%          0 0 -1 0 0 0 1 0 0;
%          0 0 0 0 0 -1 0 1 0;
%          0 0 0 0 0 0 0 0 1];    %std of measurement
Q = q^2*eye(n); % covariance of process
R = r^2*eye(n);        % covariance of measurement  
x = [1;0;0;0;1;0;0;0;1];   % initial state
P = eye(n);                 % initial state covariance

%% Camera parameters

%Intrinsics Test5
Kl = [3719.12627173031	0	2099.67059752486
0	3713.18468906399	1605.78924134568
0	0	1];

Kr = [3739.5834009773	0	1991.18986929934
0	3731.80899871702	1615.03211435572
0	0	1];

Rotation = [0.999949511698946	0.00645326548363432	0.00770255916153678
-0.00647340166692713	0.999975687599592	0.00259215751495502
-0.00768564401321486	-0.00264188840064196	0.999966975105569];

t = [-2.01809385808418;-0.0156363236241457;0.0543506446590409];

% %Intrinsics Test4
% Kl = [2407.31101717679 0 1250.92521869510;
%     0 2374.25307552955 945.268260157380;
%     0 0 1];
% 
% Kr = [2403.94599485891 0 1228.28492485050;
%     0 2371.08293885476 957.423719581872;
%     0 0 1];
% 
% Rotation = [0.999977091464914	-0.00659793031826681	0.00151124481362796;
% 0.00661321604403151	0.999924636471947	-0.0103434399500273;
% -0.00144288562484558	0.0103531971854182	0.999945363201967];
% 
% t = [0.00880714055631570;-9.25243559905784e-05;-0.000579473253163979];

% %Intrinsics Test3
% Kl = [3700.82892306015 0 2214.70983479010;
%     0 3704.67628906163 1609.70890674429;
%     0 0 1];
% 
% Kr = [3728.24007153751 0 2113.44365959795;
%     0 3729.89267149350 1658.71651579994;
%     0 0 1];
% 
% Rotation = [0.999755884799654	0.00576021325556484	-0.0213305122233765;
% -0.00593532775294702	0.999949129465737	-0.00815538872028626;
% 0.0212824503506128	0.00828000144711887	0.999739215437261];
% 
% t = [-0.0193201564283955;0.000137894249766687;0.000162530467599130];
 
% %Intrinsics Test2
% Kl = [2433.97387923278 0 1284.63040068900;
%     0 2400.57991882680 908.786317866895;
%     0 0 1];
% 
% Kr = [2429.07884007142 0 1260.79059241961;
%     0 2395.89908692337 919.297173536795;
%     0 0 1];
% 
% Rotation = [0.999974845437973 0.00152324010283433 -0.00692735381592019;
%     -0.00151467820170875 0.999998082790403 0.00124103402977067;
%     0.00692923092753410 -0.00123051010028269 0.999975235495183];
% 
% t = [0.00900244665216581;-0.000121551138686878;-0.000378623884487651];

% %Intrinsics Test1
% Kl = [3563.81960631745 0 2072.53810343332;
%     0 3555.72424035662 1605.78413835625;
%     0 0 1];
% 
% Kr = [3559.71568034640 0 2056.99098670246;
%     0 3551.96607792039 1554.05875312707;
%     0 0 1];
% 
% Rotation = [0.999972208248178 -0.00634243641740709	0.00391870278982295;
% 0.00635266450366869	0.999976433331935	-0.00260315855200490;
% -0.00390210007145457	0.00262798040978176	0.999988933605767];
% 
% t = [0.171749801222083;-20.0092992115696;0.0750848505712130];

tic
%% For each frame
for i = 1:numImages
%     try
%     try
        
% Read images    
IL = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test5\S9\Left', sprintf('Image%02d.bmp', i)));
IR = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test5\S9\Right', sprintf('Image%02d.bmp', i)));

% IL = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test4\DB1', sprintf('left0%02d.jpg', i)));
% IR = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test4\DB1', sprintf('right0%02d.jpg', i)));

tic

%match points
[ml,mr] = match(IL,IR);

matchTime(i) = toc;

numpts(i) = size(ml,2);

%to homogeneous coordinates
% m1 = [ml;ones(1,size(ml,2))];
% m2 = [mr;ones(1,size(mr,2))];

% %Fundamental matrix from camera matrices
% F1 = (inv(Kr))'*star(t)*Rotation*inv(Kl);

%Fundamental matrix from matlab
try
F2 = fm(ml,mr);%,'Method', 'RANSAC', 'NumTrials', 2000, 'DistanceThreshold', 1e-4);
catch
end
% i1 = ml(:,inliers);
% i2 = mr(:,inliers);
    
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
U = getCameraMatrix(E);

    for j=1:4
        r = vrrotmat2vec(U(:,1:3,j));
        r1 = vrrotmat2vec(-U(:,1:3,j));
        if abs(real(r(4)))<pi/2-0.01
            NewRot{i}=U(:,1:3,j);
        else
            if abs(real(r1(4)))<pi/2-0.01
                NewRot{i}=-U(:,1:3,j);
            end
        end
    end
    
% Estimate the rotation matrix with Kalman filter
    [x, P] = KF(x,P,reshape(NewRot{i}',9,1),Q,R);       %KF
    NewRotK{i} = (reshape(x,[3,3]))';
    
    time(i) = toc;
  
    %% Triangulation and reprojection error
[RepK(i) xhat{i} xphat{i}] = reprojection_error(ml,mr,Kl,Kr,NewRotK{i},t);
[Rep(i) xhat{i} xphat{i}] = reprojection_error(ml,mr,Kl,Kr,Rotation,t);   
[RepM(i) xhat{i} xphat{i}] = reprojection_error(ml,mr,Kl,Kr,NewRot{i},t); 

% cdfplot
cdfplot(Rep)
hold on;
h=cdfplot(RepK);
hold off
set(h,'color','g')
hold on;
g=cdfplot(RepM);
hold off
set(g,'color','r')

% show re=projected points
% showMatchedFeatures(IL{i},IL{i},ml',xhat{i}(1:2,:)');

% plot

% end
%     catch
%     end
%     catch
%     end
    
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

for i=1:numImages 
    try
    NewRot{i}=reshape(NewRot{i}',9,1) ;
    NewRotK{i}=reshape(NewRotK{i}',9,1) ;
    catch
    NewRot{i}=zeros(9,1);
    NewRotK{i}=zeros(9,1);
    end
end
NewRot = cell2mat(NewRot);
NewRotK = cell2mat(NewRotK);

figure;
subplot(3,3,1)
plot(1:numImages, NewRot(1,:),'-',1:numImages,NewRotK(1,:),'--');line(xlim,[Rotation(1,1) Rotation(1,1)],'Color','r');
subplot(3,3,2)
plot(1:numImages, NewRot(2,:),'-',1:numImages,NewRotK(2,:),'--');line(xlim,[Rotation(1,2) Rotation(1,2)],'Color','r');
subplot(3,3,3)
plot(1:numImages, NewRot(3,:),'-',1:numImages,NewRotK(3,:),'--');line(xlim,[Rotation(1,3) Rotation(1,3)],'Color','r');
subplot(3,3,4)
plot(1:numImages, NewRot(4,:),'-',1:numImages,NewRotK(4,:),'--');line(xlim,[Rotation(2,1) Rotation(2,1)],'Color','r');
subplot(3,3,5)
plot(1:numImages, NewRot(5,:),'-',1:numImages,NewRotK(5,:),'--');line(xlim,[Rotation(2,2) Rotation(2,2)],'Color','r');
subplot(3,3,6)
plot(1:numImages, NewRot(6,:),'-',1:numImages,NewRotK(6,:),'--');line(xlim,[Rotation(2,3) Rotation(2,3)],'Color','r');
subplot(3,3,7)
plot(1:numImages, NewRot(7,:),'-',1:numImages,NewRotK(7,:),'--');line(xlim,[Rotation(3,1) Rotation(3,1)],'Color','r');
subplot(3,3,8)
plot(1:numImages, NewRot(8,:),'-',1:numImages,NewRotK(8,:),'--');line(xlim,[Rotation(3,2) Rotation(3,2)],'Color','r');
subplot(3,3,9)
plot(1:numImages, NewRot(9,:),'-',1:numImages,NewRotK(9,:),'--');line(xlim,[Rotation(3,3) Rotation(3,3)],'Color','r');
