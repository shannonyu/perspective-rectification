
%Classe line2D: representa uma linha do tipo ax + b

classdef line2D
    properties
        a = 0;
        b = 0;
        comps = [];
    end
    
    methods
        function line = line2D(comps)
           if nargin > 0 
              line.comps = comps;
              %TODO: definir a e b a partir dos componentes
              a = 1;
              b = 1;
           end 
        end
        
        function str = toString(line)
           str = [int2str(line.a) 'x + ' int2str(line.b) ];
        end
    end
    
end

