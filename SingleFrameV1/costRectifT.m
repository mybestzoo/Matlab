function err  = costRectifT(a,w,h,ml,mr) ;
%costRectif  Compute rectification cost
%
% a is a vector of four elements containing the independent
% variables of the cost function, i.e, three rotation angles
% (X-right, Y-right, Z-right) and the focal
% lenght.
% w,h are the image width and height, respectively.
% m1,m2 are the corresponding image points.

% Author: T. Bagramyan, 2015

% recover parameters
yl=a(1); zl=a(2); xr=a(3);
yr=a(4); zr=a(5); f =3^a(6)*(w+h);

% estimate of the intrinsic parameters of the old cameras
Kol = [f, 0, w/2;  0, f, h/2; 0, 0, 1];
Kor = Kol;

% eulR applies rotations in the order Y-Z-X
Rl = eulR([0,yl,zl]);
Rr = eulR([xr,yr,zr]);

% fundamental matrix btw original points
F = inv(Kor)'*Rr'*star([1 0 0])*Rl*inv(Kol);

% compute Sampson error
 err = sqrt(sampson(F,ml,mr));






