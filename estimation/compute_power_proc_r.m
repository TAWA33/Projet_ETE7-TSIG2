function [N_values, P, coef, slope] = compute_power_proc_r(y, trend_fun)
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
    idx_fit = N_values >= 15 & N_values <= floor(M/10); % Avoid extreme values for the fit
    coef = polyfit(log(N_values(idx_fit)), log(P(idx_fit)), 1);
    slope = coef(1);
end