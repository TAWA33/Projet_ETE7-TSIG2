function trend = proc_trend_2b(x, N)
    M = length(x);
    nb_wind = floor(M/N);
    trend_x = zeros(M, 1);
    for i = 1 : nb_wind
        z = exp(1j*2*pi*(1:N-1)/N);
        b = real(poly(z)) / N;
        trend_segm = filter(b, 1, x((i-1) * N + 1 : i*N));  
        trend_x((i-1) * N + 1 : i*N) = trend_segm;
    end
    trend = trend_x;
end