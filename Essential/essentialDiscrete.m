%  p are homogenius coordinates of the first image of size 3 by n
%  q are homogenius coordinates of the second image of size 3 by n

function [E]  = essentialDiscrete(p,q)

n = size(p);
NPOINTS = n(2);

% set up matrix A such that A*[v1,v2,v3,s1,s2,s3,s4,s5,s6]' = 0
A = zeros(NPOINTS, 9);

if NPOINTS < 9
     error('Too few mesurements')
     return;
end

for i = 1:NPOINTS
  A(i,:) = kron(p(:,i),q(:,i))';
end
r = rank(A);

if r < 8 
  warning('Measurement matrix rank defficient')
  T0 = 0; R = [];
end;

[U,S,V] = svd(A);

% pick the eigenvector corresponding to the smallest eigenvalue
e = V(:,9);
e = (round(1.0e+10*e))*(1.0e-10);
% essential matrix 
E = reshape(e, 3, 3);