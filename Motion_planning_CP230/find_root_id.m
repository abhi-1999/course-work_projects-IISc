function index = find_root_id(gbur,root)
    
    index = find(gbur.Nodes.XData == root(1) & gbur.Nodes.YData == root(2))
end

