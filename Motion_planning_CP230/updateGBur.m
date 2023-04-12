function gbur = updateGBur(gbur,root,node_id,node,dc)



%find new point along the direction of spine

direction = (node - root) / norm(node - root);
new_point = node + direction * dc;

%add new point to bur
gbur = addnode(gbur,1);

new_Node_id = numnodes(gbur);

gbur = addedge(gbur,node_id,new_Node_id);

gbur.Nodes.XData(new_Node_id) = new_point(1,1);
gbur.Nodes.YData(new_Node_id) = new_point(1,2);

end

