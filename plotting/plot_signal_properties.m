function plot_signal_properties(u, fn, N, sigName)
    U = fftshift(fft(u));
    periodo = (abs(U).^2) / N; 
    mean_perio = mean(periodo);
    R_uu = xcorr(u, 'biased');
    lags = -(N-1):(N-1);

    strMeanPerio = sprintf('mean(|%s|^2/N) = %.4f', upper(sigName), mean_perio);

    figure('Name', sprintf('%s Properties', sigName));
    
    subplot(3, 1, 1);
    plot(fn, 10*log10(abs(U)));
    ylabel(sprintf('|%s(f)|', upper(sigName)), 'FontSize', 16);
    xlabel('Normalized frequency f/f_e', 'FontSize', 16);
    set(gca, 'FontSize', 16);
    xlim([-0.5 0.5]);
    title(sprintf('Amplitude spectrum of %s', sigName), 'FontSize', 18);
    grid on;

    subplot(3, 1, 2);
    plot(fn, 10*log10(periodo));
    ylabel(sprintf('|%s(f)|^2 / N  (dB)', upper(sigName)), 'FontSize', 16);
    xlabel('Normalized frequency f/f_e', 'FontSize', 16);
    title(sprintf('Power spectral density estimation of %s', sigName), 'FontSize', 18);
    set(gca, 'FontSize', 16);
    xlim([-0.5 0.5]);
    legend(strMeanPerio, 'Location', 'northeast', 'FontSize', 12);
    
    subplot(3, 1, 3);
    plot(lags, R_uu);
    ylabel(sprintf('R_{%s %s}', sigName, sigName), 'FontSize', 16);
    xlabel('Lag \tau', 'FontSize', 16);
    xlim([-500 500]);
    set(gca, 'FontSize', 16);
    grid on;
    title(sprintf('Autocorrelation of %s', sigName), 'FontSize', 18);
    
    sgtitle(sprintf('Statistical properties of %s', sigName), 'Color', 'k', 'FontSize', 20, 'FontWeight', 'bold');
end