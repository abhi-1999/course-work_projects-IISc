function index = find_node_id(gbur,point)
    
    index = find(gbur.Nodes.XData == point(1) & gbur.Nodes.YData == point(2));
end

