function [iCount iPoints] = CalculateLineIntersections(lines, nRows, nCols)
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
                if(~isinf(x) && ~isinf(y) && ~isnan(x) && ~isnan(y))
                    if( ~(x > 0 && x < nCols && y > 0 && y < nRows) ) %aceito pontos apenas fora da página
                        iCount = iCount + 1;
                        iPoints(iCount, :) = [x y];
                    end
                end
            end
        end
    end
end