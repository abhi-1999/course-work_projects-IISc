function perp_unit_vec = perpendicular_vector(a,b)
    dir = b - a;
    perp_vec = [-dir(2), dir(1)]; % swap x and y components and negate one of them
    perp_unit_vec = perp_vec / norm(perp_vec); % normalize to obtain unit vector

end

