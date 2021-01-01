function m = grid_kb(d,k,w,n,oversample,kbwidth,kbbeta,trimming,apodize,postcompensate)

% function m = grid2w(d,k,w,n,oversample,kbwidth,kbbeta[,trimming[,apodize[,postcompensate]]])
%     d          -- k-space data
%     k          -- k-trajectory, scaled -0.5 to 0.5
%     w          -- k-space weighting
%     n          -- image size (m will be (oversample*n) ^ 2 )
%     oversample -- oversampling of cartesian grid
%     kbwidth    -- FULL width of Kaiser-Bessel Kernel
%     kbbeta     -- Shape parameter (Beta) of KB kernel
%
% optional arguments (default is listed first)
%     trimming      -- 'y' or 'n'
%     apodize       -- 'y' or 'n'
%     postcompensate -- 'n' or 'y'
%
% output
%     m -- gridded k-space data
%

% Some defaults for options...
if (exist('trimming')~=1),      trimming='y';        end
if (exist('apodize')~=1),       apodize='y';         end
if (exist('postcompensate')~=1), postcompensate='n'; end

% convert to single column
d = d(:);
k = k(:);
w = w(:);

% preweight
dw = d.*w;

% convert k-space samples to matrix indices
nx = (oversample*n/2+1) + oversample*n*real(k);
ny = (oversample*n/2+1) + oversample*n*imag(k);

m = zeros(oversample*n,oversample*n);
if (postcompensate=='y')
    a=m;
end

% loop over samples in kernel
for lx = -floor(kbwidth*oversample/2):floor(kbwidth*oversample/2),
    for ly = -floor(kbwidth*oversample/2):floor(kbwidth*oversample/2),

        % find nearest samples
        nxt = round(nx+lx);
        nyt = round(ny+ly);

        % separable triangular window
        %    kwx = max(1-(1/oversample)*abs(nx-nxt),0);
        %    kwy = max(1-(1/oversample)*abs(ny-nyt),0);

        kwx = kaiser_bessel_kern((nx-nxt)/oversample,kbwidth,kbbeta);
        kwy = kaiser_bessel_kern((ny-nyt)/oversample,kbwidth,kbbeta);

        % if data falls outside matrix, put it at the edge
        nxt = max(nxt,1); nxt = min(nxt,oversample*n);
        nyt = max(nyt,1); nyt = min(nyt,oversample*n);

        % accumulate gridded data
        if (postcompensate=='y')
            a = a+sparse(nxt,nyt, w.*kwx.*kwy,oversample*n,oversample*n);
        end
        m = m+sparse(nxt,nyt,dw.*kwx.*kwy,oversample*n,oversample*n);
    end;
end;

% zero out data at edges
m(:,1) = m(:,1)*0; m(:,oversample*n) = m(:,oversample*n)*0;
m(1,:) = m(1,:)*0; m(oversample*n,:) = m(oversample*n,:)*0;

% If post density compensation is required...
if (postcompensate=='y')
    %disp('Doing post gridding compensation with Auxilliary Array')
    a(:,1) = a(:,1)*0; a(:,oversample*n) = a(:,oversample*n)*0;
    a(1,:) = a(1,:)*0; a(oversample*n,:) = a(oversample*n,:)*0;

    indx = find (abs(a)>1e-5);
    m(indx) = m(indx) ./ a(indx);
end

% Create apodization function if desired
if (apodize=='y')
    %disp('Calculating apodization function')
    a = zeros(oversample*n,oversample*n); % apodization function
    indx = -floor(oversample*kbwidth/2):floor(oversample*kbwidth/2);
    kwx = kaiser_bessel_kern(indx/oversample,kbwidth,kbbeta);
    %   f=gcf; figure,plot(kwx),figure(f)
    kwy = kaiser_bessel_kern(indx/oversample,kbwidth,kbbeta);
    a(oversample*n/2+1+indx,oversample*n/2+1+indx) = max(kwx',0)* max(kwy,0);
    % Remove apodization from convolution with triangle function.
    a=fftshift(fft2(fftshift(a)));
    a=real(a)/a(oversample*n/2+1,oversample*n/2+1);
    indx=find(a<1e-5); % make sure we don't blow up!
    a(indx)=ones(size(indx));
end

if (apodize =='y')
    m=fftshift(fft2(fftshift(m)));
    m=m./a;
    m=fftshift(ifft2(fftshift(m)));
end


if (trimming=='y')
    %disp('Trimming matrix')
    %    trim=(-n/2:n/2-1);
    %    m=m(oversample*n/2+1+trim,:);
    %    m=m(:,oversample*n/2+1+trim)/oversample/oversample;
    im = ifft2(m);
    im = im(1:n, :);
    im = im(:, 1:n);
     m = fft2(im);
end

