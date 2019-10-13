function nx = NormalizedCoordinates(x,k);
% Convert a point to normalized coordinates.

nx = inv(k) * x;