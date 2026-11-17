function [N_values, P, coef, slope] = compute_power_proc_r(y, trend_fun)
    % Computes the power P(N) of r = y - trend for each window size N
    % (from 3 to M/2), then fits a line to log(P) vs log(N);
    % Inputs:
    %   y: integrated signal
    %   trend_fun: the method that is used to calculate the trend
    % Outputs:
    %   N_values: window sizes N used
    %   P: power of r for each N
    %   coef: coefficients of the log-log fit [slope, intercept]
    %   slope: slope of the fit (the marker)

    M = length(y);
    N_values = 3:floor(M/2);
    P = zeros(size(N_values));
    for idx = 1:numel(N_values)
        Ni = N_values(idx);
        L  = floor(M/Ni);
        trend = trend_fun(y, Ni);
        r = y(1:L*Ni) - trend(1:L*Ni);
        P(idx) = mean(r.^2);
    end
    idx_fit = N_values >= 3 & N_values <= floor(M/6); % Avoid extreme values for the fit
    coef = polyfit(log(N_values(idx_fit)), log(P(idx_fit)), 1);
    slope = coef(1);
end