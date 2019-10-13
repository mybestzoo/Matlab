function  [errP xhat xphat] = reprojection_error(ml,mr,Kl,Kr,Rot,t)
%Reprojection error by Tigran

% %Camera matrices
Pl = Kl*[eye(3) zeros(3,1)];
Pr = Kr*[Rot t];

%to homogeneous coordinates
m1 = [ml;ones(1,size(ml,2))];
m2 = [mr;ones(1,size(mr,2))];

[errP xhat xphat] = TuneP(m1,Pl,m2,Pr);

% Ml = NormalizedCoordinates(m1,Kl);
% Mr = NormalizedCoordinates(m2,Kr);
% %[XL,XR] = stereo_triangulation(Ml,Mr,Rotation,t);
% [XL,XR] = stereo_triangulation(Ml,Mr,Rot,t);
% 
% %to homogeneous coordinates
% XL = [XL;ones(1,size(XL,2))];
% XR = [XR;ones(1,size(XR,2))];
% 
% % project point to image planes
% xL = Pl*XL;
% xR = Pr*XR;
% 
% %to image coordinates
% for j=1:size(xL,2)
% xl(1:2,j) = xL(1:2,j)./xL(3,j);
% xr(1:2,j) = xR(1:2,j)./xR(3,j);
% end
% 
% ml = ml(:,~all(isnan(xl)));
% mr = mr(:,~all(isnan(xr)));
% xl = xl(:,~all(isnan(xl)));
% xr = xr(:,~all(isnan(xr)));
% 
% for j=1:size(xl,2)
% erL(j) = norm(xl(:,j)-ml(:,j));
% erR(j) = norm(xr(:,j)-mr(:,j));
% end
% 
% ErL = prctile(erL,90);
% ErR = prctile(erR,90);    