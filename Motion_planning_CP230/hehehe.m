% Define the node coordinates for G and P
nodesG = [0 0; 2 2; 2 0; 4 2; 4 0];
nodesP = [0 2; 2 4; 2 2; 4 4; 4 2; 6 2; 6 0];

% Create the graph objects for G and P
Ggraph = digraph(G(:,1), G(:,2));
Pgraph = digraph(P(:,1), P(:,2));

% Plot the nodes for G and P
scatter(nodesG(:,1), nodesG(:,2), 'filled', 'MarkerFaceColor', 'b');
hold on;
scatter(nodesP(:,1), nodesP(:,2), 'filled', 'MarkerFaceColor', 'r');

% Plot the edges for G and P
edgeEndsG = Ggraph.Edges.EndNodes;
for i = 1:size(edgeEndsG,1)
    x = [nodesG(edgeEndsG(i,1),1) nodesG(edgeEndsG(i,2),1)];
    y = [nodesG(edgeEndsG(i,1),2) nodesG(edgeEndsG(i,2),2)];
    line(x, y, 'Color', 'b', 'LineWidth', 1);
end

edgeEndsP = Pgraph.Edges.EndNodes;
for i = 1:size(edgeEndsP,1)
    x = [nodesP(edgeEndsP(i,1),1) nodesP(edgeEndsP(i,2),1)];
    y = [nodesP(edgeEndsP(i,1),2) nodesP(edgeEndsP(i,2),2)];
    line(x, y, 'Color', 'r', 'LineWidth', 2);
end

% Set the axis limits and labels
xlim([-1 7]);
ylim([-1 5]);
xlabel('X');
ylabel('Y');
title('Graphs G and P');

end