function [u, x, info] = case_ar2(M)
    R  = 0.95;
    fpole = 4/9; 
    p1 = R * exp(1i*2*pi*fpole);
    b  = 1;
    a  = poly([p1 conj(p1)]);
    u  = randn(M, 1);
    x  = filter(b, a, u);
    fn = -1/2 : 1/M : 1/2 - 1/M;
    h  = freqz(b, a, 2*pi*fn);
    info = struct('b', b, 'a', a, 'fn', fn, 'h', h);
end