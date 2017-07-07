classdef Copar < handle
    properties (GetAccess=public, SetAccess=private)
        fileid = 0;
    end
    
    methods
        function obj = Copar()
            % no init code.
        end
        
        function openfile(obj, filepath)
            obj.fileid = fopen(filepath, 'r', 'a', 'UTF-8');
        end
        
        function closefile(obj)
            if obj.fileid
                fclose(obj.fileid);
            else
                warning('Copar is not open file');
            end
        end
        
        function parse(obj)
            rawdata = textscan(file, '%s', 'Delimiter', '\n');
            rawdata = string(rawdata{:});
            
            rawline = join(rawdata, '/n');
            rawline = regexprep(rawline, '(\/n){2,}', '/n');
            [rawarg, rawdata] = regexp(rawline, '\/\*.*?\*\/', 'match', 'split');
            
            rawdata = join(rawdata);
            rawdata = regexp(rawdata, '\/n', 'split');
            rawdata = rawdata';
        end
    end
end
