function [P_D, fn] = Daniell_periodogram(x, M)
    x = x(:);
    N = length(x);
    X = fftshift(fft(x));
    P = abs(X).^2 / N;
    if (mod(M, 2) == 0)
        error('M should be odd.');
    end
    J = (M - 1) / 2;
    P_D = zeros(1, N - 2 * J); % remove the samples at the extremities that do not have neighboring samples on the left or right
    for i = J + 1 : N - J
        P_D(i - J) = mean(P(i - J: i + J));
    end
    fn = -1/2 : 1/N : 1/2 - 1/N;
    fn = fn(J + 1: N - J);
end