function path = rgbt_connect(qstart, qgoal)
% Connects qstart and qgoal using the RGBT-CONNECT algorithm.


% Constants
imax = 1000;
delta = 0.1;
epsilon = 0.5;
dk = 2*delta;
N = 5;


% Initialize trees
Ta = qstart;
Tb = qgoal;

for i = 1:imax
    % Randomly sample a configuration
    ye1 = RANDOM_CONFIG();

    % Find nearest node in Ta
    [qnear, ~] = NEAREST(ye1, Ta);

    % If qnear is close to the goal, switch trees
    if NORM(qnear - qgoal) < dk
        SWAP(Ta, Tb);
        qnear = NEAREST(ye1, Ta);
    end

    % Expand Ta towards ye1
    if NORM(qnear - qgoal) >= dk
        qnew = qnear + epsilon*(ye1 - qnear)/NORM(ye1 - qnear);
        if ~Collision(qnew, qnear)
            Ta = [Ta; qnew qnear];
        else
            continue;
        end
 else % Switch to RGBT mode
  qe1 = qnear + delta*(ye1 - qnear)/NORM(ye1 - qnear);
Qe = qe1;
  for j = 2:N
   yej = RANDOM_CONFIG();
 qej = qnear + delta*(yej - qnear)/NORM(yej - qnear);
 Qe = [Qe; qej];
end
 GBur = GENERALIZED_BUR(qnear, Qe, dk);
qnew = ENDPOINT(GBur, qe1);
 end

 % Attempt to connect to Tb
   if GBUR_CONNECT(Tb, qnew) == Reached
        path = PATH(Ta, Tb);
        return;
    end

    % Switch trees
    SWAP(Ta, Tb);
end

 


end