function [iCount iPoints] = CalculateLineIntersections(lines)
%Calculates line intersections
%   [iCount iPoints] = CalculateIntersections(lines)

    lineCount = length(lines);
    iCount = 0;
    iPoints = nan(1,2);
    for i=1:lineCount
        for j=1:lineCount
            ai = lines(i).alpha;
            bi = lines(i).beta;
            aj = lines(j).alpha;
            bj = lines(j).beta;

            if (i ~= j && ai ~= aj)
                x = (bj - bi)/(ai - aj);
                y = ai*x + bi;
                
                iCount = iCount + 1;
                iPoints(iCount, :) = [x y];
            end
        end
    end
end