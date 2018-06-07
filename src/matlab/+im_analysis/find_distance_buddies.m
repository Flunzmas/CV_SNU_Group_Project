function distance_buddies = find_distance_buddies(distances, min_clique_size, ...
            circ_dist_tol, min_dist)

distance_buddies = 0;
for N = 1 : length(distances)
    if distances(N) >= min_dist
        clique_indices = find(abs(distances - distances(N)) < circ_dist_tol);
        if length(clique_indices) > 2
            clique_members = im_analysis.find_clique_members(clique_indices, length(distances));
            
        end
    end
end