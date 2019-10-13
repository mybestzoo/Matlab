clc; clear;

numImages =1;

NewRot = cell(1,numImages);
NewRotK = cell(1,numImages);

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

% % Intrinsics Test4
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

%% For each frame
for i = 1:numImages
    i
    
 RepK(i)=10;
        
% % Read images    
% IL = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test4\DB1', sprintf('left%03d.jpg', i)));
% IR = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test4\DB1', sprintf('right%03d.jpg', i)));

IL = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test5\S9\Left', sprintf('Image%02d.bmp', i)));
IR = imread(fullfile('C:\Users\t.bagramyan\Desktop\Test5\S9\Right', sprintf('Image%02d.bmp', i)));


%match points
[ml,mr,out_num(i)] = match(IL,IR);

numpts(i) = size(ml,2);

j=0;
while (RepK(i) > 3) & (j<100)
%split matched points into training and test set
idx = randMix(size(ml,2));

trainl = ml(:,idx(1:ceil(size(idx,1))));
trainr = mr(:,idx(1:ceil(size(idx,1))));

testl = ml(:,idx(1:ceil(size(idx,1))));
testr = mr(:,idx(1:ceil(size(idx,1))));

% trainl = ml(:,idx(1:ceil(0.7*size(idx,1))));
% trainr = mr(:,idx(1:ceil(0.7*size(idx,1))));
% 
% testl = ml(:,idx(ceil(0.7*size(idx,1)):end));
% testr = mr(:,idx(ceil(0.7*size(idx,1)):end));

% Rotation matrix from Kalman filter
[RotKalman{i}] = RotK(trainl,trainr,Kl,Kr,floor(size(trainl,2)/10));
[RepK(i) xhat{i} xphat{i}] = reprojection_error(testl,testr,Kl,Kr,RotKalman{i},t);
J(i) = j;
j=j+1;
end

[Rep(i) xhat{i} xphat{i}] = reprojection_error(testl,testr,Kl,Kr,Rotation,t);   

clearvars ml mr trainl trainr testl testr
end

h=cdfplot(Rep);
set(h,'color','r')
hold on;
h=cdfplot(RepK);
hold off
set(h,'color','g')

 

%% Plot

for i=1:numImages 
%     try
%     NewRot{i}=reshape(NewRot{i}',9,1);
%     NewRotK{i}=reshape(NewRotK{i}',9,1);
    NewRotKalman{i} = reshape(RotKalman{i}',9,1);
%     catch
%     end
end
% NewRot = cell2mat(NewRot);
% NewRotK = cell2mat(NewRotK);
NewRotKalman = cell2mat(NewRotKalman);

figure;
plot(1:numImages,Rep,'red',1:numImages,RepK,'green')

numpts = numpts';
RepK = RepK';
Rep = Rep';

for i=1:numImages
   e = vrrotmat2vec(RotKalman{i});
   angle(i) = e(4);
   angle(i) = angle(i)*180/pi;
end