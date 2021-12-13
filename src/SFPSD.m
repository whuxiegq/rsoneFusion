function SFPSD = SFPSD(I_PAN, I_MS_LR, ratio, flag_filtMethod, flag_eq)
%SFPSD 此处显示有关此函数的摘要
%   此处显示详细说明

% 是否做均衡化,0为不做，1为做
% flag_eq = 1;
% 空间域还是频率域滤波，0为空间域，1为频率域
% flag_filtMethod = 0;

I_PAN = double(I_PAN);
I_MS_LR = double(I_MS_LR);

h=[1 4 6 4 1 ]/16;
g=[0 0 1 0 0 ]-h;
htilde=[ 1 4 6 4 1]/16;
gtilde=[ 0 0 1 0 0 ]+htilde;
h=sqrt(2)*h;
g=sqrt(2)*g;
htilde=sqrt(2)*htilde;
gtilde=sqrt(2)*gtilde;
WF={h,g,htilde,gtilde};

Levels = ceil(log2(ratio));

if flag_eq == 1
   % 滤波,降到与I_MS_LR相同分辨率
    pan_filt = zeros(size(I_MS_LR));

    for b = 1 :  size(I_MS_LR, 3)
        pan_temp = I_PAN;
        pan_temp = (pan_temp - mean2(pan_temp)).*(std2(I_MS_LR(:,:,b))./std2(pan_temp)) + mean2(I_MS_LR(:,:,b));  
        if flag_filtMethod == 0
            W = fspecial('gaussian',[11,11],1.6);
            for i = 1 : Levels
               pan_temp = imfilter(pan_temp, W, 'replicate');
               pan_temp = imresize(pan_temp,1./2);
            end
        else
            WT = ndwt2_working(pan_temp,Levels,WF);
            for ii = 2 : numel(WT.dec), WT.dec{ii} = zeros(size(WT.dec{ii})); end
            pan_temp = indwt2_working(WT,'c');
            pan_temp = imresize(pan_temp, 1.0/ratio);
        end
        pan_filt(:,:,b) = pan_temp;
    end
else
    pan_filt = I_PAN;
    if flag_filtMethod == 0
        W = fspecial('gaussian',[11,11],1.6);
        for i = 1 : Levels
           pan_filt = imfilter(pan_filt, W, 'replicate');
           pan_filt = imresize(pan_filt,1./2);
        end
    else
        WT = ndwt2_working(pan_filt,Levels,WF);
        for ii = 2 : numel(WT.dec), WT.dec{ii} = zeros(size(WT.dec{ii})); end
        pan_filt = indwt2_working(WT,'c');
        pan_filt = imresize(pan_filt, 1.0/ratio);
%           for i = 1 : Levels
%               WT = ndwt2_working(pan_filt,1,WF);
%               for ii = 2 : numel(WT.dec), WT.dec{ii} = zeros(size(WT.dec{ii})); end
%               pan_filt = indwt2_working(WT,'c');
%               pan_filt = imresize(pan_filt,1./2);
%           end
    end
end

p = zeros(size(I_MS_LR));

for i = 1 : size(I_MS_LR, 3)
    if flag_eq == 1
        p(:,:,i) = I_MS_LR(:,:,i) ./ (pan_filt(:,:,i) + eps);
    else
        p(:,:,i) = I_MS_LR(:,:,i) ./ (pan_filt + eps);
    end
    
end

% minDN = min(min(I_PAN));
% maxDN = max(max(I_PAN));

I_PAN = repmat(I_PAN,[1 1 size(I_MS_LR,3)]);

if flag_eq == 1
    for ii = 1 : size(I_MS_LR,3)    
      I_PAN(:,:,ii) = (I_PAN(:,:,ii) - mean2(I_PAN(:,:,ii))).*(std2(I_MS_LR(:,:,ii))./std2(I_PAN(:,:,ii))) + mean2(I_MS_LR(:,:,ii));  
    end
end



p = imresize(p, ratio);

% SFPSD = zeros(size(I_MS_LR));

for i = 1 : size(I_MS_LR, 3)
    SFPSD(:,:,i) = I_PAN(:,:,i) .* p(:,:,i);
end

% SFPSD(SFPSD > maxDN) = maxDN;
% SFPSD(SFPSD < minDN) = minDN;
    
    
end

