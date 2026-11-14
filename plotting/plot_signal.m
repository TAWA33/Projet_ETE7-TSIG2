function plot_signal(x, y, n)

    mean_x = mean(x);
    mean_y = mean(y);

    strMeanX = sprintf('mean(x) = %.4f', mean_x);
    strMeanY = sprintf('mean(y) = %.4f', mean_y);

    figure('Name','I/O Signals');
    subplot(3, 1, 1);
    plot(1:1:n, y, 'Color', '#0072BD', 'DisplayName', 'Output y[n]');
    hold on;
    plot(1:1:n, x, 'Color', '#D95319', 'DisplayName', 'Input x[n]');
    xlabel('Sample', 'FontSize', 16);
    ylabel('Signal', 'FontSize', 16);
    title('Input & Output Signal', 'FontSize', 18);
    set(gca, 'FontSize', 16);
    grid on;
    legend('Location','best', 'FontSize', 12);
    xlim([1 n]);
    
    subplot(3, 1, 2);
    plot(1:1:n, x, 'Color', '#D95319');
    xlabel('Sample', 'FontSize', 16);
    ylabel('Signal', 'FontSize', 16);
    title('Input Signal', 'FontSize', 18);
    legend(strMeanX, 'Location', 'northeast', 'FontSize', 12);
    set(gca, 'FontSize', 16);
    grid on;
    
    
    subplot(3, 1, 3);
    plot(1:1:n, y, 'Color', '#0072BD');
    xlabel('Sample', 'FontSize', 16);
    ylabel('Signal', 'FontSize', 16);
    title('Output signal', 'FontSize', 18);
    legend(strMeanY, 'Location', 'northeast', 'FontSize', 12);
    set(gca, 'FontSize', 16);
    grid on;

    sgtitle('Time-domain signals (I/O)', 'Color', 'k', 'FontSize', 20, 'FontWeight', 'bold');
end