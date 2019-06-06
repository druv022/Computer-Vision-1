function [ height_map ] = construct_surface( p, q, path_type )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface


% if nargin == 2
%     path_type = 'column';
% end

[h, w] = size(p);
height_map = zeros(h, w);

switch path_type
    case 'column'
        disp("I am using coloumn")
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        % for each pixel in the left column of height_map
        %   height_value = previous_height_value + corresponding_q_value
        
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        for x= 2:h
            height_map(x, 1) = height_map(x-1, 1) + q(x, 1);
            % start from second element
            for y = 2:w
                height_map(x,y) = height_map(x,y-1) + p(x,y);
            end
        end
        
       
        % =================================================================
               
    case 'row'
        disp('I am using row')
        % =================================================================
        % YOUR CODE GOES HERE
        for y = 2 : w
            height_map(1,y) = height_map(1, y-1) + p(1, y);
            for x = 2 : h
                height_map(x, y) = height_map(x-1, y) + q(x,y);
            end
        end

        % =================================================================
          
    case 'average'
        disp('I am using average')
        % =================================================================
        % YOUR CODE GOES HERE
        row_map =  zeros(h, w);
        column_map = zeros(h, w);
        % YOUR CODE GOES HERE
        for x= 2:h
            column_map(x, 1) = column_map(x-1, 1) + q(x, 1);
            % start from second element
            for y = 2:w
                column_map(x,y) = column_map(x,y-1) + p(x,y);
            end
        end
        
        
        % YOUR CODE GOES HERE
        for y = 2 : w
            row_map(1,y) = row_map(1, y-1) + p(1, y);
            for x = 2 : h
                row_map(x, y) = row_map(x-1, y) + q(x,y);
            end
        end
        height_map = (column_map + row_map)./2;
        % =================================================================
end


end

