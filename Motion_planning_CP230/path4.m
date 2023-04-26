function  path4(GBur_goal,GBur_start,points_ss,map)
darkmagenta = [139,0,139] /255;
chartreuse = [0,255,0] /255;
plot(GBur_start, 'XData', GBur_start.Nodes.XData, 'YData', GBur_start.Nodes.YData,'NodeColor',darkmagenta,'EdgeColor',darkmagenta);
plot(GBur_goal,'XData',GBur_goal.Nodes.XData,'YData',GBur_goal.Nodes.YData,'NodeColor',chartreuse,'EdgeColor',chartreuse);

%STEP1 flip all the edges of GBur_goal
GBur_goal = flipedge(GBur_goal);

%STEP2 connect all nodes if direct path exist
shawty = GBur_start;
num_GBur_start_nodes = numnodes(GBur_start);
num_GBur_goal_nodes = numnodes(GBur_goal);
bef = numnodes(shawty);
shawty = addnode(shawty,num_GBur_goal_nodes);
edge_data = table2array(GBur_goal.Edges);
node_data = table2array(GBur_goal.Nodes);
shawty.Nodes.XData(bef+1:numnodes(shawty)) = node_data(:,1);
shawty.Nodes.YData(bef+1:numnodes(shawty)) = node_data(:,2);

for i = 1:size(edge_data,1)
    p = edge_data(i,1) + num_GBur_start_nodes;
    q = edge_data(i,2) + num_GBur_start_nodes;
    if isempty(shortestpath(shawty,p,q))
        shawty = addedge(shawty,p,q);
    end
end

if ~isempty(points_ss)
    e = numnodes(shawty);
    p=e+1;
    shawty = addnode(shawty,size(points_ss,1));
    for i = 1:size(points_ss,1) - 1
        shawty = addedge(shawty,p,p+1);
        p=p+1;
    end
end

source = find_node_id(shawty,[GBur_start.Nodes.XData(1) GBur_start.Nodes.YData(1)]);
target = find_node_id(shawty,[GBur_goal.Nodes.XData(1) GBur_goal.Nodes.YData(1)]);
path = shortestpath(shawty, source, target);

for i = 1:numnodes(shawty) - 1
    p1=[shawty.Nodes.XData(i) shawty.Nodes.YData(i)];
    for j =i+1:numnodes(shawty)
        if i ~= j 
            p2 = [shawty.Nodes.XData(j) shawty.Nodes.YData(j)];
            if isempty(polyxpoly(map.obsx,map.obsy,[p1(1),p2(1)],[p1(2),p2(2)]))
                if isempty(shortestpath(shawty, i, j))
                    shawty = addedge(shawty,i,j);
                end
            end
        end
    end
end
point=[];
for i = 1:size(path,1)
    node_id = path(i);
    x_c = shawty.Nodes.XData(node_id);
    y_c = shawty.Nodes.YData(node_id);
    p = [x_c y_c];
    point = [point;p];
end

for i = 1:size(point,1) - 1
    x = [point(i,1) point(i+1,1)];
    y = [point(i,2) point(i+1,2)];
    plot(x,y,'r-','LineWidth',2);
    hold on;
end
end
