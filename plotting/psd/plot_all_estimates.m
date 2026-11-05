function plot_all_estimates(x, fn_theo, DSP, params, sigName, tag, fig_dir)
    [P,   fn] = periodo(x);
    [P_D, fn_D] = Daniell_periodogram(x, params.M_D);
    [P_B, fn_B] = Bartlett_periodogram(x, params.M_BW);
    [P_W, fn_W] = Welch_periodogram(x, params.M_BW, params.k_W);
    [P_c, fn_c] = correlogram(x, params.L_corr);

    DSP_dB = 10*log10(DSP);

    figure('Name', sprintf('PSD estimates - %s', sigName));

    subplot(2,3,1);
    plot(fn, 10*log10(P)); 
    hold on;
    plot(fn_theo, DSP_dB);
    hold off;
    title('Periodogram'); 
    xlabel('Normalized frequency'); 
    ylabel('PSD (dB)'); 
    grid on;

    subplot(2,3,2);
    plot(fn_D, 10*log10(P_D));
    hold on;
    plot(fn_theo, DSP_dB);
    hold off;
    title(sprintf('Daniell, M = %d', params.M_D));
    xlabel('Normalized frequency');
    ylabel('PSD (dB)');
    grid on;

    subplot(2,3,3);
    plot(fn_B, 10*log10(P_B));
    hold on;
    plot(fn_theo, DSP_dB);
    hold off;
    title(sprintf('Bartlett, M = %d', params.M_BW));
    xlabel('Normalized frequency'); 
    ylabel('PSD (dB)'); 
    grid on;

    subplot(2,3,4);
    plot(fn_W, 10*log10(P_W));
    hold on;
    plot(fn_theo, DSP_dB);
    hold off;
    title(sprintf('Welch, M = %d, k = %g', params.M_BW, params.k_W));
    xlabel('Normalized frequency');
    ylabel('PSD (dB)');
    grid on;

    subplot(2,3,5);
    plot(fn_c, 10*log10(P_c));
    hold on;
    plot(fn_theo, DSP_dB);
    hold off;
    title(sprintf('Correlogram, L = %d', params.L_corr));
    xlabel('Normalized frequency');
    ylabel('PSD (dB)');
    grid on;

    legend({'Estimate', 'Theoretical PSD'}, 'Location', 'south', 'FontSize', 11, 'Position', [0.72 0.25 0.15 0.08]);

    sgtitle(sprintf('PSD estimates of the %s', sigName), 'FontSize', 13);

    exportgraphics(gcf, fullfile(fig_dir, sprintf('DSP_est_%s.png', tag)), 'BackgroundColor', 'white');
end