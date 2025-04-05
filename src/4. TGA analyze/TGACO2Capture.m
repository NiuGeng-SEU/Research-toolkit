function [captureRatio, CO2content] = TGACO2Capture(TGAdata,varargin)
    % According to stage 3, the code returns CO2 capture content in percentage form (%).
    % Varargin: paired component CO2 + component Weight ratio.
    % File path setting
    filePath = matlab.desktop.editor.getActiveFilename;
    folderPath = fileparts(filePath);
    % Data input
    data  = readtable(fullfile(folderPath, TGAdata), 'Sheet', 3, 'VariableNamingRule', 'preserve');
    T  = data{:, 2};
    W  = data{1:length(T), 4}./data{1, 4}*100;
    dW = data{:, 5};

    % stage 3 - CaCO3 CO2 loss
    offset = 10; % temperature start/end point offset
    a = 500; % start point
    b = 700; % end point
    [~,Ta1] = min(abs(T(:)-a+offset));
    [~,Ta2] = min(abs(T(:)-a));
    [~,Tb1] = min(abs(T(:)-b));
    [~,Tb2] = min(abs(T(:)-b-offset));
    [~,dWM] = max(abs(dW(Ta1:Tb2)));
    dWM = Ta1 + dWM;
    p1 = @(t1)((W(Ta1)-W(Ta2))/(T(Ta1)-T(Ta2)))*(t1-T(Ta1))+W(Ta1);
    p2 = @(t2)((W(Tb1)-W(Tb2))/(T(Tb1)-T(Tb2)))*(t2-T(Tb1))+W(Tb1);
    diff3 = p1(T(dWM))-p2(T(dWM));
    CO2content = diff3;

    % Process optional input parameters for CO2 corrections
    if nargin == 1
    else
        if mod(numel(varargin), 2) ~= 0
            error('Optional inputs must be provided as pairs: component CO2, component Weight Ratio');
        end
        for i = 1:2:length(varargin)
        componentCO2 = varargin{i};
        componentWeight = varargin{i+1};
        validateattributes(componentCO2, {'numeric'}, {'scalar', '>=', 0});
        validateattributes(componentWeight, {'numeric'}, {'scalar', '>', 0, '<=', 1});
        CO2content = CO2content - componentCO2 * componentWeight;
        end
    end
    
    captureRatio = CO2content/(100-CO2content)*100;
end