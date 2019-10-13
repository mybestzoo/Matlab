% Calculates the re-projection error for a given set of matched features and stereo camera parameters
% Input - matrices of coordinates of matched features ml,mr; Intrinsic camera parameters Kl,Kr; Extrinsic camera parameters Rot,t
% Output - re-projectione error errP 
% Author: Tigran Bagramyan

function  [errP] = reprojection_error(ml,mr,Kl,Kr,Rot,t)

% %Camera matrices
Pl = Kl*[eye(3) zeros(3,1)];
Pr = Kr*[Rot t];

%to homogeneous coordinates
m1 = [ml;ones(1,size(ml,2))];
m2 = [mr;ones(1,size(mr,2))];

[errP xhat xphat] = TuneP(m1,Pl,m2,Pr);