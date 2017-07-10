function plotdata(copar, varargin)
    p = inputParser;
    defaultFignum = 80;
    addOptional(p,'fignum',defaultFignum,@isnumeric);
    parse(p, varargin{:});
    
    % init figure window
    fig = figure(p.Results.fignum);
    clf(p.Results.fignum);
    
    % init filename
    filename = regexp(copar.path, '[^/]*$', 'match');
    filename = regexp(filename, '^[^.]+', 'match');
    
    if iscell(filename)
        filename = filename{1};
    end
    
    % parse data
    % copar.parse;
    % copar.closefile;
    
    data = copar.data;
    coodinator = copar.argcoodinator;
    
    % plot data
    box on;
    hold on;
    
    x = data(:,1);
    rcol = [];
    if coodinator.isexist('right')
        %% right axis
        %{
        yyaxis right;
        
        rcol = coodinator.getarg('right').values;
        for k = 1:length(rcol)
            line = plot(x, data(:,rcol(k)));
        end
        %}
    end
    %% left axis
    yyaxis left;
    
    if isempty(rcol)
        lcol = 2:length(data(1,:));
    else
        % arrayfun(@(x) x==ycol, rcol, 'UniformOutput', false)
    end
    
    for k = 1:length(lcol)
        % plot data
        line = plot(x, data(:,lcol(k)));
        line_settings(line, 'none', line_symbol(k));
        
        % fitting
        p = polyfit(x, data(:,lcol(k)), coodinator.getarg('polyfit').values);
        py = polyval(p,x);
        line = plot(x, py);
        disp(p);
        line_settings(line, '--', 'none');
    end
    
    if coodinator.isexist('ylabel')
        ylabel(coodinator.getarg('ylabel').values);
    end
    
    %% misc
    hold off;
    
    axis = fig.CurrentAxes;
    axis.XMinorTick = 'On';
    axis.YMinorTick = 'On';
    
    if coodinator.isexist('xlim')
        xlim(coodinator.getarg('xlim').values);
    end
    
    if coodinator.isexist('xlabel')
        xlabel(coodinator.getarg('xlabel').values);
    end
    
    if coodinator.isexist('label')
        labels = coodinator.getarg('label').values;
        for k = 1:length(labels)
            targetlabel(1+(k-1)*2) = labels(k);
            targetlabel(2+(k-1)*2) = strcat(labels(k), '‹ßŽ—');
        end
        legend(targetlabel);
    end
    
    fig.PaperUnits = 'points';
    fig.PaperPosition = [0 0 1200, 800];
    disp(strcat(filename,'.png'));
    saveas(fig, strcat(char(filename), '.png'));
end

function line_settings(line, line_style, marker)
    line.LineStyle = line_style;
    line.Marker = marker;
    line.Color = 'k';
end
