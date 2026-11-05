function trend = proc_trend_2c2(x, N)
    M = length(x);
    nb_wind = floor(M/N);
    trend_x = zeros(M, 1);
    h = ones(1, N) / N;
    h_eq = zeros(1, 2*N-1);
    h_eq(N:2*N-1) = h;
    h_eq(1:N)= h_eq(1:N) + fliplr(h);
    for i = 1 : nb_wind
        full = conv(x((i-1) * N + 1 : i*N), h_eq);
        trend_segm = full(N:2*N-1);        
        trend_x((i-1) * N + 1 : i*N) = trend_segm;
    end
    trend = trend_x;
end