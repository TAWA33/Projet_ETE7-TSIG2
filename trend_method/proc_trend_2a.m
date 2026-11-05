function trend = proc_trend_2a(x, N, k)
    if nargin < 3
        k = 1;
    end
    M = length(x);
    nb_wind = floor(M/N);
    trend_x = zeros(M, 1);
    for i = 1 : nb_wind
        % trend_segm = mean(x((i-1) * N + 1 : i*N)); % k = 0
        p = polyfit(1:N, x((i-1) * N + 1 : i*N), k);
        trend_segm = polyval(p, 1:N);
        trend_x((i-1) * N + 1 : i*N) = trend_segm;
    end
    trend = trend_x;
end