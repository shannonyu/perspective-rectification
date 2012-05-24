classdef line2D
    
    %propriedades:
    % a e b da propriedade de linha ax + b;
    % comp são os compontentes que compões a linha
    %
    
    properties
        a = 0;
        b = 0;
        comps = [];
    end
    
    methods
        function line = line2D(comps)
           if nargin > 0 % Support calling with 0 arguments
              line.comps = comps;
              %definir a e b a partir dos componentes
              a = 1;
              b = 1;
           end 
        end
        
        function str = toString(line)
           str = [int2str(line.a) 'x + ' int2str(line.b) ];
        end
    end
    
end

