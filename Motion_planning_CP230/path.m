function path(GBur,points_ss,nearest_point_idx)
%STEP1 ---> add the path from root to the nearest point to a new graph
    pred_list = nearest_point_idx;
    cur_par_id=nearest_point_idx;
    node_data = GBur.Nodes(cur_par_id,:);
    while true
        parent = predecessors(GBur,cur_par_id);
        if ~isempty(parent)
            cur_par_id = parent(1);
            node_data(end+1,:)=GBur.Nodes(cur_par_id,:);
            pred_list=[pred_list;cur_par_id];
        else
            break;
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
%STEP2 ---> add the points from single spine (points_ss) to path_graph
    num_points_ss = size(points_ss,1);
    num_nodes = numnodes(path_graph);
    path_graph = addnode(path_graph,num_points_ss);  %add node to path_graph
    
    %store the data into the nodes added
    path_graph.Nodes.XData(num_nodes+1:numnodes(path_graph)) = points_ss(:,1);
    path_graph.Nodes.YData(num_nodes+1:numnodes(path_graph)) = points_ss(:,2);
    
    %add edges to the newly added nodes
    if size(points_ss,1) == 1
        path_graph = addedge(path_graph,num_nodes,num_nodes+1);
    else
        for i=num_nodes:num_points_ss-1
            path_graph=addedge(path_graph,i,i+1);
        end
    end
    plot(GBur,'XData',GBur.Nodes.XData,'YData',GBur.Nodes.YData,'Nodecolor','k','EdgeColor','g');
    plot(path_graph,'XData',path_graph.Nodes.XData,'YData',path_graph.Nodes.YData,'NodeColor','k','EdgeColor','r');
end
