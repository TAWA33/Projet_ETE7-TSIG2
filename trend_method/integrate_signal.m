function y_cum = integrate_signal(x)
    % Integrates the signal: removes the mean of x, then takes the
    % cumulative sum
    % Input:
    %   x: input signal
    % Output:
    %   y_cum: integrated signal y(n)

    x_cent = x - mean(x);
    % y_cum = cumtrapz(1:length(x), x_cent); % Which one int. is better ?
    y_cum = cumsum(x_cent);
end