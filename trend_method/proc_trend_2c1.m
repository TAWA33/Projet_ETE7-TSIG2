function trend = proc_trend_2c1(x, N)
    x = x(:);
    h = ones(1, N) / N;
    h_eq = conv(h, flipud(h)); % Length = 2N-1 ; Shift = N-1

    full = conv(x, h_eq); % Length = 3N-2
    trend_x = full(N:N+length(x)-1);

    trend = trend_x;
end