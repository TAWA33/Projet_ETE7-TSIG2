close all ; clear all ; clc;
addpath(genpath(pwd));

rng(0);

cfg.M = 2000;
cfg.fig_dir = './Figures';
if ~exist(cfg.fig_dir, 'dir')
    mkdir(cfg.fig_dir);
end

params.M_D = 11;
params.M_BW = 256;
params.k_W = 2;
params.L_corr = 200;

cases = {@case_rif_zeros, @case_rii_poles};

for k = 1:numel(cases)
    [~, x, info] = cases{k}(cfg.M);

    DSP = abs(info.h).^2;

    plot_all_estimates(x, info.fn, DSP, params, info.name, info.tag, cfg.fig_dir);
end