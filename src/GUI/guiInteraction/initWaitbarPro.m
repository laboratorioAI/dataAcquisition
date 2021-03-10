
function initWaitbarPro(handles)

waitbarAxes = handles.waitbarAxes;

% wait bar características!
esfera = scatter(waitbarAxes, 0, 0, 'LineWidth', 1);
esfera.MarkerFaceColor = [0 0.25 0.25];
esfera.MarkerEdgeColor = [0 0.5 0.5];
waitbarAxes.YLim = [0 1];
waitbarAxes.XLim = [0 1];
waitbarAxes.XLim = [0 1];
waitbarAxes.XMinorGrid = 'on';
waitbarAxes.XTickLabel = {};
waitbarAxes.XMinorTick = 'on';
waitbarAxes.YColor = [1 1 1];


hold(waitbarAxes, 'on')

% area
x = [0; 0.001];
Y = [0.5;0.5];

area(waitbarAxes, x,Y,...
    'FaceColor', [102, 205, 170] / 255, 'EdgeColor', [32, 178, 170] / 255); % low

end


% area(Y,'FaceColor', [0 0.25 0.25]) % dark
% area(Y,'FaceColor', [0 0.5 0.5]) % medium