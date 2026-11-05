function plot_pole_zero_diagram(b, a, fn, h)
    figure('Name','Pôle/Zero + Transf Func');
    title('Pole/Zero diagram + Transfert function');
    
    subplot(3, 1, 1);
    zplane(b, a);
    title('Pole-zero diagram');
    grid on;
    
    subplot(3, 1, 2);
    plot(fn, abs(h), 'LineWidth', 1.5);
    xlabel('Normalized frequency f/f_e');
    ylabel('|H(f)|');
    title('Magnitude response');
    grid on;
    xlim([-0.5 0.5]);
    
    subplot(3, 1, 3);
    plot(fn, angle(h), 'LineWidth', 1.5);
    xlabel('Normalized frequency f/f_e');
    ylabel('Phase (rad)');
    title('Phase response');
    grid on;
    xlim([-0.5 0.5]);

    sgtitle('Pole-Zero diagram + Transfer function', 'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
end