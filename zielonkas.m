%Zielonka's Algorithm - using ownslip
% V = graph adjacency matrix (can be sparse)
% pr = priority vector
% ownsplit = ownership vector (can be sparse)
% subgame = Set of nodes in subgame (can be sparse)

function [w0, w1] = zielonkas(V, pr, ownsplit, subgame)
    n = length(pr);
    rel_game = pr.*subgame;
    p = max(rel_game);

    if p == 0
        w0 = subgame;
        w1 = zeros(1,n);
    else
        U = rel_game == p;

        q = mod(p, 2);
        A = matattract(U, V, ownsplit, subgame, q);
        [t0, t1] = zielonkas(V, pr, ownsplit, subgame - A);

        if (q == 0) & (t1 == zeros(1,n))
            w0 = subgame;
            w1 = zeros(1,n);
        elseif (q == 1) & (t0 == zeros(1,n))
            w0 = zeros(1,n);
            w1 = subgame;
        else
            if q == 0
                B = matattract(t1, V, ownsplit, subgame, 1);
                [tt0, tt1] = zielonkas(V, pr, ownsplit, subgame - B);
                w0 = tt0;
                w1 = tt1 + B;
            else
                B = matattract(t0, V, ownsplit, subgame, 0);
                [tt0, tt1] = zielonkas(V, pr, ownsplit, subgame - B);
                w1 = tt1;
                w0 = tt0 + B;
            end
        end
        
    end
        
end
