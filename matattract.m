%Attractor Function - Basic Matrix Method

%{
function [new_A] = matattract(A, V, ownsplit, subgame, q)
    while true

        n = length(V);
        inbound = (V*A') & subgame';
        max_deg = V*subgame';
        if q == 0
            even_incoming = logical(inbound(1:ownsplit));
            odd_incoming = logical(max(inbound(ownsplit+1:n) - max_deg(ownsplit+1:n) + ones(n-ownsplit, 1),0)) & subgame(ownsplit+1:n)';            
        else
            odd_incoming = logical(inbound(ownsplit+1:n));
            even_incoming = logical(max(inbound(1:ownsplit) - max_deg(1:ownsplit) + ones(ownsplit, 1),0)) & subgame(1:ownsplit)';
        end

        new_A = transpose(logical(A' + [even_incoming;odd_incoming]));
        
        if new_A == A
            break;
        else
            A = new_A;
           
        end
    end
end
%}


%Attractor Function - Basic Matrix Method (ownsplit vector not int)

function [new_A] = matattract(A, V, ownsplit, subgame, q)
    n = length(V);
    even_nodes = ones(1,n) - ownsplit;
    odd_nodes = ownsplit;

    while true
        
        inbound = (V*A') & subgame';
        max_deg = V*subgame';
        
        if q == 0
            even_incoming = logical(inbound .* even_nodes');
            odd_incoming = (logical(max(inbound - max_deg + ones(n,1),0)).*odd_nodes') & subgame';
        else
            odd_incoming = logical(inbound .* odd_nodes');
            even_incoming = (logical(max(inbound - max_deg + ones(n,1),0)).*even_nodes') & subgame';
        end

        new_A = transpose(logical(A' + even_incoming + odd_incoming));
        
        if new_A == A
            break;
        else
            A = new_A;
           
        end
    end
end


