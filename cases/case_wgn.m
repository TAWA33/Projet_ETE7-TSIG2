function [u, x, info] = case_wgn(M)
    % Generates a centered white gaussian noise
    % Input:
    %   M: number of samples
    % Outputs:
    %   u: gaussian noise column vector
    %   x: output signal (same as u)
    %   info: empty struct (GUI interface)

    u = randn(M, 1);
    x = u;
    info = struct();
end