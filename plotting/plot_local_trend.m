function plot_local_trend(y, trend, N_win, name, M, fig_dir)
    t0 = 1;
    t1 = length(y);
    t = (t0:t1)';
    figure('Name', sprintf('Local trend - %s', name));
    plot(t, y(t0:t1), 'DisplayName', 'Integrated signal y[n]');
    hold on;
    plot(t, trend(t0:t1), 'r-', 'DisplayName', sprintf('Local Trend (N=%d)', N_win));
    hold off;
    xlabel('Sample n', 'FontSize', 20);
    ylabel('Amplitude', 'FontSize', 20);
    title(sprintf('%s : signal and local trend (M=%d, N=%d)', name, M, N_win), 'FontSize', 22);
    legend('Location', 'best', 'FontSize', 20);
    set(gca, 'FontSize', 20);
    grid on;
    xlim([t0 t1]);
    exportgraphics(gcf, fullfile(fig_dir, sprintf('trend_local_%s.png', lower(strrep(name,' ','_')))), 'BackgroundColor', 'white');
end