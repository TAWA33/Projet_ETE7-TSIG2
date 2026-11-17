function plot_pole_zero_diagram(b, a, fn, h)
    % Plots the pole-zero diagram of the filter, and the magnitude and
    % phase of its frequency response
    % Inputs:
    %   b: numerator coefficients of the filter
    %   a: denominator coefficients of the filter
    %   fn: normalized frequencies
    %   h: frequency response of the filter at fn
    % No output

    figure('Name','Pôle/Zero + Transf Func');
    title('Pole/Zero diagram + Transfert function');
    
    subplot(3, 1, 1);
    zplane(b, a);
    title('Pole-zero diagram', 'FontSize', 18);
    grid on;
    
    subplot(3, 1, 2);
    plot(fn, abs(h), 'LineWidth', 1.5);
    xlabel('Normalized frequency f/f_e', 'FontSize', 16);
    ylabel('|H(f)|', 'FontSize', 16);
    title('Magnitude response', 'FontSize', 18);
    grid on;
    xlim([-0.5 0.5]);
    
    subplot(3, 1, 3);
    plot(fn, angle(h), 'LineWidth', 1.5);
    xlabel('Normalized frequency f/f_e', 'FontSize', 16);
    ylabel('Phase (rad)', 'FontSize', 16);
    title('Phase response', 'FontSize', 18);
    grid on;
    xlim([-0.5 0.5]);

    sgtitle('Pole-Zero diagram + Transfer function', 'Color', 'k', 'FontSize', 20, 'FontWeight', 'bold');
end