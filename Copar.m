classdef Copar < handle
    properties (GetAccess=public, SetAccess=private)
        fileid = 0;
        data = [];
        arg = [];
        coodinator = CoargCoodinator;
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
            
            parseData(rawdata);
            parseArg(rawarg);
        end
        
        function parseData(obj, rawdata)
            % init
            rawdata = join(rawdata);
            rawdata = strsplit(rawdata, '/n');
            rawdata = rawdata';
            
            % delete null row
            rawdata = deleteNullRow(rawdata);
            
            % make matrix data
            celldata = regexp(rawdata, '\t', 'split');
            cellsplitdata = cellfun(@(x) join(x), celldata, 'UniformOutput', false);
            obj.data = str2double(char(cellsplitdata));
        end
        
        function result = parseArg(obj, rawarg)
            % init
            rawarg = join(rawarg);
            rawarg = strrep(strrep(rawarg, '/*', ''), '*/', '');
            rawarg = strrep(rawarg, '/n', ' ');
            rawarg = strsplit(rawarg, ':');
            rawarg = rawarg';
            
            % delete null row
            rawarg = deleteNullRow(rawarg);
            
            % make matrix data
            celldata = regexp(rawarg, '\s', 'split');
            
            
            % tmp
            obj.arg = [];
        end
        
        function coarg = recognizeArg(celldata)
            coarg = Coarg;
            disp(celldata);
        end
        
        function result = deleteNullRow(~, target)
            cellfind = regexp(target, '^\s*$', 'emptymatch');
            celllogicalfind = cellfun(@(x) any(x), cellfind, 'UniformOutput', false);
            logicalfind = cell2mat(celllogicalfind);
            target(logicalfind) = [];
            result = target;
        end
    end
end
