function plot_local_trend(y, trend, N_win, name, M, fig_dir)
    t0 = 1;
    t1 = min(20*N_win, length(y)); % We plot only 20 windows
    t = (t0:t1)';
    figure('Name', sprintf('Local trend - %s', name));
    plot(t, y(t0:t1), 'DisplayName', 'Integrated signal y[n]');
    hold on;
    plot(t, trend(t0:t1), 'r-', 'DisplayName', sprintf('Local Trend (N=%d)', N_win));
    hold off;
    xlabel('Sample n'); ylabel('Amplitude');
    title(sprintf('%s : signal and local trend (M=%d, N=%d)', name, M, N_win));
    legend('Location', 'best'); grid on;
    xlim([t0 t1]);
    exportgraphics(gcf, fullfile(fig_dir, sprintf('trend_local_%s.png', lower(strrep(name,' ','_')))), 'BackgroundColor', 'white');
end