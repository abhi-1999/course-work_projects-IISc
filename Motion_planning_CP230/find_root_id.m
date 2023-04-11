function index = find_root_id(GBur,root)
    
    index = find(GBur.Nodes.XData == root(1) & GBur.Nodes.YData == root(2))
end

