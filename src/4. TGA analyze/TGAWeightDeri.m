function TGAWeightDeri(fileName,var)
    % fileName: data excel; var: start point and end point of mass loss marker, even numbers are required, support multiple groups.
    % File path setting
    filePath = matlab.desktop.editor.getActiveFilename;
    [~, fileNameNoExt] = fileparts(fileName);
    folderPath = fileparts(filePath);
    % Data input
    data  = readtable(fullfile(folderPath, fileName), 'Sheet', 3, 'VariableNamingRule', 'preserve');
    T  = data{:, 2};
    W  = data{1:length(T), 4}./data{1, 4}*100;
    dW = data{:, 5};

    % left: weight loss
    figure;
    hold on;
    yyaxis left;
    plot(T, W, '-', 'LineWidth', 2, 'Color', [0,      0.4470, 0.7410, 1],'DisplayName', 'Weight');
    % Mass loss marker & calcu
    numInputs = length(var);
    for i = 1:numInputs/2
        a = var(2*i-1);
        b = var(2*i);
        offset = 10; % temperature start/end point offset
        [~,Ta1] = min(abs(T(:)-a+offset));
        [~,Ta2] = min(abs(T(:)-a));
        [~,Tb1] = min(abs(T(:)-b));
        [~,Tb2] = min(abs(T(:)-b-offset));
        [~,dWM] = max(abs(dW(Ta1:Tb2)));
        dWM = Ta1 + dWM;
        p1 = @(t1)((W(Ta1)-W(Ta2))/(T(Ta1)-T(Ta2)))*(t1-T(Ta1))+W(Ta1);
        p2 = @(t2)((W(Tb1)-W(Tb2))/(T(Tb1)-T(Tb2)))*(t2-T(Tb1))+W(Tb1);
        fplot(p1,[T(Ta1),T(Tb1)], '--', 'LineWidth', 2, 'Color', [0.4980, 0.7216, 0.8706],'HandleVisibility', 'off');
        fplot(p2,[T(Ta2),T(Tb2)], '--', 'LineWidth', 2, 'Color', [0.4980, 0.7216, 0.8706],'HandleVisibility', 'off');
        plot([T(dWM),T(dWM)],[p1(T(dWM)),p2(T(dWM))], '-_', 'LineWidth', 2, 'MarkerSize', 15,'Color', 'k','HandleVisibility', 'off')
        diff = p1(T(dWM))-p2(T(dWM));
        text(T(dWM)+130,(p1(T(dWM))+p2(T(dWM)))/2,sprintf("Mass loss:\n %.2f%%",diff), 'FontSize', 16, 'FontName', 'Times New Roman','HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
    ylabel('Weight (%)');
    xlim([0 1000]);
    ylim([90.5 100.5]);
    set(gca, 'YColor', 'k');
    
    % right: 1st deriv
    yyaxis right;
    plot(T(500:end), (dW(500:end)), '-', 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980, 1],'DisplayName', '1st deriv.');
    ylabel('Deriv. weight (%/°C)', 'FontSize', 16);
    ylim([-0.34 0.02]);
    set(gca, 'YColor', 'k', 'YDir', 'reverse');
    xlabel('Temperature (°C)');
    
    legend('show', 'Location', 'northeast','FontSize', 16, 'Box', 'off','NumColumns',1);
    set(gca, 'FontSize', 16, 'FontName', 'Times New Roman');
    grid on;
    box on;
    hold off;
    saveas(gcf, fullfile(folderPath, [char(fileNameNoExt),'.svg']));
end