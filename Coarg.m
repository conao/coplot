classdef Coarg < handle
    properties (GetAccess=public, SetAccess=private)
        key = "";
        values = []; % enpty matlix
    end
    
    methods
        function obj = Coarg(key, values)
            if nargin == 0
            elseif nargin == 1
                obj.key = key;
            elseif nargin == 2
                obj.key = key;
                obj.values = values;
            end
        end
    end
end