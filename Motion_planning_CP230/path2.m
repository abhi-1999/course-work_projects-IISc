function path2(turn,GBur_goal,GBur_start,goal,nearest_point_idx)
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
    node_data = flip(node_data);
    pred_list = flip(pred_list);
    path_graph = digraph();
    path_graph = addnode(path_graph,size(pred_list,1));
    for i =1:size(pred_list,1)-1
        path_graph = addedge(path_graph,i,i+1);
    end
    path_graph.Nodes = node_data;

    %STEP2 ---> connect nearest point to goal
    goal_idx = find_node_id(GBur_goal,goal);

    pred_list = goal_idx;
    cur_par_id = goal_idx;
    node_data = GBur_goal.Nodes(cur_par_id,:);
    while true
        parent = predecessors(GBur_goal,cur_par_id);
        if ~isempty(parent)
            cur_par_id = parent(1);
            node_data(end+1,:) = GBur_goal.Nodes(cur_par_id,:);
            pred_list = [pred_list;cur_par_id];
        else
            break
        end
    end
     j = numnodes(path_graph);
     path_graph = addnode(path_graph,size(pred_list,1));
     path_graph.Nodes.XData(j+1:numnodes(path_graph)) = node_data.XData(:,1);
     path_graph.Nodes.YData(j+1:numnodes(path_graph)) = node_data.YData(:,1);

     for i = j:numnodes(path_graph) -1
         path_graph = addedge(path_graph,i,i+1);
     end
else
    %STEP2 ---> add path from root to goal
    goal_idx = find_node_id(GBur_start,goal);

    pred_list = goal_idx;
    cur_par_id = goal_idx;
    node_data = GBur_start.Nodes(cur_par_id,:);
    while true
        parent = predecessors(GBur_start,cur_par_id);
        if ~isempty(parent)
            cur_par_id = parent(1);
            node_data(end+1,:) = GBur_start.Nodes(cur_par_id,:);
            pred_list = [pred_list;cur_par_id];
        else
            break
        end
    end
    node_data = flip(node_data);
    pred_list = flip(pred_list);
    path_graph = digraph();
    path_graph = addnode(path_graph,size(pred_list,1));
    for i =1:size(pred_list,1)-1
        path_graph = addedge(path_graph,i,i+1);
    end
    path_graph.Nodes = node_data;

    %STEP2 ---> add path from nearest node to goal
    pred_list = nearest_point_idx;
    cur_par_id=nearest_point_idx;
    node_data = GBur_goal.Nodes(cur_par_id,:);
    while true
        parent = predecessors(GBur_goal,cur_par_id);
        if ~isempty(parent)
            cur_par_id = parent(1);
            node_data(end+1,:)=GBur_goal.Nodes(cur_par_id,:);
            pred_list=[pred_list;cur_par_id];
        else
            break
        end 
    end
    j = numnodes(path_graph);
     path_graph = addnode(path_graph,size(pred_list,1));
     path_graph.Nodes.XData(j+1:numnodes(path_graph)) = node_data.XData(:,1);
     path_graph.Nodes.YData(j+1:numnodes(path_graph)) = node_data.YData(:,1);

     for i = j:numnodes(path_graph) -1
         path_graph = addedge(path_graph,i,i+1);
     end


end
plot(path_graph,'XData',path_graph.Nodes.XData,'YData',path_graph.Nodes.YData,'NodeColor','k','EdgeColor','r');
end

