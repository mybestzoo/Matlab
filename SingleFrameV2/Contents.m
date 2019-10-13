% DC SINGLE
%
% Files
%   antistar           - AntiSTAR Return the vector x from swe-symmetric matrix X
%   dbscan             - clustering
%   DCSingle           - The main script DCSIngle.m
%   distance           - Euclidean distance matrix between row vectors in X and Y
%   fm                 - Computes fundamental matrix from point correspondences.
%   getCameraMatrix    - Given an essential matrix, compute the second camera matrix
%   KF                 - Kalman Filter
%   match              - Matches features on the left and right images.
%   ns                 - Solve the null-space problem A*v=0 
%   OutliersDBSCAN     - OutliersDBSCAN uses DBSCAN algorithm to detect outliers in the set of matched features and delete them
%   poldec             - Polar decomposition.
%   precond2           - Normalize the coordinates of a 2D point set. 
%   randMix            - randomly mixes integers in interval (1,x)  
%   reprojection_error - Calculates the re-projection error for a given set of matched features and stereo camera parameters
%   RotK               - Calculates the rotation matrix through n iterations of Kalman filter
%   Triangulation      - Find Point in 3D space from given x1,P1,x2,P2
%   TuneP              - 
