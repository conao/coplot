classdef Copar < handle
    properties (GetAccess=public, SetAccess=private)
        path = '';
        fileid = 0;
        data = [];
        argcoodinator = CoargCoodinator();
    end
    
    methods
        function obj = Copar(filepath)
            if nargin ~= 0
                obj.path = filepath;
                obj.fileid = fopen(filepath, 'r', 'a', 'UTF-8');
            end
        end
        
        function closefile(obj)
            if obj.fileid
                obj.fileid = fclose(obj.fileid);
            else
                warning('Copar is not open file');
            end
        end
        
        function parse(obj)
            if ~obj.fileid
                error('call openfile() before parse()');
            end
            
            rawtxt = textscan(obj.fileid, '%s', 'Delimiter', '\n');
            rawtxt = string(rawtxt{:});
            
            rawline = join(rawtxt, '/n');
            %rawline = regexprep(rawline, '(\/n){2,}', '/n');
            [rawarg, rawdata] = regexp(rawline, '\/\*.*?\*\/', 'match', 'split');
            
            obj.parseData(rawdata);
            obj.parseArg(rawarg);
        end
        
        function parseData(obj, rawdata)
            % init
            rawdata = join(rawdata);
            rawdata = regexprep(rawdata, '\s*', ' ');
            rawdata = regexprep(rawdata, '(^\s*(\/n)*)|((\/n)*\s*$)', '');
            rawdata = regexp(rawdata, '(\/n)*', 'split');
            target = rawdata';
            
            % make matrix data
            obj.data = str2num(char(target));
        end
        
        function parseArg(obj, rawarg)
            % init
            target = join(rawarg);
            target = regexprep(target, '(\/\*)|(\*\/)|(\s*)|(\/n)', ' ');
            target = regexprep(target, '(^\s*:)|(\s*$)', '');
            target = regexp(target, '\s*:\s*', 'split');
            target = target';
            
            % make matrix data
            cellCoarg = arrayfun(@(x) obj.recognizeArg(x), target, ...
                                 'UniformOutput', false);
            cellCoarg(cellfun(@isempty, cellCoarg)) = [];
            cellfun(@(x) obj.argcoodinator.insertarg(x), cellCoarg);
        end
        
        function coarg = recognizeArg(obj, strTarget)
            strTarget = strtrim(strTarget);
            
            strarg = regexp(strTarget, '\s*', 'split');
            switch strarg(1)
                case 'label'
                    [key, values] = obj.confirmValuesCount(strarg, 0);
                case 'polyfit'
                    [key, values] = obj.confirmValuesCount(strarg, 1);
                    values = str2num(char(join(values)));
                case {'xlim', 'ylim'}
                    [key, values] = obj.confirmValuesCount(strarg, 2);
                    values = str2num(char(join(values)));
                otherwise
                    warning('unrecognize key: %s %s', ...
                            strarg(1), join(strarg(2:end)));
                    coarg = [];
                    return
            end
            coarg = Coarg(key, values);
        end
        
        function [key, values] = confirmValuesCount(~, target, count)
            if count == 0
                argCount = length(target);
            else
                argCount = count + 1;
            end
            
            if length(target) ~= argCount
                warning('too much values key: %s', target(1));
                warning('use these values: %s', join(target(2:argCount)));
            end
            key = target(1);
            values = target(2:argCount);
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
