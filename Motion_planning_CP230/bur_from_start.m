function GBur_start = bur_from_start(GBur_start,GBur)
n = numnodes(GBur_start);

nodes_to_add = numnodes(GBur);

GBur_start = addnode(GBur_start,nodes_to_add);


j=2;
for i=n+1:numnodes(GBur_start)
    GBur_start.Nodes.XData(i) = GBur.Nodes.XData(j,1);
    GBur_start.Nodes.YData(i) = GBur.Nodes.YData(j,1);
    j=j+1;
end

%find root id
root = [GBur.Nodes.XData(1) GBur.Nodes.YData(1)];
root_id = find_node_id(GBur_start,root);

root_child = succesors(GBur,1);

%connect the edges
for i=1:size(root_child,1)
    next_point = [GBur.Nodes.Xdata(i) GBur.Nodes.YData(i)];
    next_point_id = find_node_id(GBur_start,next_point);
    GBur_start = addedge(GBur_start,root_id,next_point_id);
    point_succ = successors(GBur,root_id(i));
    while ~isempty(point_succ)
        curr_point_id  = next_point_id;
        next_point = [GBur.Nodes.XData(point_succ(1)) GBur.Nodes.YData(point_succ(1))];
        next_point_id = find_node_id(GBur_start,next_point);
        GBur_start = addedge(GBur_start,curr_point_id,next_point_id);
        point_succ = successors(GBur,point_succ(1));
    end
end


end

