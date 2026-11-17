function [u, x, info] = case_ar2(M)
    % Generates an AR(2) process: gaussian noise filtered by an all-pole filter
    % with one pair of conjugate poles
    % Input:
    %   M: number of samples
    % Outputs:
    %   u: gaussian noise column vector (input of the filter)
    %   x: filtered output
    %   info: struct with the filter coefficients (b, a), the normalized
    %         frequencies fn and the frequency response h (GUI interface)
 
    R = 0.95;
    fpole = 4/9; 
    p1 = R * exp(1i*2*pi*fpole);
    b = 1;
    a = poly([p1 conj(p1)]);
    u = randn(M, 1);
    x = filter(b, a, u);
    fn = -1/2 : 1/M : 1/2 - 1/M;
    h = freqz(b, a, 2*pi*fn);
    info = struct('b', b, 'a', a, 'fn', fn, 'h', h);
end