function trend = proc_trend_2c2(x, N)
    % Estimates the local trend of x: zero-phase filtering with the 
    % equivalent filter (h(n) + h(-n))/2, where h = moving average of 
    % N samples
    % Inputs:
    %   x: input signal (usually the integrated signal y)
    %   N: window size (length of h)
    % Output:
    %   trend: local trend of x (same length as x)

    x = x(:);
    h = ones(N, 1) / N;
    h_eq = zeros(2*N-1, 1);
    h_eq(N:2*N-1) = h;
    h_eq(1:N)= h_eq(1:N) + flipud(h);
    h_eq = h_eq/2;
    full = conv(x, h_eq);

    trend = full(N:N+length(x)-1);
end