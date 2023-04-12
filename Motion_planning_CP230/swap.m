function [turn,start,goal] = swap(nearest_point,goal,turn)

if turn == 1
    turn = 0;
else
    turn = 1;
end

start = goal;
goal = nearest_point;

end

