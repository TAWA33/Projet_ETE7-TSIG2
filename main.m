close all ; clear all ; clc;
addpath(genpath(pwd));

rng(0); % Seed

cfg.M = 5000;
cfg.N_win = 50;
cfg.trend_fun = @proc_trend_2c2;   % trend method (2a/2b/2c1/2c2)
cfg.case_id = 'wgn';         % 'wgn' (RIF 4 zéros) ou 'ar2' (RII 4 pôles)
cfg.fig_dir = './Figures';
if ~exist(cfg.fig_dir, 'dir')
    mkdir(cfg.fig_dir);
end


switch cfg.case_id
    case 'wgn'
        [u, x, cfg_extra] = case_wgn(cfg.M);
        name = 'BBGC';
    case 'ar2'
        [u, x, cfg_extra] = case_ar2(cfg.M);
        name = 'AR(2)';
    otherwise
        error('cfg.case_id must be ''wgn'' or ''ar2''.');
end


y = integrate_signal(x);

trend_visu = cfg.trend_fun(y, cfg.N_win);
plot_local_trend(y, trend_visu, cfg.N_win, name, cfg.M, cfg.fig_dir);


[Nv_y, P_y, coef_y, slope_y] = compute_power_proc_r(y, cfg.trend_fun);
[Nv_x, P_x, coef_x, slope_x] = compute_power_proc_r(x, cfg.trend_fun); % without integration step.

plot_loglog(Nv_y, P_y, coef_y, Nv_x, P_x, coef_x, slope_y, slope_x, name, cfg.fig_dir);

fprintf('\n=== Feature (%s) ===\n', name);
fprintf('  with integration    : alpha = %.3f\n', slope_y);
fprintf('  without integration : alpha = %.3f\n', slope_x);


