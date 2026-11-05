function trend = proc_trend_2c1(x, N)
    M = length(x);
    nb_wind = floor(M/N);
    trend_x = zeros(M, 1);
    h = ones(1, N) / N;
    h_eq = conv(h, fliplr(h)); % Length = 2N-1 ; Shift = N-1
    for i = 1 : nb_wind
        full = conv(x((i-1) * N + 1 : i*N), h_eq); % Length = 3N-2
        trend_segm = full(N:2*N-1);
        trend_x((i-1) * N + 1 : i*N) = trend_segm;
    end
    trend = trend_x;
end