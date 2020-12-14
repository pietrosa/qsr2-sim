% Simulates imaging data from two correlated modalities. This code was used
% to generate synthetic data used in all simulation studied in the below
% reference. See that paper for full information.

% Pietrosanu, M.,  Zhang, L., Kong, L., Seres, P., Elkady, A., Wilman,
% A.H., Cobzas, D. (2020). Stable anatomy detection in multimodal imaging
% through sparse group regularization: a comparative study of iron
% accumulation in the aging brain. [JOURNAL INFO TO BE UPDATED]

% Input arguments
%   n: number of observations
%   rho: AR1 spatial correlation parameter
%   eta: cross-modality correlation
%   sd: SD of background noise

% Output:
%   x: x{i} gives 32x32x8 data for the true effects for the i-th modality
%       (i=1,2)
%   A: A{i} gives nx(32*32*8) data for the observed imaging data for the
%       i-th modality (i=1,2)
%   y: simulated "response" variable
%   sz: image size
%   S: indicator true true support: 1,2,3,4 represents the four "block"
%      described in the paper; 0 represents background

function [x,A,y,sz,S]=synth_data(n,rho,eta,sd)

% image and block sizes
sz = [32,32,8]; % size of data
% perturb block size for the second modality
r_bounds1 = randi(3,2,4)-2;
r_bounds2 = [randi(2,1,2)-1; 0 0];
r_bounds_diff = [r_bounds1(1,:) + r_bounds1(2,:), r_bounds2(1,:) + r_bounds2(2,:)];
sz_block{1} = [8,8,4];
sz_block{2} = [8,8,4] + r_bounds_diff([3,4,6]);

for m=1:2
    shift1 = 2*(m-1);
    shift2 = m-1;
    [i,j,k] = meshgrid(...
        5+r_bounds1(1,1 + shift1) : 4+r_bounds1(1,1 + shift1)+sz_block{m}(1), ...
        5+r_bounds1(1,2 + shift1) : 4+r_bounds1(1,2 + shift1)+sz_block{m}(2), ...
        2+r_bounds2(1,1 + shift2) : 1+r_bounds2(1,1 + shift2)+sz_block{m}(3));
    ind_r{m}{1} = sub2ind(sz,i(:),j(:),k(:));
    ind_r{m}{2} = sub2ind(sz,i(:)+16,j(:),k(:));
    ind_r{m}{3} = sub2ind(sz,i(:),j(:)+16,k(:));
    ind_r{m}{4} = sub2ind(sz,i(:)+16,j(:)+16,k(:));
end

% sparse coefficients
x{1} = zeros(sz);
x{2} = zeros(sz);
for m=1:2
    x{m}(ind_r{m}{1}) = 0.1;
    x{m}(ind_r{m}{2}) = 0.2;
    x{m}(ind_r{m}{3}) = 0.3;
    x{m}(ind_r{m}{4}) = 0.4;
end

A=0;
y=0;

S = zeros(size(x{1}));
S(1:16,1:16,:)=1;
S(1:16,17:32,:)=3;
S(17:32,1:16,:)=2;
S(17:32,17:32,:)=4;

S(x{1}==0 | x{2}==0) = 0;


%--------------------------
% genarate the data matrix
mu_scal = 0;
sum_bsz = sz_block{1}+sz_block{2};
for m=1:3
    mu{m} = ones(sum_bsz(m)) .* mu_scal ./ 3;
    Sigma{m} = diag(ones(1,sum_bsz(m)));
    for i=1:sum_bsz(m)
        for j=i+1:sum_bsz(m)
            if(sign(i+0.5-sz_block{1}(m)) * sign(j+0.5-sz_block{1}(m)) == 1)
                % i,j reference same variable
                Sigma{m}(i,j) = rho^(j-i);
                Sigma{m}(j,i) = Sigma{m}(i,j);
            else
                % i,j reference different variable
                Sigma{m}(i,j) = eta*rho^abs(j-sz_block{1}(m)-i);
                Sigma{m}(j,i) = Sigma{m}(i,j);
            end
        end
    end
end

A = {zeros(n,prod(sz)), zeros(n,prod(sz))};
for i=1:n
    Ai = {sd*randn(sz), sd*randn(sz)}; % background noise for 2 vars
    for bk=1:4
        a1 = mvnrnd(mu{1},Sigma{1});
        a2 = mvnrnd(mu{2},Sigma{2});
        a3 = mvnrnd(mu{3},Sigma{3});
        % indices on var1 and var2 supports
        for j=1:2
            [i1,j1,k1] = meshgrid(1:sz_block{j}(1),1:sz_block{j}(2),1:sz_block{j}(3));
            i1 = i1(:); j1 = j1(:); k1 = k1(:);
            a = zeros(sz_block{j});
            a(sub2ind(sz_block{j},i1,j1,k1))=(a1(i1)+a2(j1)+a3(k1))/3;
            Ai{j}(ind_r{j}{bk}) = a(:);
            A{j}(i,:)=Ai{j}(:);
        end
    end
end


% simulate response
w = [0.01; x{1}(:); x{2}(:)];
X = [ones(n,1),A{1},A{2}];
y = X*w + randn(n,1);
