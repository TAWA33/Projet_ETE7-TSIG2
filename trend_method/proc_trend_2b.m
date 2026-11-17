function trend = proc_trend_2b(x, N)
    % Estimates the local trend of x: causal FIR moving average
    % over the last N samples, then shifted by its group delay (N-1)/2
    % to put the trend back in line with x
    % Inputs:
    %   x: input signal
    %   N: window size (length of the filter)
    % Output:
    %   trend: local trend of x (same length as x, last samples set to 0)

    x = x(:);
    h = ones(N, 1)/N;
    tau_group = floor((N-1)/2);
    trend_x = filter(h, 1, x);

    trend = trend_x(tau_group+1:end);
    trend = [trend; zeros(tau_group,1)];
end