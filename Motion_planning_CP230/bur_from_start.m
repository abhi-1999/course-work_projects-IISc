function GBur_start = bur_from_start(GBur_start,GBur);
n = numnodes(GBur_start);

nodes_to_add = numnodes(GBur);

GBur_start = addnode(GBur_start,nodes_to_add);

%####################IMPORTANT############################
% root in GBur will already be there in GBur_start need to resolve this

GBur_start.Nodes.XData(n+1:numnodes(GBur_start)) = GBur.Nodes.XData(:,1);
GBur_start.Nodes.YData(n+1:numnodes(GBur_start)) = GBur.Nodes.YData(:,1);

end

