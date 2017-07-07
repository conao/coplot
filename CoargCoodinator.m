classdef CoargCoodinator < handle
    properties (GetAccess=public, SetAccess=private)
        coarg = []; % init with empty matlix
    end
    methods
        function obj = CoargCoodinator()
            % no init code.
        end
        
        function insertarg(obj, target)
            if isa(target, 'Coarg')
                obj.coarg(length(obj.coarg)+1) = target;
            else
                error('insertarg need "Coarg" object');
            end
        end
        
        function deletearg(obj, key)
            [~, inx] = getarg(key);
            obj.coarg(inx) = [];
        end
        
        function appendValues(obj, key, values)
            [~, inx] = getarg(key);
            obj.coarg(inx).values = cat(2, obj.coarg(inx).values, values);
        end
        
        function inx = isexist(obj, key)
            % this function occur noerror when noexist Coarg object
            % assumed Coarg exist, use getarg.
            % getarg occur error and stop when noexist Coarg object
            
            try
                [~, inx] = getarg(obj, key);
            catch
                inx = 0;
            end
        end
        
        function [target, inx] = getarg(obj, key)
            inx = find(strcmp({obj.key}, key));
            if inx
                target = obj(inx);
            else
                error('%s is not exist in CoargCoodinator', key);
            end
        end
        
        function keys = getkeys(obj)
            tmp = cell(1, length(obj.coarg));
            [tmp{:}] = obj.coarg.key;
            keys = string(tmp);
        end
    end
end