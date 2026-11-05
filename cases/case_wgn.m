function [u, x, info] = case_wgn(M)
    u = randn(M, 1);
    x = u;
    info = struct();
end