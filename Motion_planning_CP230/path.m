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
                break;
            end 
        end
        node_data = flip(node_data);
        pred_list = flip(pred_list);
        points_ss = flip(points_ss);
    
        path_graph = digraph();
        path_graph = addnode(path_graph,size(pred_list,1));
        for i =1:size(pred_list,1)-1
            path_graph = addedge(path_graph,i,i+1);
        end
        path_graph.Nodes = node_data;
    %till above adds path from GBur_start to nearset point


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

        %STEP 3 --->now add the path from last point in points_ss to goa
        cur_par_id = find_node_id(GBur_goal,points_ss(end,:));
        node_data = GBur_goal.Nodes(cur_par_id,:);
        while true
            parent = predecessors(GBur_goal,cur_par_id);
            if ~isempty(parent)
                cur_par_id = parent(1);
                node_data(end+1,:) = GBur_goal.Nodes(cur_par_id,:);
            else
                break;
            end 
        end
        node_data = flip(node_data);

        %remove the first element from above since it is already in path_graph
        node_data(1,:) =[];
        
        e =numnodes(path_graph);
        path_graph = addnode(path_graph,size(node_data,1));

        %store the data into the nodes added
        
        j=numnodes(path_graph)+1;
        for i = 1:size(node_data,1)
            path_graph.Nodes.XData(j) = node_data.XData(i);
            path_graph.Nodes.YData(j) = node_data.YData(i);
            path_graph = addedge(path_graph,e,j);
            e = j;
            j= j+1;
        end
end

%PLOT
    
    plot(path_graph,'XData',path_graph.Nodes.XData,'YData',path_graph.Nodes.YData,'NodeColor','k','EdgeColor','r');
end

