function trend = proc_trend_2c2(x, N)
    x = x(:);
    h = ones(N, 1) / N;
    h_eq = zeros(2*N-1, 1);
    h_eq(N:2*N-1) = h;
    h_eq(1:N)= h_eq(1:N) + flipud(h);
    h_eq = h_eq/2;
    full = conv(x, h_eq);

    trend = full(N:N+length(x)-1);
end