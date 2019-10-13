function [Hl Hr] = compRecOne(ml,mr,width,height,cntr)
%compRectif compute the rectifying transformations
%
% Hl,Hr are the collineations that rectify the left and right images
% respectively
%
% ml,mr are coresponding point in the images 
%
% width, height are the dimensions of the image (used to imfer the focal
% and the image centre)

a0 = [0 0 0 0 0 0];
af = fminsearch(@(x) norm(costRectifT(x,width,height,ml,mr))^2, a0);

yl=af(1);
zl=af(2);
xr=af(3);
yr=af(4);
zr=af(5);
f =3^af(6)*(width+height);

% old intrinsics
Kol = [f, 0, width/2;
    0, f, height/2;
    0, 0, 1];

Kor = Kol;

% rotations
Rl = eulR([0,yl,zl]);
Rr = eulR([xr,yr,zr]);

% fundamental matrix btw original points
F = inv(Kor)'*Rr'*star([1 0 0])*Rl*inv(Kol);

% new intrinsics: arbitrary
Knl = Kol;
Knr = Kor;

% compute collineations
Hr = Knr*Rr*inv(Kor);
Hl = Knl*Rl*inv(Kol);

