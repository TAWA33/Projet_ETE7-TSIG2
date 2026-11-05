function [u, x, info] = case_rii_poles(M)
    R  = 0.99;
    f1 = 1/3;  f2 = 3/7;
    p1 = R * exp(1i*2*pi*f1);
    p2 = R * exp(1i*2*pi*f2);
    b = 1;
    a = poly([p1 conj(p1) p2 conj(p2)]);   % 4 pôles, RII
    u = randn(M, 1);
    x = filter(b, a, u);
    fn = -1/2 : 1/M : 1/2 - 1/M;
    h = freqz(b, a, 2*pi*fn);
    info = struct('b', b, 'a', a, 'fn', fn, 'h', h, 'name', 'RII 4 poles', 'tag', 'rii_poles');
end