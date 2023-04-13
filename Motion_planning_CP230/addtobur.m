function newbur = addtobur(bur_tree,GBur)
newbur = bur_tree;
n = numnodes(newbur);

nodes_to_add = numnodes(GBur) - 1;

newbur = addnode(newbur,nodes_to_add);


j=2;
for i=n+1:numnodes(newbur)
    newbur.Nodes.XData(i) = GBur.Nodes.XData(j);
    newbur.Nodes.YData(i) = GBur.Nodes.YData(j);
    j=j+1;
end

%find root id
root = [GBur.Nodes.XData(1) GBur.Nodes.YData(1)];
root_id = find_node_id(newbur,root);

root_child = successors(GBur,1);

%connect the edges
for i=1:size(root_child,1)
    next_point = [GBur.Nodes.XData(root_child(i)) GBur.Nodes.YData(root_child(i))];
    next_point_id = find_node_id(newbur,next_point);
    newbur = addedge(newbur,root_id,next_point_id);
    point_succ = successors(GBur,root_child(i));
    while ~isempty(point_succ)
        curr_point_id  = next_point_id;
        next_point = [GBur.Nodes.XData(point_succ(1)) GBur.Nodes.YData(point_succ(1))];
        next_point_id = find_node_id(newbur,next_point);
        newbur = addedge(newbur,curr_point_id,next_point_id);
        point_succ = successors(GBur,point_succ(1));
    end
end


end

