function plot_signal(x, y, n)

    mean_x = mean(x);
    mean_y = mean(y);

    strMeanX = sprintf('mean(x) = %.4f', mean_x);
    strMeanY = sprintf('mean(y) = %.4f', mean_y);

    figure('Name','I/O Signals');
    subplot(3, 1, 1);
    plot(1:1:n, y, 'LineWidth', 1.2, 'DisplayName', 'Output y[n]');
    hold on;
    plot(1:1:n, x, 'LineWidth', 1.2, 'DisplayName', 'Input x[n]');
    xlabel('Sample');
    ylabel('Signal');
    title('Input & Output Signal');
    grid on;
    legend('Location','best');
    xlim([1 n]);
    
    subplot(3, 1, 2);
    plot(1:1:n, x);
    xlabel('Sample');
    ylabel('Signal');
    title('Input Signal');
    legend(strMeanX, 'Location', 'northeast');
    grid on;
    
    
    subplot(3, 1, 3);
    plot(1:1:n, y);
    xlabel('Sample');
    ylabel('Signal');
    title('Output signal');
    legend(strMeanY, 'Location', 'northeast');
    grid on;

    sgtitle('Time-domain signals (I/O)', 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
end