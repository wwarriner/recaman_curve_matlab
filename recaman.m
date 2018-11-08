function [ r, visited, missing ] = recaman( n )

r = zeros( n, 1 );
visited = containers.Map( { 0 }, { 0 } );
for i = 2 : n
    
    r( i ) = get_next_recaman( r( i - 1 ), i, visited );
    visited( r( i ) ) = r( i );
    
end
visited = cell2mat( keys( visited ) ).';
missing = setdiff( visited, 1 : n );

end


function next = get_next_recaman( previous, iteration, visited )

lower = previous - iteration;
if isKey( visited, lower ) || lower < 0
    next = previous + iteration;
else
    next = lower;
end

end