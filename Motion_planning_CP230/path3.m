function path3(GBur_start,GBur_goal,turn,points_ss,nearest_point_idx);
    


%     shawty = copy(GBur_start);
    shawty = GBur_start;
    num_GBur_start_nodes = numnodes(GBur_start);
    num_GBur_goal_nodes = numnodes(GBur_goal);
    bef = numnodes(shawty);
    shawty = addnode(shawty,num_GBur_goal_nodes);
    edge_data = table2array(GBur_goal.Edges);
    node_data = table2array(GBur_goal.Nodes);
    for i = 1:size(edge_data,1)
        p = edge_data(i,1) + num_GBur_start_nodes;
        q = edge_data(i,2) + num_GBur_start_nodes;
        shawty = addedge(shawty,p,q);
    end

    shawty.Nodes.XData(bef+1:numnodes(shawty)) = node_data(:,1);
    shawty.Nodes.YData(bef+1:numnodes(shawty)) = node_data(:,2);
    
    
    if turn ==1 
        new_nearest_point_idx = find_node_id(shawty,[GBur_start.Nodes.XData(nearest_point_idx) GBur_start.Nodes.YData(nearest_point_idx)]);
        idx = find_node_id(shawty,points_ss(1,:));
        if size(points_ss,1) == 1
            shawty = addedge %THIS LOGIC NOT WORKING since directed edges we need reverse order

        else
            try
                points_ss(1,:) = [];
            catch
                disp("fuck");
            end
            if size(points_ss,1) ~= 0
                e = numnodes(shawty);
                shawty = addnode(shawty,size(points_ss,1));
                shawty.Nodes.XData(e+1:numnodes(shawty)) = points_ss(:,1);
                shawty.Nodes.YData(e+1:numnodes(shawty)) = points_ss(:,2);
                shawty = addedge(shawty,idx,e+1);
                shawty = addedge(shawty,new_nearest_point_idx,numnodes(shawty));
                
                if size(points_ss,1) ~= 1
                    j=e+1;
                    for i = 1:size(points_ss,1) -1
                        shawty =addedge(shawty,j,j+1);
                    end
                end
            end
         end
        

    else
        new_nearest_point_idx = find_node_id(shawty,[GBur_goal.Nodes.XData(nearest_point_idx) GBur_goal.Nodes.YData(nearest_point_idx)]);
        idx = find_node_id(shawty,points_ss(1,:));
        try
            points_ss(1,:) = [];
        catch
            disp("fuck");
        end
        if size(points_ss,1) ~= 0
            e = numnodes(shawty);
            shawty = addnode(shawty,size(points_ss,1));
            shawty.Nodes.XData(e+1:numnodes(shawty)) = points_ss(:,1);
            shawty.Nodes.YData(e+1:numnodes(shawty)) = points_ss(:,2);
            shawty = addedge(shawty,new_nearest_point_idx,numnodes(shawty));
            shawty = addedge(shawty,idx,e+1);
             if size(points_ss,1) ~= 1
                    j=e+1;
                    for i = 1:size(points_ss,1) -1
                        shawty =addedge(shawty,j,j+1);
                    end
             end
        end
    end
    source = find_node_id(shawty,[GBur_start.Nodes.XData(1) GBur_start.Nodes.YData(1)]);
    target = find_node_id(shawty,[GBur_goal.Nodes.XData(1) GBur_goal.Nodes.YData(1)]);
    % Find the shortest path between source and target nodes
    path = shortestpath(shawty, source, target);
    p=plot(shawty,'XData',shawty.Nodes.XData,'YData',shawty.Nodes.YData,'NodeColor','b','EdgeColor','y');
    % Highlight the shortest path 
    highlight(p, path, 'LineWidth', 2, 'EdgeColor', 'k');
end




