function TGADSC(fileName)
    % fileName: data excel.
    % File path setting
    filePath = matlab.desktop.editor.getActiveFilename;
    [~, fileNameNoExt] = fileparts(fileName);
    folderPath = fileparts(filePath);
    % Data input
    data  = readtable(fullfile(folderPath, fileName), 'Sheet', 3, 'VariableNamingRule', 'preserve');
    T  = data{:, 2};
    H  = data{:, 3};
    W  = data{1:length(T), 4}./data{1, 4}*100;

    % left: weight loss
    figure;
    hold on;
    yyaxis left;
    plot(T, W, '-', 'LineWidth', 2, 'Color', [0,      0.4470, 0.7410, 1],'DisplayName', 'Weight');
    ylabel('Weight (%)');
    xlim([0 1000]);
    ylim([90.5 100.5]);
    set(gca, 'YColor', 'k');
    
    % right: heat flow
    yyaxis right;
    plot(T, H, '-', 'LineWidth', 2, 'Color', [0.9290, 0.6940, 0.1250, 1],'DisplayName', 'Heat flow');
    ylabel('Heat flow (W/g)', 'FontSize', 16);
    ylim([-10 2]);
    set(gca, 'YColor', 'k');
    xlabel('Temperature (°C)');
    
    legend('show', 'Location', 'northeast','FontSize', 16, 'Box', 'off','NumColumns',1);
    set(gca, 'FontSize', 16, 'FontName', 'Times New Roman');
    grid on;
    box on;
    hold off;
    saveas(gcf, fullfile(folderPath, [char(fileNameNoExt),'DSC.svg']));

end