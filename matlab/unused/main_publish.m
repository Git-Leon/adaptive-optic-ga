function main_publish()
    report('html', 'MainGA_wtb');
end

function report(format, varargin)
    files = cell2mat(varargin);
    for j = 1:nargin
        publish(varargin{j}, format);
    end
end