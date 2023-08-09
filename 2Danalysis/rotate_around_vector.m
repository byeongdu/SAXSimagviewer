function varargout = rotate_around_vector(varargin)
% [obj, R] = rotate_around_vector(obj, u, theta)
% [R] = rotate_around_vector(u, theta)
% [obj, R] = rotate_around_vector(obj, u, centerofmass, theta)
% Rodrigues' rotation matrix
% rotate a object around an axis u by an angle theta.
% 
% example 1: rotate_around_vector(obj, u, theta)
% obj = [1,2,3;
%4,5,6;
%7,8,9;
%10,11,12;
%...
%    ]
% u = [1,1,1];
% theta = 90 degree
% example 2: rotate_around_vector(u, theta)
% then it will return the rotation matrix.
cm = [0,0,0];
if numel(varargin) == 3
    obj = varargin{1};
    u = varargin{2}; 
    theta = varargin{3};
elseif numel(varargin) == 4
    obj = varargin{1};
    u = varargin{2}; 
    cm = varargin{3}; 
    theta = varargin{4};
elseif numel(varargin) == 2
    u = varargin{1}; 
    theta = varargin{2};
elseif numel(varargin) == 1
    u = varargin{1}; 
    theta = 90;
end
u = u/norm(u);
u = u(:)';
P = u'*u;
I = [1,0,0;0,1,0;0,0,1];
Q = [0,-u(3),u(2);u(3),0,-u(1);-u(2),u(1),0];
    
R = P + (I-P)*cos(theta*pi/180) + Q*sin(theta*pi/180);

if numel(varargin) <3
    varargout{1} = R;
else
    if ~isnumeric(obj)
        for i=1:numel(obj)
            if strcmpi(obj(i).Type, 'patch')
                V = obj(i).Vertices - cm; %[obj(i).XData(:)'-cm(1);obj(i).YData(:)'-cm(2);obj(i).ZData(:)'-cm(3)];
                Vn = R*V';Vn=Vn';
                obj(i).Vertices = Vn+cm;
            else
                if isprop(obj(i), 'XData')
                    if ~isnumeric(obj(i))
                        sz = size(obj(i).XData);
                        V = [obj(i).XData(:)'-cm(1);obj(i).YData(:)'-cm(2);obj(i).ZData(:)'-cm(3)];
                        Vn = R*V;
                        XD = reshape(Vn(1, :)+cm(1), sz);
                        YD = reshape(Vn(2, :)+cm(2), sz);
                        ZD = reshape(Vn(3, :)+cm(3), sz);
                        warning off
                        set(obj(i), 'XData', XD, 'YData', YD, 'ZData', ZD);
                        warning on
                    else
                        xd = get(obj(i), 'XData')-cm(1);
                        yd = get(obj(i), 'YData')-cm(2);
                        zd = get(obj(i), 'ZData')-cm(3);
                        V = [xd;yd;zd];
                        Vn = R*V;
                        set(obj(i), 'XData', Vn(1, :)+cm(1));
                        set(obj(i), 'YData', Vn(2, :)+cm(2));
                        set(obj(i), 'ZData', Vn(3, :)+cm(3));
                    end
                else
                    continue
                end
            end
        end
    else
        obj = obj*R';
    end
    varargout{1} = obj;
    varargout{2} = R;
end 