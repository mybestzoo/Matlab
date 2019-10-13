%   PRECOND2 Normalize the coordinates of a 2D point set. 
%
%   [S,mo] = PRECOND(m) scale and translate the 2D point coordinates so that
%   the barycenter is in origin and the average radius  is sqrt(2)
%   Algorithm ref.: Hartley
%   Author: A. Fusiello  (adapted from original code by C. Plakas)

function [S,mo] = precond2(m)

[rm2,cm2]=size(m);
if (rm2 ~= 2)
    error('Le coordinate immagine devono essere cartesiane!!');
end

u1=m(1,:)';
v1=m(2,:)';

n_points = size(u1,1);

if n_points > 1

avgx1 = (sum(u1)/n_points);
avgy1 = (sum(v1)/n_points);

u1 = u1 - avgx1;
v1 = v1 - avgy1;

tscale1 = sum(sqrt(u1.^2 + v1.^2))/n_points/sqrt(2);

u1 = u1/tscale1;
v1 = v1/tscale1;

S = [1/tscale1 0 -avgx1/tscale1; 
     0 1/tscale1 -avgy1/tscale1; 
     0       0          1];
mo = [u1';v1'];

else
  % it does not make sense to normalize 1 single point.
  
  mo = m;
  S = eye(3);
end

% end of scaling