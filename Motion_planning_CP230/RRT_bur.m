function rrt_bur = RRT_bur(goal,root,close_pt,dc,map)
    %STEP1 ---> find the unit vector at root perpendicular to line joinin
                %root and close_point
    
    
    perp_unit_vec = perpendicular_vector(root,close_pt);
    %STEP2 ---> sample two points at dc distance opposite to each other p1
    %is right of root and p2 is left of root and decide which side to move

    
    v = dc * perp_unit_vec;
    b = root + v;
    dir = v / norm(v);
    if dot(dir, root-b) < 0
        p1 = b;
        p2 = root - v;
    else
        p1 = root + v;
        p2 = root - v;
    end

    theta = atan2d(goal(2) - root(2),goal(1)-root(1));
    if theta > 90 
        move = 0; %move left
        rrt_points = p2;
    else
        move = 1;
        rrt_points = p1;
    end
    %STEP3 ---> sample points along move till dc<0 or we get a greater dc
    if move == 1
        while true 
            [d,d_point] = find_min_dist_to_obstacle(rrt_points(end,:),map);
    
            if d == 0 || d > dc
                break
            else
                perp_unit_vec = perpendicular_vector(rrt_points(end,:),d_point);
                new_point = rrt_points(end,:) + perp_unit_vec *dc;
                if dot(new_point - rrt_points(end,:),perp_unit_vec) < 0  %this means new_point is in left 
                    perp_unit_vec = -perp_unit_vec;
                    new_point = rrt_points(end,:) + perp_unit_vec*dc;
                end
                rrt_points=[rrt_points;new_point];
            end
        end
       
    else
        while true
            [d,d_point] = find_min_dist_to_obstacle(rrt_points(end,:),map);
    
            if d == 0 || d > dc
                break
            else
                perp_unit_vec = perpendicular_vector(rrt_points(end,:),d_point);
                new_point = rrt_points(end,:) + perp_unit_vec *dc;
                if dot(new_point - rrt_points(end,:),perp_unit_vec) > 0  %this means new_point is in right 
                    perp_unit_vec = -perp_unit_vec;
                    new_point = rrt_points(end,:) + perp_unit_vec*dc;
                end
                rrt_points=[rrt_points;new_point];
            end
        end
    end
    rrt_points = [root;rrt_points];

    rrt_bur = digraph();
    rrt_bur = addnode(rrt_bur,size(rrt_points,1));

    rrt_bur.Nodes.XData(1:numnodes(rrt_bur)) = rrt_points(:,1);
    rrt_bur.Nodes.YData(1:numnodes(rrt_bur)) = rrt_points(:,2);

    for i =1:numnodes(rrt_bur) - 1
        rrt_bur = addedge(rrt_bur,i,i+1);
    end
    
end

