function y = testFq(varargin)
% y=SchultzSphereFun(varargin)
% analytical equation
%   without any varargin, the function prints default parameters.
% y=SchultzSphereFun(q, r, fwhm)  
isgifit = 0;
if isempty(varargin)
    y = {'r', 50, 0.8, 1.2, 0;...
        'fwhm', 5, 0.8, 1.2, 0;};
    return
else
    if numel(varargin)<3
        disp('EEEEEEEEEEEERRRRRRRRRRRRRRRRRR')
        return
    end
    if iscell(varargin{1})
        param = varargin{1};
        cut = varargin{2};
        var = varargin{3};
        p=cell2struct(param(:,2)', param(:,1)',2);
        r = p.r;
        fwhm = p.fwhm;
        isgifit = 1;
    else
        q = varargin{1};
        r = varargin{2};
        fwhm = varargin{3};
    end
end
% schultzspherefunction
% y = SchultzSphereFun(q, r,fwhm)
if isgifit
    y = cut(:,4);
end