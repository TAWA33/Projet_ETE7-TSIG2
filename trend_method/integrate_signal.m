function y_cum = integrate_signal(x)
    x_cent = x - mean(x);
    % y_cum = cumtrapz(1:length(x), x_cent); % Which one int. is better ?
    y_cum = cumsum(x_cent);
end