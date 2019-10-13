function [Rot] = RotK(ml,mr,Kl,Kr,n)
%estimates rotation matrix through n iterations of Kalman filter 

%% Define the parameters for the Kalman filter
q = 0;    %std of process 
r = 0.5*eye(9); %std of measurement
Q = q^2*eye(9); % covariance of process
R = r^2*eye(9);        % covariance of measurement  
x = [1;0;0;0;1;0;0;0;1];   % initial state
P = eye(9);                 % initial state covariance

s = size(ml,2);

%%
for i=1:n
% fundamental matrix

F = fm(ml(:,floor((i-1)*s/n)+1:floor(i*s/n)),mr(:,floor((i-1)*s/n)+1:floor(i*s/n)));

% essential matrix
E = Kr'*F*Kl;

% rotation matrix
U = getCameraMatrix(E);

    for j=1:4
        r = vrrotmat2vec(U(:,1:3,j));
        r1 = vrrotmat2vec(-U(:,1:3,j));
        if abs(real(r(4)))<pi/2-0.01
            NR=U(:,1:3,j);
        else
            if abs(real(r1(4)))<pi/2-0.01
                NR=-U(:,1:3,j);
            end
        end
    end    
    
% Estimate the rotation matrix with Kalman filter
    [x, P] = KF(x,P,reshape(NR',9,1),Q,R);  
  
Rot = (reshape(x,[3,3]))';
[U,H] = poldec(Rot);
Rot = U;
x = reshape(Rot',9,1);

NR = eye(3);
end



