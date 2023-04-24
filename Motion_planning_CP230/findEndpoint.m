function [endpoint,node] = findEndpoint(gbur,root, i)

%  METHOD 1 ---> using Adjacency Matrix
% 
% % Extract the adjacency matrix from GBur
% A = full(adjacency(GBur));
% 
% % Get the root node of the graph
% inDegrees = sum(A, 1);
% rootNodes = find(inDegrees == 0);
% if numel(rootNodes) ~= 1
%     error('Graph does not have a unique root');
% end
% 
% rootNode = rootNodes(1);
% 
% % Get the starting node of the ith branch from the root
% root_child = find(A(rootNode,:));
% 
% start_Node_ith_spine= root_child(i); %will have (i+1)th node since root is numbered 1.
% 
% % Traverse the branch to its endpoint
% lastNode = start_Node_ith_spine;
% while true
%     children = find(A(lastNode, :));
%     if isempty(children)
%         endpoint = lastNode;
%         break;
%     end
%     lastNode = children(1);
% end
% 
% end

% METHOD 2 using succesor function

endpoint = find_node_id(gbur,root); %initialise endpoint to root
% try
%     root_child = successors(gbur,endpoint);
% catch
%     disp("here");
% end
root_child = successors(gbur,endpoint);

if ~isempty(root_child)
    endpoint = root_child(i);
end

while true
    children = successors(gbur,endpoint);
    if ~isempty(children)
        endpoint = children(1);
    else
        break;
    
    end

end

req_point = gbur.Nodes(endpoint,:); %the required point is in table format so return it in double

if(isa(req_point,'table'))
    node = [req_point.XData(1),req_point.YData(1)];
else
    node = req_point;
end
end

  