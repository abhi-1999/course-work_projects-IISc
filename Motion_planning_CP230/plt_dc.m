function  plt_dc(q,map,pid,idx,min_d)
%to plot the shortest distance
% find the closest point on the polygon edge
closestPt = closest_point_on_edge(q, map.poly{pid}(idx,:), map.poly{pid}(idx+1,:));

disp(['The shortest distance from the point to the polygon is ', num2str(min_d)]);

% plot the polygon and the point
figure;
hold on;
%plot(poly(:,1),poly(:,2),'b');

plot(q(1),q(2),'r.','MarkerSize',20);

% plot the closest point on the polygon
plot(closestPt(1),closestPt(2),'g.','MarkerSize',20);

% plot a line connecting the point to the closest point on the polygon
plot([pt(1),closestPt(1)],[pt(2),closestPt(2)],'m--');

% adjust the axes and legend
axis equal;
legend('Point','Closest point','Shortest distance');


