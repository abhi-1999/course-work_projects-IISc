function [near_point,id] = findnearestpoint(GBur,goal)

node_data = table2array(GBur.Nodes);

euc_distances = sqrt(sum((node_data - goal).^2,2));
[~,id] = min(euc_distances);
near_point = node_data(id,:);
end

