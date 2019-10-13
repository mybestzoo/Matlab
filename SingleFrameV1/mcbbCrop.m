
function bb = mcbbCrop(s1,s2,H1,H2)
% MCBB minimum common bounding box

% bb is the bounding box given as [minx; miny; maxx; maxy];
% s1 is the result of size(I1)
% s2 is the result of size(I2)


corners = [0, 0, s1(2), s1(2);
           0, s1(1), 0, s1(1)];
corners_x = p2t(H1,corners);

minx = ceil(max(corners_x(1,1:2)));
maxx = floor(min(corners_x(1,3:4)));
miny = ceil(max([corners_x(2,1),corners_x(2,3)]));
maxy = floor(min([corners_x(2,2),corners_x(2,4)]));

bb1 = [minx; miny; maxx; maxy];

corners = [0, 0, s2(2), s2(2);
           0, s2(1), 0, s2(1)];
corners_x = p2t(H2,corners);

corners_x1 = [corners_x(:,1:2)];
corners_x2 = [corners_x(:,3:4)];

minx = ceil(max(corners_x(1,1:2)));
maxx = floor(min(corners_x(1,3:4)));
miny = ceil(max([corners_x(2,1),corners_x(2,3)]));
maxy = floor(min([corners_x(2,2),corners_x(2,4)]));

bb2 = [minx; miny; maxx; maxy];


q1 = max([bb1';bb2']);
q2 = min([bb1';bb2']);
bb =[q1(1:2),q2(3:4)];
