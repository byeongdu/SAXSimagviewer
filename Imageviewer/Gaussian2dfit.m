function fit2dpeak = Gaussian2dfit(Xp, Yp, img0, varargin)
% function fit2dpeak = Gaussian2dfit(Xp, Yp, img0)
% Fitting with 2D Gaussian function
% For a single peak fitting:
%   Xp = [x_i, x_f] and Yp = [y_i, y_f], where elements are indices of a
%   fullsize image img0. They represent ROI
% Can be used for multiple peaks too.

    img0 = double(img0);
    numpeak = size(Xp, 1);
    fit2dpeak.A = [];
    fit2dpeak.X = [];
    fit2dpeak.Y = [];
    fit2dpeak.param = [];
ROIx = 0;
ROIy = 0;
xwidth = -1;
ywidth = -1;
if ~isempty(varargin)
    for i=1:2:numel(varargin)-1
        switch varargin{i}
            case 'xwidth'
                xwidth = varargin{i+1};
            case 'ywidth'
                ywidth = varargin{i+1};
            case 'ROIx'
                ROIx = varargin{i+1};
            case 'ROIy'
                ROIy = varargin{i+1};
        end
    end
end

if (size(Xp, 2) ==1) & (size(Yp, 2)==1) % if Xp and Yp are the center of the peak
    xc = Xp;
    yc = Yp;
    if (ROIx ==0) & (ROIy==0)
        error('Input should be either ROIs, or ROIx and ROIy should be entered.')
    end
    Xp = [xc-ROIx, xc+ROIx];
    Yp = [yc-ROIy, yc+ROIy];
end
    
    for i=1:numpeak
        % initialize p
        p = zeros(1, 6);
        LowerB = p;
        UpperB = p;
        % ROIing the image.
        rY = round(sort(Yp(i, 1:2)));
        rX = round(sort(Xp(i, 1:2)));
        img = img0(rY(1):rY(2), rX(1):rX(2));
        % A
        [p(1), ind] = max(img(:));
        LowerB(1) = 1;
        UpperB(1) = p(1)*10000;
        [y0ind, x0ind] = ind2sub(size(img), ind);
        % x0
%            p((i-1)*6+2) = x0ind;
        p(2) = x0ind;
        LowerB(2) = 1;
        UpperB(2) = size(img, 2);
        % y0
        p(3) = y0ind;
        LowerB(3) = 1;
        UpperB(3) = size(img, 1);
        % xwidth
        if xwidth==-1
            p(4) = size(img, 2)/2;
        else
            p(4) = xwidth;
        end
        LowerB(4) = 1;
        UpperB(4) = size(img, 2);
        % ywidth
        if ywidth == -1
            p(5) = size(img, 1)/2;
        else
            p(5) = ywidth;
        end
        LowerB(5) = 1;
        UpperB(5) = size(img, 1);
        p(6) = 0.01;
        LowerB(6) = -0.5;
        UpperB(6) = 0.5;

        back = mean([img(1, 1), img(1, end), img(end, 1), img(end, end)]);
        dYint = img(end, 1) - img(1,1);
        dXint = img(1, end) - img(1, 1);

        p(end+1:end+3) = [back, dXint/size(img, 2), dYint/size(img, 2)];
        LowerB(end+1:end+3) = [back/10, -10, -10];
        UpperB(end+1:end+3) = [back*100, 10, 10];
        options = optimset('fminsearch');
        options = optimset(options, 'TolX',0.0000001);
        options = optimset(options, 'MaxIter',50000);
        [dy, dx] = size(img);
        x_img = 1:dx;
        y_img = 1:dy;
        [Xd,Yd] = meshgrid(x_img,y_img);

        disp('Data fitting ... wait a while.')
        INLP = fminsearchcon(@(x) fitwith2dgaussian(x,img, {Xd, Yd}),p,LowerB, UpperB, [], [], [], options);

        fit2dpeak.A(i) = INLP(1);
        xc = INLP(2);
        yc = INLP(3);
        %INLP(2) = xc+min(rX)-1;
        %INLP(3) = yc+min(rY)-1;
        fit2dpeak.X(i) = xc+min(rX)-1;
        fit2dpeak.Y(i) = xc+min(rY)-1;
        fit2dpeak.param = [fit2dpeak.param; [INLP(1), xc, yc, INLP(4:end)]];
        [err, imgc, integI]=fitwith2dgaussian(INLP, img,{Xd, Yd});
        assignin('base', 'fit2dpeak', fit2dpeak);
        disp('Data fitting done')
        disp('You can see fitted 2D as follow:')
        disp('[e,imgc]=fitwith2dgaussian(fit2dpeak.param, fit2dpeak.xarr,{fit2dpeak.xarr, fit2dpeak.yarr});')
        disp('imagesc(imgc)')
        fprintf('%0.2f, %0.2f, %0.2f, %0.4f, %0.4f, %0.4f, %0.2f, %0.2f, %0.2f\n', INLP)
        figure;
        subplot(2,2,1); contour(x_img, y_img, log10(abs(double(img))));
        title('Measured')
        subplot(2,2,2); contour(x_img, y_img, log10(abs(double(imgc))));
        title('Fit')
        subplot(2,2,4); plot(y_img, double(imgc(:, round(xc))), 'ro-', ...
            y_img, double(img(:, round(xc))), 'bs-');
        % subplot(2,2,4); plot(y_img, double(imgc(:, fix(dx/2))), 'ro-', ...
        %     y_img, double(img(:, fix(dx/2))), 'bs-');
        title(sprintf('y_c = %0.3f', fit2dpeak.Y(i)));
        subplot(2,2,3); plot(x_img, double(imgc(round(yc), :)), 'ro-', ...
            x_img, double(img(round(yc), :)), 'bs-');
        % subplot(2,2,3); plot(x_img, double(imgc(fix(dy/2), :)), 'ro-', ...
        %     x_img, double(img(fix(dy/2), :)), 'bs-');
        title(sprintf('x_c = %0.3f', fit2dpeak.X(i)));
        sgtitle(sprintf('#%i: Area = %0.4e, Integrated = %0.4e, fit error = %0.3e', i, fit2dpeak.A(i), integI, err));
        drawnow
    end
    fprintf('\n');
    fprintf('\n');
    fprintf('Summary of fitting.....\n');
    fprintf('x_c, y_c, Area\n');
    for i=1:numpeak
        fprintf('%0.2f, %0.2f, %0.4e\n', fit2dpeak.X(i), fit2dpeak.Y(i), fit2dpeak.A(i));  
    end
end