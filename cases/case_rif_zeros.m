function [u, x, info] = case_rif_zeros(M)
    R  = 0.95;
    f1 = 1/4;  f2 = 4/9;
    z1 = R * exp(1i*2*pi*f1);
    z2 = R * exp(1i*2*pi*f2);
    b = poly([z1 conj(z1) z2 conj(z2)]);
    a = 1;
    u = randn(M, 1);
    x = filter(b, a, u);
    fn = -1/2 : 1/M : 1/2 - 1/M;
    h = freqz(b, a, 2*pi*fn);
    info = struct('b', b, 'a', a, 'fn', fn, 'h', h, 'name', 'RIF 4 zeros', 'tag', 'rif_zeros');
end