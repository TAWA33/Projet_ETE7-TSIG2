function trend = proc_trend_2b(x, N)
    x = x(:);
    h = ones(N, 1)/N;
    tau_group = floor((N-1)/2);
    trend_x = filter(h, 1, x);

    trend = trend_x(tau_group+1:end);
    trend = [trend; zeros(tau_group,1)];
end