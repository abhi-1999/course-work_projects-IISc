function GBur = updateGBur(GBur,root,node_id,node,dc)



%find new point along the direction of spine

direction = (node - root) / norm(node - root);
new_point = node + direction * dc;

%add new point to bur
GBur = addnode(GBur,1);

new_Node_id = numnodes(GBur);

GBur = addedge(GBur,node_id,new_Node_id);

GBur.Nodes.XData(new_Node_id) = new_point(1,1);
GBur.Nodes.YData(new_Node_id) = new_point(1,2);

end

