
function closestPt = closest_point_on_edge(pt, v1, v2)
% Finds the closest point on the line segment defined by two endpoints v1 and v2 to a given point pt.

% vector from v1 to v2
v = v2 - v1;

% vector from v1 to pt
w = pt - v1;

% projection of w onto v
c = dot(w,v) / norm(v)^2;

% closest point on the line segment to pt 
if c <= 0
    closestPt = v1;
elseif c >= 1
    closestPt = v2;
else
    closestPt = v1 + c*v;
end

end