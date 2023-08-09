function k=visualsphere(R, vectA, color, sphereline,isshell)
% visualsphere(R, vectA, color, sphereline)
vectA = reducehkl(vectA);
%[xS, yS] = size(vectA);
if nargin <= 3
    sphereline = 15;
end
if nargin <=4
    isshell = 0;
end

col = unique(R);
colormap = {[1, 0, 0], [0, 1, 0], [0, 0, 1], [1, 1, 0], [1, 0, 1], [0, 1, 1]};
if numel(vectA) == 3
    % ======================== circle
    [x, y, z] = sphere(sphereline);x = x*R(1);y = y*R(1); z = z*R(1);
%    t = find(x<0);
%x(:, 12:21)=[];y(:, 12:21)=[];z(:, 12:21)=[];

    x = x+vectA(1);y=y+vectA(2);z=z+vectA(3);
    if nargin < 3
        k=mesh(x, y, z, 'edgecolor', 'r');
    else
%        k=mesh(x, y, z, 'edgecolor', color, 'facecolor', color, 'facelighting','phong');
        if ~isshell
            k=mesh(x, y, z, 'facecolor', color, 'edgecolor', 'none');
        else
            %k=mesh(x, y, z, 'facecolor', 'none', 'edgecolor', color);
            k=mesh(x, y, z, 'facecolor', color, 'edgecolor', 'none');
            set(k, 'Facealpha', 0.2)
        end
    end    
elseif numel(vectA) > 3
    for i=1:numel(vectA)/3
        if numel(R) == numel(vectA)/3
            radius = R(i);
            colorcode = colormap{col == R(i)};
        else
            if nargin>2
                radius = R;
                colorcode = color;
            else
                radius = R;
                colorcode = colormap(1);
            end
        end
        k(i) = visualsphere(radius, vectA(i, :), colorcode, sphereline, isshell);
        hold on        ;
    end
end
    
axis tight;axis image;
%view(0,0)
axis vis3d;
set(gca, 'DataAspectRatio' , [1 1 1]);
if isempty(findobj(gca, 'type', 'light'))
    camlight left; 
end
lighting phong;