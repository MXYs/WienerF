function [npm_val] = npm(h, hhat)

% Normalized Projection Misalignment 
%
%   [npm_val] = npm(h, hhat)
%
%	Input Parameters [size]:
%       h       : true impulse responses [L x M]
%       hhat    : estimated impulse responses [L x M]
%
%	Output Parameter:
%       npm_val : Normalize Projection Misalignment
%
%	References:
%       [1] D. R. Morgan, J. Benesty and M. M. Sondhi, "On the evaluation of
%           estimated impulse responses," IEEE Signal Processing Lett., Vol. 5, No.
%           7, pp. 174-176 Jul 1998.
%   
%       [2] Y. Huang and J. Benesty, "Frequency-Domain adaptive approaches to
%           blind multi-channel identification," IEEE Trans. Sig. Process. Vol. 51
%           No. 1, pp/ 11-24, Jan 2003.
%
% Authors: N.D. Gaubitch and E.A.P. Habets 
%
% History: 2004-04-26 - Initial version by NG
%          2009-10-28 - reshape when the size of h_hat differs from h
%
% Copyright (C) Imperial College London 2009-2010
% Version: $Id: npm.m 425 2011-08-12 09:15:01Z mrt102 $

if size(hhat,1) <= size(h,1)
    hv = reshape(h(1:size(hhat,1),:),[],1);
    hhatv = hhat(:);
else
    % hv = h(:);
    % hhatv = reshape(hhat(1:size(h,1),:),[],1);
    h = [h ; zeros(size(hhat,1)-size(h,1),size(h,2))];
    hv = h(:);
    hhatv = hhat(:);
end

epsilon = hv-((hv.'*hhatv)/(hhatv.'*hhatv))*hhatv;
npm_val = norm(epsilon)/norm(hv);
