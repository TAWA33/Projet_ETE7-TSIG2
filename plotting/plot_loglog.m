function plot_loglog(Nv_y, P_y, coef_y, Nv_x, P_x, coef_x, slope_y, slope_x, name, fig_dir)
    figure('Name', "r's Power");
    loglog(Nv_y, P_y, 'x'); hold on;
    loglog(Nv_x, P_x, 'o');
    plot(Nv_y, exp(polyval(coef_y, log(Nv_y))), 'r-', 'LineWidth', 1.5);
    plot(Nv_x, exp(polyval(coef_x, log(Nv_x))), 'b-', 'LineWidth', 1.5);
    xlabel('N', 'FontSize', 20);
    ylabel('P(N)', 'FontSize', 20);
    title(sprintf('Slope with int. = %.3f | Without int. = %.3f', slope_y, slope_x), 'FontSize', 22);
    legend('With integration', 'Without integration', 'Fit with', 'Fit without', 'Location', 'best', 'FontSize', 20);
    set(gca, 'FontSize', 20);
    grid on;
    exportgraphics(gcf, fullfile(fig_dir, sprintf('power_in_func_N_%s.png', lower(strrep(name,' ','_')))), 'BackgroundColor', 'white');
end