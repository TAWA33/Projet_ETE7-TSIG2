function [u, x, info] = case_rif_zeros(M)
    % Generates a MA(4) process: gaussian noise filtered by a FIR filter
    %  with 2 pairs of conjugate zeros
    % Input:
    %   M: number of samples
    % Outputs:
    %   u: gaussian noise column vector (input of the filter)
    %   x: filtered output
    %   info: struct with the filter coefficients (b, a), the normalized
    %         frequencies fn, the frequency response h, the case name and a
    %         short tag (GUI interface)

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