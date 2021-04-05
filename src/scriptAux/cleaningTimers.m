%deletes the timers of the interface

% t1 = timerfind('Name', 'gifTimer');
% if ~isempty(t1)
%     stop(t1);
%     delete(t1)
% end

t1 = timerfind('Name', 'waitbarTimer');
if ~isempty(t1)
    stop(t1);
    delete(t1)
end

t1 = timerfind('Name', 'recolectionTimer');
if ~isempty(t1)
    stop(t1);
    delete(t1)
end