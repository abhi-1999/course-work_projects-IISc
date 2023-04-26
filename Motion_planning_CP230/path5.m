function path5(GBur_start,GBur_goal,turn,points_ss,nearest_point_idx)
if turn == 1
    path_near_point_to_start = shortestpath(GBur_start,1,nearest_point_idx);
    node_data = zeros(size(path_near_point_to_start,2), 2);
    for i = 1:size(path_near_point_to_start,2)
        node_data(i,1) = GBur_start.Nodes.XData(path_near_point_to_start(i));
        node_data(i,2) = GBur_start.Nodes.YData(path_near_point_to_start(i));
    end
    if size(points_ss,1) == 1
        g_id = find_node_id(GBur_goal,points_ss(1,:));
        GBur_goal = flipedge(GBur_goal);
        path_to_goal = shortestpath(GBur_goal,g_id,1);
        for i=1:size(path_to_goal,2)
            j = size(node_data,1) + 1;
            node_data(j,1) = GBur_goal.Nodes.XData(path_to_goal(i));
            node_data(j,2) = GBur_goal.Nodes.YData(path_to_goal(i));
        end
    else
        for i = 1:size(points_ss,1) - 1
            j=size(node_data,1);
            node_data(j,1) = points_ss(i,1);
            node_data(j,2) = points_ss(i,2);
        end
        g_id = find_node_id(GBur_goal,points_ss(end,:));
        GBur_goal = flipedge(GBur_goal);
        path_to_goal = shortestpath(GBur_goal,g_id,1);
        for i =1:size(path_to_goal,2)
            j = size(node_data,1) + 1;
            node_data(j,1) = GBur_goal.Nodes.XData(path_to_goal(i));
            node_data(j,2) = GBur_goal.Nodes.YData(path_to_goal(i));
        end
    end
    
else
    s_id = find_node_id(GBur_start,points_ss(1,:));
    path_from_start = shortestpath(GBur_start,1,s_id);
    node_data = zeros(size(path_from_start,2),2);
    for i=1:size(path_from_start,2)
        node_data(i,1) = GBur_start.Nodes.XData(path_from_start(i));
        node_data(i,2) = GBur_start.Nodes.YData(path_from_start(i));
    end
    points_ss(1,:) = [];
    if ~isempty(points_ss)
        for i=1:size(points_ss,1)
            j = size(node_data,1) + 1;
            node_data(j,1) = points_ss(i,1);
            node_data(j,2) = points_ss(i,2);
        end
        GBur_goal = flipedge(GBur_goal);
        path_to_goal = shortestpath(GBur_goal,nearest_point_idx,1);
        for i=1:size(path_to_goal,2)
            j=size(node_data,1) + 1;
            node_data(j,1) = GBur_goal.Nodes.XData(path_to_goal(i));
            node_data(j,2) = GBur_goal.Nodes.YData(path_to_goal(i));
        end
    else
        GBur_goal = flipedge(GBur_goal);
        path_to_goal = shortestpath(GBur_goal,nearest_point_idx,1);
        for i=1:size(path_to_goal,2)
            j=size(node_data,1) + 1;
            node_data(j,1) = GBur_goal.Nodes.XData(path_to_goal(i));
            node_data(j,2) = GBur_goal.Nodes.YData(path_to_goal(i));
        end
    end
end
path_graph = digraph();
path_graph = addnode(path_graph,size(node_data,1));
path_graph.Nodes.XData(1:size(node_data,1)) = node_data(:,1);
path_graph.Nodes.YData(1:size(node_data,1)) = node_data(:,2);
for i = 1:size(node_data,1) - 1
    path_graph = addedge(path_graph,i,i+1);
end
darkmagenta = [139,0,139] /255;
chartreuse = [0,255,0] /255;
plot(GBur_start, 'XData', GBur_start.Nodes.XData, 'YData', GBur_start.Nodes.YData,'NodeColor',darkmagenta,'EdgeColor',darkmagenta);
plot(GBur_goal,'XData',GBur_goal.Nodes.XData,'YData',GBur_goal.Nodes.YData,'NodeColor','r','EdgeColor','r');
p = plot(path_graph,'XData',path_graph.Nodes.XData,'YData',path_graph.Nodes.YData);
sht_path = shortestpath(path_graph,1,numnodes(path_graph));
highlight(p,sht_path,'LineWidth', 2, 'EdgeColor', chartreuse);
end

