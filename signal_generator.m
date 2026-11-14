close all ; clear all ; clc;
addpath(genpath(pwd));

rng(0); % Seed

cfg.M = 2000;
cfg.fig_dir = './Figures/Random_sig';
if ~exist(cfg.fig_dir, 'dir')
    mkdir(cfg.fig_dir);
end

cases = {@case_rif_zeros, @case_rii_poles};

for k = 1:numel(cases)
    [u, x, info] = cases{k}(cfg.M);
    tag = info.tag;

    plot_pole_zero_diagram(info.b, info.a, info.fn, info.h);
    exportgraphics(gcf, fullfile(cfg.fig_dir, sprintf('diagram_%s.png', tag)), 'BackgroundColor', 'white', 'Resolution', 300);

    plot_signal_properties(u, info.fn, cfg.M, 'u');
    exportgraphics(gcf, fullfile(cfg.fig_dir, sprintf('%s_u_prop.png', tag)), 'BackgroundColor', 'white', 'Resolution', 300);

    plot_signal_properties(x, info.fn, cfg.M, 'x');
    exportgraphics(gcf, fullfile(cfg.fig_dir, sprintf('%s_x_prop.png', tag)), 'BackgroundColor', 'white', 'Resolution', 300);

    plot_signal(u, x, cfg.M);
    exportgraphics(gcf, fullfile(cfg.fig_dir, sprintf('%s_IO.png', tag)), 'BackgroundColor', 'white', 'Resolution', 300);
end