function [u, x, info] = case_rii_poles(M)
    % Generates an AR(4) process: gaussian noise filtered by an all-pole
    % IIR filter with 2 pairs of conjugate poles
    % Input:
    %   M: number of samples
    % Outputs:
    %   u: gaussian noise column vector (input of the filter)
    %   x: filtered output
    %   info: struct with the filter coefficients (b, a), the normalized
    %         frequencies fn, the frequency response h, the case name and a
    %         short tag (GUI interface)

    R  = 0.99;
    f1 = 1/3;  f2 = 3/7;
    p1 = R * exp(1i*2*pi*f1);
    p2 = R * exp(1i*2*pi*f2);
    b = 1;
    a = poly([p1 conj(p1) p2 conj(p2)]);
    u = randn(M, 1);
    x = filter(b, a, u);
    fn = -1/2 : 1/M : 1/2 - 1/M;
    h = freqz(b, a, 2*pi*fn);
    info = struct('b', b, 'a', a, 'fn', fn, 'h', h, 'name', 'RII 4 poles', 'tag', 'rii_poles');
end