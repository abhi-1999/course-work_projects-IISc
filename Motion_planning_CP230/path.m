function path(GBur_start,GBur_goal,turn,points_ss,nearest_point_idx)

if turn == 1 
    %STEP1 ---> add the path from root to the nearest point to a new graph
    pred_list = nearest_point_idx;
    cur_par_id=nearest_point_idx;
    node_data = GBur_start.Nodes(cur_par_id,:);
    while true
        parent = predecessors(GBur_start,cur_par_id);
        if ~isempty(parent)
            cur_par_id = parent(1);
            node_data(end+1,:)=GBur_start.Nodes(cur_par_id,:);
            pred_list=[pred_list;cur_par_id];
        else
            break
        end 
    end
    if size(node_data,1) ~= 1
        node_data = flip(node_data);
    end
    pred_list = flip(pred_list);
   if size(points_ss,1) ~= 1
       points_ss = flip(points_ss);
   end
    
    path_graph = digraph();
    path_graph = addnode(path_graph,size(pred_list,1));
    for i =1:size(pred_list,1)-1
        path_graph = addedge(path_graph,i,i+1);
    end
    path_graph.Nodes = node_data;
    
    
    
    %STEP2 ---> add the points from single spine (points_ss) to path_graph
    num_points_ss = size(points_ss,1);
    num_nodes = numnodes(path_graph);
    path_graph = addnode(path_graph,num_points_ss);  %add node to path_graph
    
    %store the data into the nodes added
    path_graph.Nodes.XData(num_nodes+1:numnodes(path_graph)) = points_ss(:,1);
    path_graph.Nodes.YData(num_nodes+1:numnodes(path_graph)) = points_ss(:,2);
    
    %add edges to the newly added nodes
    j=num_nodes;
    if size(points_ss,1) == 1
        path_graph = addedge(path_graph,num_nodes,num_nodes+1);
    else
        for i=1:num_points_ss
            path_graph=addedge(path_graph,j,j+1);
            j=j+1;
        end
    end
    
    %STEP 3 --->now add the path from last point in points_ss to goal
    cur_par_id = find_node_id(GBur_goal,points_ss(end,:));
    node_data = GBur_goal.Nodes(cur_par_id,:);
    while true
        parent = predecessors(GBur_goal,cur_par_id);
        if ~isempty(parent)
            cur_par_id = parent(1);
            node_data(end+1,:) = GBur_goal.Nodes(cur_par_id,:);
        else
            break
        end 
    end
    %node_data = flip(node_data);
    
    %remove the first element from above since it is already in path_graph
    node_data(1,:) =[];
    
    e =numnodes(path_graph);
    path_graph = addnode(path_graph,size(node_data,1));
    
    %store the data into the nodes added
    
    j=e+1;
    for i = 1:size(node_data,1)
        path_graph.Nodes.XData(j) = node_data.XData(i);
        path_graph.Nodes.YData(j) = node_data.YData(i);
        path_graph = addedge(path_graph,e,j);
        e = j;
        j= j+1;
    end
    

else
    %STEP1 --->make path from root of GBur_start to first point in point_ss 
    cur_node = find_node_id(GBur_start,points_ss(1,:)); %first point in points_ss will be the goal 
    node_data = GBur_start.Nodes(cur_node,:);
    pred_list = cur_node;
    while true
        try
            parent = predecessors(GBur_start,cur_node);
        catch
            disp("wtf");
        end
        if ~isempty(parent)
            cur_node = parent(1);
            node_data(end+1,:) = GBur_start.Nodes(cur_node,:);
            pred_list = [pred_list; cur_node];
        else
            break
        end
    end
    if size(node_data,1) ~= 1
        node_data = flip(node_data);
    end
    pred_list = flip(pred_list);
    try
        points_ss(1,:) = [];
    catch
        disp("cmon");
    end

    path_graph = digraph();
    path_graph = addnode(path_graph,size(pred_list,1));
    for i =1:size(pred_list,1)-1
        path_graph = addedge(path_graph,i,i+1);
    end
    path_graph.Nodes = node_data;
    
    %STEP2--->add points in points_ss to path graph

    num_points_ss = size(points_ss,1);
    num_nodes = numnodes(path_graph);
    path_graph = addnode(path_graph,num_points_ss);  %add node to path_graph
    
    %store the data into the nodes added
    path_graph.Nodes.XData(num_nodes+1:numnodes(path_graph)) = points_ss(:,1);
    path_graph.Nodes.YData(num_nodes+1:numnodes(path_graph)) = points_ss(:,2);

    %add edges to the newly added nodes
    j=num_nodes;
    if ~isempty(points_ss)
        for i=1:num_points_ss
            path_graph=addedge(path_graph,j,j+1);
            j=j+1;
        end
    end
    
    %STEP3---> add path from nearest_idx to goal
    pred_list = nearest_point_idx;
    cur_par_id=nearest_point_idx;
    node_data = GBur_goal.Nodes(cur_par_id,:);
    while true
        try
            parent = predecessors(GBur_goal,cur_par_id);
        catch
            disp("fvck");
        end
        if ~isempty(parent)
            cur_par_id = parent(1);
            node_data(end+1,:)=GBur_goal.Nodes(cur_par_id,:);
            pred_list=[pred_list;cur_par_id];
        else
            break;
        end 
    end
    node_data = table2array(node_data);
    node_add = size(node_data,1);
    num_nodes = numnodes(path_graph);

    path_graph = addnode(path_graph,node_add);

    path_graph.Nodes.XData(num_nodes+1:numnodes(path_graph)) = node_data(:,1);
    path_graph.Nodes.YData(num_nodes+1:numnodes(path_graph)) = node_data(:,2);

  
    for i = num_nodes:numnodes(path_graph)-1
        path_graph = addedge(path_graph,i,i+1);
    end
end
%PLOT
    source = find_node_id(path_graph,[GBur_start.Nodes.XData(1) GBur_start.Nodes.YData(1)]);
    target = find_node_id(path_graph,[GBur_goal.Nodes.XData(1) GBur_goal.Nodes.YData(1)]);
    target = target(1);
    sht_path = shortestpath(path_graph,source,target);

    lightBlue = [91, 207, 244] / 255;
    burlywood = [222,184,135] /255;
    darkmagenta = [139,0,139] /255;
    chartreuse = [0,255,0] /255;
    plot(GBur_start, 'XData', GBur_start.Nodes.XData, 'YData', GBur_start.Nodes.YData,'NodeColor',darkmagenta,'EdgeColor',darkmagenta);
    plot(GBur_goal,'XData',GBur_goal.Nodes.XData,'YData',GBur_goal.Nodes.YData,'NodeColor','r','EdgeColor','r');
    p = plot(path_graph,'XData',path_graph.Nodes.XData,'YData',path_graph.Nodes.YData);
    highlight(p,sht_path,'LineWidth', 2, 'EdgeColor', chartreuse);
end