function GBur_start = bur_from_start(GBur_start,GBur);
n = numnodes(GBur_start);

nodes_to_add = numnodes(GBur);

GBur_start = addnode(GBur_start,nodes_to_add);

GBur_start.Nodes.XData(n+1:numnodes(GBur_start)) = GBur()

end

