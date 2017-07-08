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
            rawtxt = textscan(obj.fileid, '%s', 'Delimiter', '\n');
            rawtxt = string(rawtxt{:});
            
            rawline = join(rawtxt, '/n');
            %rawline = regexprep(rawline, '(\/n){2,}', '/n');
            [rawarg, rawdata] = regexp(rawline, '\/\*.*?\*\/', 'match', 'split');
            
            %% data consist
            % init
            rawdata = join(rawdata);
            rawdata = strsplit(rawdata, '/n');
            rawdata = rawdata';
            
            % delete null row
            cellfind = regexp(rawdata, '^\s*$', 'emptymatch');
            celllogicalfind = cellfun(@(x) any(x), cellfind, 'UniformOutput', false);
            logicalfind = cell2mat(celllogicalfind);
            rawdata(logicalfind) = [];
            
            % make matrix data
            celldata = regexp(rawdata, '\t', 'split');
            
        end
    end
end
