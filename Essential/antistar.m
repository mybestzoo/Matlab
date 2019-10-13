function  x = antistar(X)
%AntiSTAR Return the vector x from swe-symmetric matrix X

% The name is after the Hodge star operator, of which this is an instance.

%    Author: Tigran Bagramyan 

x = [X(3,2) X(1,3) X(2,1)];
